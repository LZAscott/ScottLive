//
//  Demo5ViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/12/5.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "Demo5ViewController.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>


@interface Demo5ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *personImv;
@property (nonatomic, strong) CIImage *inputImage;
@property (nonatomic, strong) CIContext *context;

@end

@implementation Demo5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/// 人脸检测
- (IBAction)faceCheckClick:(UIButton *)sender {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:self.context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    CIFaceFeature *faceFeatures;
    
    // 图片方向
    NSString *string = self.inputImage.properties[(__bridge NSString *) kCGImagePropertyOrientation];
    if (string){    // 有方向
        faceFeatures = (CIFaceFeature *)[detector featuresInImage:self.inputImage options:@{CIDetectorImageOrientation:string}];
    }else { // 无方向
        faceFeatures = (CIFaceFeature *)[detector featuresInImage:self.inputImage];
    }
    
    // 1.调整frame，让图片正过来
    CGSize inputImageSize = self.inputImage.extent.size;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    
    for (CIFaceFeature *faceFeature in faceFeatures) {
        // 2.缩放bounds，适陪imageView;
        CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        
        CGFloat scale = MIN(self.personImv.bounds.size.width / inputImageSize.width, self.personImv.bounds.size.height / inputImageSize.height);
        CGFloat offsetX = (self.personImv.bounds.size.width - inputImageSize.width * scale) / 2;
        CGFloat offsetY = (self.personImv.bounds.size.height - inputImageSize.height * scale) / 2;
        
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        
        faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, scaleTransform);
        faceViewBounds.origin.x += offsetX;
        faceViewBounds.origin.y += offsetY;
        
        UIView *faceview = [[UIView alloc] initWithFrame:faceViewBounds];
        faceview.layer.borderColor = [UIColor orangeColor].CGColor;
        faceview.layer.borderWidth = 2;
        [self.personImv addSubview:faceview];
    }
}

/// 马赛克
- (IBAction)mosiacClick:(UIButton *)sender {
    // 1.用CIPixellate滤镜对原图先做个完全马赛克
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:self.inputImage forKey:kCIInputImageKey];
    // 打满马赛克的图片
    CIImage *fullPixellatedImage = filter.outputImage;
    // 2.检测人脸，并保存在faceFeatures中
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:self.context options:nil];
    
    CIFaceFeature *faceFeatures;
    
    // 图片方向
    NSString *string = self.inputImage.properties[(__bridge NSString *) kCGImagePropertyOrientation];
    if (string){    // 有方向
        faceFeatures = (CIFaceFeature *)[detector featuresInImage:self.inputImage options:@{CIDetectorImageOrientation:string}];
    }else { // 无方向
        faceFeatures = (CIFaceFeature *)[detector featuresInImage:self.inputImage];
    }
    
    // 3.初始化蒙版图，并开始遍历检测到的所有人脸
    CIImage *maskImage;
    
    for (CIFaceFeature *faceFeature in faceFeatures) {
        // 4.由于我们要基于人脸的设置，为每一张脸都单独的创建一个蒙版，所以要计算出脸的中心点，对应的x,y，再基于脸的宽高给一个半径，最后用这些计算结果初始化一个CIRadialGradient滤镜（我将inputColor1的alpha赋值为0，表示将这些颜色值设为透明，因为我不关心除了蒙版以外的颜色，这点和苹果官网中的例子不一样，苹果将其赋值为了1）
        CGFloat centerX = faceFeature.bounds.origin.x + faceFeature.bounds.size.width / 2;
        CGFloat centerY = faceFeature.bounds.origin.y + faceFeature.bounds.size.height / 2;
        
        CGFloat scale = MIN(self.personImv.bounds.size.width/self.inputImage.extent.size.width , self.personImv.bounds.size.height/self.inputImage.extent.size.height);
        
        CGFloat radius = MIN(faceFeature.bounds.size.width, faceFeature.bounds.size.height)*scale;
        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" withInputParameters:@{@"inputRadius0":[NSNumber numberWithFloat:radius],@"inputRadius1":[NSNumber numberWithFloat:radius+1],@"inputColor0":[CIColor colorWithRed:0 green:1 blue:0 alpha:1],@"inputColor1":[CIColor colorWithRed:0 green:0 blue:0 alpha:0],kCIInputCenterKey:[CIVector vectorWithX:centerX Y:centerY]}];
        
        // 5.由于CIRadialGradient滤镜创建的是一张无限大小的图，所以在使用之前先对它进行裁剪（苹果官网例子中没有对其裁剪。。），然后把每一张脸的蒙版图合在一起
        CIImage *radialGradientOutputImage = [radialGradient.outputImage imageByCroppingToRect:self.inputImage.extent];
        
        
        if (maskImage == nil) {
            maskImage = radialGradientOutputImage;
        } else {
            maskImage = [CIFilter filterWithName:@"CISourceOverCompositing" withInputParameters:@{kCIInputImageKey:radialGradientOutputImage,kCIInputBackgroundImageKey:maskImage}].outputImage;
        }
    }
    
    // 6.用CIBlendWithMask滤镜把马赛克图、原图、蒙版图混合起来
    CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [blendFilter setValue:fullPixellatedImage forKey:kCIInputImageKey];
    [blendFilter setValue:self.inputImage forKey:kCIInputBackgroundImageKey];
    [blendFilter setValue:maskImage forKey:kCIInputMaskImageKey];
    
    // 7.输出，在界面上显示
    CIImage *blendOutputImage = blendFilter.outputImage;
    CGImageRef blendCGImage = [self.context createCGImage:blendOutputImage fromRect:blendOutputImage.extent];
    
    self.personImv.image = [UIImage imageWithCGImage:blendCGImage];
}

#pragma mark - lazy
- (CIContext *)context {
    if (!_context) {
        _context = [[CIContext alloc] init];
    }
    return _context;
}

- (CIImage *)inputImage {
    if (!_inputImage) {
        UIImage *image = [[UIImage imageNamed:@"demo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _inputImage = [[CIImage alloc] initWithImage:image];
    }
    return _inputImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
