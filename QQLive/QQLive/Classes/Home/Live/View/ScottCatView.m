//
//  ScottCatView.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/28.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottCatView.h"
#import "ScottLiveModel.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UIView+ScottFrame.h"

@interface ScottCatView ()

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;

@end

@implementation ScottCatView

+ (instancetype)catView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.playerView.layer.cornerRadius = self.playerView.scott_width * 0.5;
    self.playerView.layer.masksToBounds = YES;
}

- (void)setLiveModel:(ScottLiveModel *)liveModel {
    _liveModel = liveModel;
    
    IJKFFOptions *option = [IJKFFOptions optionsByDefault];
    [option setPlayerOptionValue:@"1" forKey:@"an"];
    // 开启硬解码
    [option setPlayerOptionValue:@"1" forKey:@"videotoolbox"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:liveModel.flv withOptions:option];
    
    moviePlayer.view.frame = self.playerView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放
    moviePlayer.shouldAutoplay = YES;
    
    [self.playerView addSubview:moviePlayer.view];
    
    [moviePlayer prepareToPlay];
    self.moviePlayer = moviePlayer;
}

- (void)removeFromSuperview {
    if (_moviePlayer) {
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
    }
    [super removeFromSuperview];
}

@end
