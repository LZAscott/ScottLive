//
//  ScottH264Encoder.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottH264Encoder.h"

@interface ScottH264Encoder() {
    NSString *_yuvFile;
    VTCompressionSessionRef _EncodingSession;
    dispatch_queue_t _aQueue;
    CMFormatDescriptionRef  _format;
    CMSampleTimingInfo *_timingInfo;
    int  _frameCount;
    NSData *_sps;
    NSData *_pps;
}

@end

@implementation ScottH264Encoder

- (void) initWithConfiguration {
    _EncodingSession = nil;
    _aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _frameCount = 0;
    _sps = NULL;
    _pps = NULL;
}

void didCompressH264(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags,
                     CMSampleBufferRef sampleBuffer )
{
    if (status != 0) return;
    // 采集的未编码数据是否准备好
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog(@"didCompressH264 data is not ready ");
        return;
    }
    ScottH264Encoder *encoder = (__bridge ScottH264Encoder *)outputCallbackRefCon;
    
    bool keyframe = !CFDictionaryContainsKey((CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);
    
    if (keyframe) { // 关键帧
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 0, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0 );
        if (statusCode == noErr) {
            size_t pparameterSetSize, pparameterSetCount;
            const uint8_t *pparameterSet;
            OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 1, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0 );
            if (statusCode == noErr){
                encoder->_sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                encoder->_pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
                NSLog(@"sps:%@ , pps:%@", encoder->_sps, encoder->_pps);
            }
        }
    }
    
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
    if (statusCodeRet == noErr) {
        
        size_t bufferOffset = 0;
        static const int AVCCHeaderLength = 4;
        while (bufferOffset < totalLength - AVCCHeaderLength) {
            uint32_t NALUnitLength = 0;
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            NSData *data = [[NSData alloc] initWithBytes:(dataPointer + bufferOffset + AVCCHeaderLength) length:NALUnitLength];
            bufferOffset += AVCCHeaderLength + NALUnitLength;
            NSLog(@"sendData-->> %@ %lu", data, bufferOffset);
        }
        
    }
    
}


- (void)initEncode:(int)width height:(int)height {
    dispatch_sync(_aQueue, ^{
        OSStatus status = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, didCompressH264, (__bridge void *)(self),  &_EncodingSession);
        if (status != 0){
            NSLog(@"Error by VTCompressionSessionCreate ");
            return ;
        }
        
        VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_4_1);
        
        SInt32 bitRate = width*height*50;  //越高效果越好  帧数据越大
        CFNumberRef ref = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
        VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_AverageBitRate, ref);
        CFRelease(ref);
        
        int frameInterval = 10; //关键帧间隔 越低效果越好 帧数据越大
        CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
        VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval,frameIntervalRef);
        CFRelease(frameIntervalRef);
        VTCompressionSessionPrepareToEncodeFrames(_EncodingSession);
    });
}

- (void)encode:(CMSampleBufferRef )sampleBuffer {
    if (_EncodingSession == nil|| _EncodingSession == NULL) {
        return;
    }
    dispatch_sync(_aQueue, ^{
        _frameCount++;
        CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
        CMTime presentationTimeStamp = CMTimeMake(_frameCount, 1000);
        VTEncodeInfoFlags flags;
        OSStatus statusCode = VTCompressionSessionEncodeFrame(_EncodingSession, imageBuffer, presentationTimeStamp, kCMTimeInvalid, NULL, NULL, &flags);
        if (statusCode != noErr){
            if (_EncodingSession != nil|| _EncodingSession != NULL){
                VTCompressionSessionInvalidate(_EncodingSession);
                CFRelease(_EncodingSession);
                _EncodingSession = NULL;
                return;
            }
        }
    });
}

@end
