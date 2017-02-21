//
//  ScottLivingCollectionCell.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottLivingCollectionCell.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <BarrageRenderer/BarrageRenderer.h>
#import "UIScreen+ScottExtension.h"
#import "ScottLiveModel.h"
#import "ScottLivingBottomView.h"
#import "ScottLivingEndView.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "UIImage+ScottExtension.h"
#import "UIColor+ScottExtension.h"
#import "ScottLivingTopView.h"
#import "UIView+ScottFrame.h"
#import "ScottCatView.h"
#import "UIViewController+ScottGif.h"
#import "ScottNetworkTool.h"
#import "NSSafeObject.h"

@interface ScottLivingCollectionCell (){
    NSTimer *_timer;
}

@property (nonatomic, strong) ScottLivingTopView *topView;
@property (nonatomic, strong) ScottCatView *catView;


/// 弹幕
@property (nonatomic, strong) BarrageRenderer *renderer;
/// 直播播放器
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
/// 直播开始前占位图
@property (nonatomic, strong) UIImageView *placeholderImg;
/// 工具栏
@property (nonatomic, strong) ScottLivingBottomView *toolView;
/// 直播结束界面
@property (nonatomic, strong) ScottLivingEndView *endView;
/// 粒子发射器
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;


@end

@implementation ScottLivingCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (void)setupUI {
    self.toolView.hidden = NO;
    _renderer = [[BarrageRenderer alloc] init];
    _renderer.canvasMargin = UIEdgeInsetsMake([UIScreen scott_screenHeight] * 0.3, 10, 10, 10);
    [self.contentView addSubview:_renderer.view];
    
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
}

- (void)setLive:(ScottLiveModel *)live {
    _live = live;
    
    self.topView.liveModel = live;
    // 播放视频
    [self playFLV:live.flv andPlacehoderImageUrl:live.bigpic];
}

- (void)setRelateLive:(ScottLiveModel *)relateLive {
    _relateLive = relateLive;
    
    if (relateLive) {
        self.catView.liveModel = relateLive;
    }else{
        self.catView.hidden = YES;
    }
}

- (void)playFLV:(NSString *)flv andPlacehoderImageUrl:(NSString *)placehoderUrl {
    if (_moviePlayer) {
        [self.contentView insertSubview:self.placeholderImg belowSubview:_moviePlayer.view];
        
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    if (_catView) {
        [_catView removeFromSuperview];
        _catView = nil;
    }
    
    if (_emitterLayer) {    // 如果粒子动画存在，先移除
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placehoderUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.parentVC showLoading:nil inView:self.placeholderImg];
            self.placeholderImg.image = [UIImage scott_blurImage:image blur:0.8];  // 赋值占位图
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:flv withOptions:options];
    moviePlayer.view.frame = [UIScreen scott_screenBounds];
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    moviePlayer.shouldAutoplay = NO;
    // 默认不显示
    moviePlayer.shouldShowHudView = NO;
    
    [self.contentView insertSubview:moviePlayer.view atIndex:0];
    
    [moviePlayer prepareToPlay];
    
    self.moviePlayer = moviePlayer;
    
    [self addObeserverInMoviePlayer];
    
    // 开始粒子动画
    [self.emitterLayer setHidden:NO];
}

/// 设置监听
- (void)addObeserverInMoviePlayer {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieLoadStateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

/// 播放结束
- (void)moviePlayDidFinish {
    
    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && self.parentVC.gifView) {
        [self.parentVC showLoading:nil inView:self.moviePlayer.view];
        return;
    }
    
    // 方法：
    // 1、重新获取直播地址，服务端控制是否有地址返回。
    // 2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    __weak typeof(self)weakSelf = self;
    [[ScottNetworkTool shareTools] requestWithMethod:GET andURLString:self.live.flv parameters:nil finishCallBack:^(id result, NSError *error) {
        if (!error) return;
        [weakSelf.moviePlayer shutdown];
        [weakSelf.moviePlayer.view removeFromSuperview];
        weakSelf.moviePlayer = nil;
        weakSelf.endView.hidden = NO;
    }];
}

/// 播放状态改变
- (void)movieLoadStateDidChange {
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.moviePlayer.isPlaying) {
            [self.moviePlayer play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeholderImg) {
                    [_placeholderImg removeFromSuperview];
                    _placeholderImg = nil;
                    [self.moviePlayer.view addSubview:_renderer.view];
                }
                [self.parentVC hiddenLoading];
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            if (self.parentVC.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.parentVC hiddenLoading];
                });
            }
        }
    }else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        [self.parentVC showLoading:nil inView:self.moviePlayer.view];
    }

}
/// 点击关闭
- (void)closeDidClick {
    
    if (_catView) {
        [_catView removeFromSuperview];
        _catView = nil;
    }
    
    if (_moviePlayer) {
        [self.moviePlayer shutdown];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [self.renderer stop];
    [self.renderer.view removeFromSuperview];
    self.renderer = nil;
    [self.parentVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickCatView {
    !self.clickCatViewBlock ? : self.clickCatViewBlock();
}

/// 发送弹幕
- (void)autoSendBarrage {
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}

- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction {
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = [UIColor scott_randomColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        NSLog(@"弹幕被点击");
    };
    return descriptor;
}

#pragma mark - lazy
- (UIImageView *)placeholderImg {
    if (!_placeholderImg) {
        _placeholderImg = [[UIImageView alloc] init];
        _placeholderImg.frame = CGRectMake(0, 0, [UIScreen scott_screenWidth], [UIScreen scott_screenHeight]);
        _placeholderImg.image = [UIImage imageNamed:@"profile_user_414x414"];
        [self.contentView addSubview:_placeholderImg];
        [self.parentVC showLoading:nil inView:_placeholderImg];
        // 强制布局
        [_placeholderImg layoutIfNeeded];
    }
    return _placeholderImg;
}

- (ScottLivingTopView *)topView {
    if (!_topView) {
        _topView = [ScottLivingTopView livingTopView];
        _topView.frame = CGRectMake(0, 0, [UIScreen scott_screenWidth], 120);
        [self.contentView insertSubview:_topView aboveSubview:self.placeholderImg];
    }
    return _topView;
}

- (ScottCatView *)catView {
    if (!_catView) {
        _catView = [ScottCatView catView];
        _catView.frame = CGRectMake(self.moviePlayer.view.scott_width-(98+30), 0, 98, 98);
        _catView.scott_centerY = self.moviePlayer.view.scott_centerY;
        [_catView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCatView)]];
        [self.moviePlayer.view addSubview:_catView];
    }
    return _catView;
}

bool _publicTalkIsSelected = NO;

- (ScottLivingBottomView *)toolView {
    if (!_toolView) {
        _toolView = [[ScottLivingBottomView alloc] initWithFrame:CGRectMake(0, [UIScreen scott_screenHeight]-50, [UIScreen scott_screenWidth], 40)];
        
        __weak typeof(self) weakSelf = self;
        _toolView.livBottomClickBlock = ^(LiveBottomToolType type){
            switch (type) {
                case LiveBottomToolTypePublicTalk:{// 弹幕
                    
                    _publicTalkIsSelected = !_publicTalkIsSelected;
                    _publicTalkIsSelected ? [weakSelf.renderer start] : [weakSelf.renderer stop];
                }
                    break;
                case LiveBottomToolTypePrivateTalk:{// 私聊
                    
                }
                    break;
                case LiveBottomToolTypeGift:{// 礼物
                    
                }
                    break;
                case LiveBottomToolTypeRank:{// 排行榜
                    
                }
                    break;
                case LiveBottomToolTypeShare:{// 分享
                    
                }
                    break;
                case LiveBottomToolTypeClose:{// 关闭
                    [weakSelf closeDidClick];
                }
                    break;
                    
                default:
                    break;
            }
        };
        [self.contentView insertSubview:_toolView aboveSubview:self.placeholderImg];
    }
    return _toolView;
}

- (ScottLivingEndView *)endView {
    if (!_endView) {
        _endView = [ScottLivingEndView liveEndView];
        _endView.frame = [UIScreen scott_screenBounds];
        [self.contentView addSubview:_endView];
        
        __weak typeof(self) weakSelf = self;
        _endView.lookOtherBlock = ^(){
            [weakSelf clickCatView];
        };
        
        _endView.closeBlock = ^(){
            [weakSelf closeDidClick];
        };
    }
    return _endView;
}

- (CAEmitterLayer *)emitterLayer {
    if (!_emitterLayer) {
        _emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        _emitterLayer.emitterPosition = CGPointMake(self.moviePlayer.view.scott_width-50,self.moviePlayer.view.scott_height-50);
        // 发射器的尺寸大小
        _emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        _emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }
        
        _emitterLayer.emitterCells = array;
        [self.moviePlayer.view.layer insertSublayer:_emitterLayer below:self.catView.layer];
    }
    return _emitterLayer;
}

/// 弹幕资源
- (NSArray *)danMuText {
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}



@end
