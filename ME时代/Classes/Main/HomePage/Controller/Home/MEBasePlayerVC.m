//
//  MEBasePlayerVC.m
//  ME时代
//
//  Created by hank on 2019/4/14.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBasePlayerVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface MEBasePlayerVC (){
    NSString *_url;
}
@property (nonatomic,strong) AVPlayerViewController *avPlayerVC;

@end

@implementation MEBasePlayerVC

- (void)dealloc{
    
}

- (instancetype)initWithFileUrl:(NSString *)str{
    if(self = [super init]){
        _url = str;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频播放";
    NSString *webVideoPath = kMeUnNilStr(_url);
    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    //步骤2：创建AVPlayer
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    self.avPlayerVC =[[AVPlayerViewController alloc] init];
    self.avPlayerVC.player = avPlayer;
    //步骤4：设置播放器视图大小
    self.avPlayerVC.view.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight);
    //特别注意:AVPlayerViewController不能作为局部变量被释放，否则无法播放成功
    //解决1.AVPlayerViewController作为属性
    //解决2:使用addChildViewController，AVPlayerViewController作为子视图控制器
    [self addChildViewController:self.avPlayerVC];
    [self.view addSubview:self.avPlayerVC.view];
    if (self.avPlayerVC.readyForDisplay) {
        [self.avPlayerVC.player play];
    }
}



@end
