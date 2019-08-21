//
//  MECourseAudioPlayerVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseAudioPlayerVC.h"
#import "MECourseDetailModel.h"
#import "MEOnlineCourseListModel.h"
#import <AVFoundation/AVFoundation.h>
#import "MEDiagnosePromptView.h"
#import "MEOnlineDiagnoseVC.h"
#import "MEFeedBackVC.h" 

@interface MECourseAudioPlayerVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnConsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConsHeight;

@property (nonatomic, strong) MECourseDetailModel *model;
@property (nonatomic, strong) NSArray *audioList;
@property (nonatomic, strong) NSArray *itemsArr;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, strong) id timeObserver;

@end

@implementation MECourseAudioPlayerVC

- (instancetype)initWithModel:(MECourseDetailModel *)model audioList:(NSArray *)audioList{
    if (self = [super init]) {
        self.model = model;
        self.audioList = audioList;
    }
    return self;
}

- (void)dealloc {
    [self destroyPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBarHidden = YES;
    self.isFinished = NO;
    _backBtnConsTop.constant = kMeStatusBarHeight;
    _bottomViewConsHeight.constant += kMeTabbarSafeBottomMargin;
    
    kSDLoadImg(_headerPic, kMeUnNilStr(self.model.images_url));
    _nameLbl.text = kMeUnNilStr(self.model.audio_name);
    
    NSArray *btns = @[@{@"title":@"分享",@"image":@"icon_share"},@{@"title":@"收藏",@"image":@"icon_collection_nor"},@{@"title":@"咨询",@"image":@"icon_consult_white"}];
    CGFloat btnHeight = 49;
    CGFloat btnWidth = 60;
    for (int i = 0; i < btns.count; i++) {
        NSDictionary *dict = btns[i];
        UIButton *btn = [self createButtonWithTitle:dict[@"title"] normalImage:dict[@"image"] tag:100+i];
        if (i == 1) {
            if (self.model.is_collection == 1) {
                [btn setImage:[UIImage imageNamed:@"icon_collection_sel"] forState:UIControlStateNormal];
            }
        }
        btn.frame = CGRectMake((SCREEN_WIDTH-btnWidth)/2*i, 0, btnWidth, btnHeight);
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-8, 10, 8, -10)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(12, -10, -12, 10)];
        [_bottomView addSubview:btn];
    }
    
    _sliderView.value = 0.0;
    self.index = 0;
    
    [self addPlayerListener];
}

//添加监听文件,所有的监听
- (void)addPlayerListener {
    
    if (self.playerItem) {
        //播放状态监听
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        //缓冲进度监听
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        //播放中监听，更新播放进度
        __weak typeof(self) weakSelf = self;
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            kMeSTRONGSELF
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds(strongSelf.playerItem.duration);
//            float currentPlayTime = (double)strongSelf.playerItem.currentTime.value/strongSelf.playerItem.currentTime.timescale;
//            if (strongSelf.playerItem.currentTime.value<0) {
//                currentPlayTime = 0.1; //防止出现时间计算越界问题
//            }
            strongSelf.sliderView.value = current/total;
            strongSelf.startTimeLbl.text = [strongSelf getTimeStringWithNSTimeInterval:current];
            if (strongSelf.listenTime > 0) {
                if (current >= strongSelf.listenTime) {
                    [strongSelf.player pause];
                    strongSelf->_playBtn.selected = NO;
                    [strongSelf.player seekToTime:kCMTimeZero];
                    [MEShowViewTool showMessage:@"试听已结束" view:strongSelf.view];
                }
            }
        }];
        
    }
    
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //监听应用后台切换
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnteredBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    //播放中被打断
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
}

//销毁player,无奈之举 因为avplayeritem的置空后依然缓存的问题。
- (void)destroyPlayer {
    [self.player pause];
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.player removeTimeObserver:self.timeObserver];

        self.playerItem = nil;
        self.player = nil;
    }
    
    _sliderView.value = 0;
    self.startTimeLbl.text = @"00:00";
    self.endTimeLbl.text = @"00:00";
}

- (NSString *)getTimeStringWithNSTimeInterval:(NSTimeInterval)timeInterval{
    NSInteger min = timeInterval/60;
    NSInteger sec = (NSInteger)timeInterval%60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

#pragma mark --- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                [self.player pause];
                NSLog(@"未知状态");
                break;
            case AVPlayerStatusReadyToPlay:
                self.endTimeLbl.text = [self getTimeStringWithNSTimeInterval:CMTimeGetSeconds(item.duration)];
                
                [self.player play];
                _playBtn.selected = YES;
                NSLog(@"准备播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"加载失败");
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *timeRanges = self.player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时长
        float duration = CMTimeGetSeconds(self.player.currentItem.duration);
        //计算缓冲百分比例
        float scale = totalLoadTime/duration;
        
        //更新缓冲进度条
//        self.sliderView.value = scale;
    }
}

#pragma mark 监听播放完成事件
-(void)playerFinished:(NSNotification *)notification{
    NSLog(@"播放完成");
    [self.playerItem seekToTime:kCMTimeZero];
    if (self.player) {
        _playBtn.selected = NO;
        [self.player pause];
        [self showPromptView];
    }
}

#pragma mark 播放被打断
- (void)handleInterruption:(NSNotification *)notification {
    if (self.player) {
        _playBtn.selected = NO;
        [self.player pause];
    }
}

#pragma mark 进入后台，暂停音频
- (void)appEnteredBackground {
    if (self.player) {
        _playBtn.selected = NO;
        [self.player pause];
    }
}

- (void)showPromptView {
    //弹窗提示诊断
    if (self.model.is_diagnosis_report == 0) {
        kMeWEAKSELF
        [MEDiagnosePromptView showDiagnosePromptViewWithSuccessBlock:^{
            kMeSTRONGSELF
            MEOnlineDiagnoseVC *diagnoseVC = [[MEOnlineDiagnoseVC alloc] init];
            [strongSelf.navigationController pushViewController:diagnoseVC animated:YES];
        } superView:self.view];
    }
}

#pragma mark --- Action
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)playBtnAction:(id)sender {
    _playBtn.selected = !_playBtn.selected;
    if (_playBtn.selected) {
        if (self.isFinished) {
            //若播放完成，则重播
            [self.player seekToTime:kCMTimeZero];
        }
        [_player play];
    }else {
        [_player pause];
        [self showPromptView];
    }
}
- (IBAction)frontBtnAction:(id)sender {
//    [self.player pause];
//    [self destroyPlayer];
//    if (self.index == 0) {
//        self.index = self.itemsArr.count - 1;
//    }else {
//        self.index--;
//    }
//    [self.player replaceCurrentItemWithPlayerItem:self.itemsArr[self.index]];
//    [self addPlayerListener];
//    [self.player play];
}
- (IBAction)nextBtnAction:(id)sender {
//    [self.player pause];
//    [self destroyPlayer];
//    if (self.index == self.itemsArr.count - 1) {
//        self.index = 0;
//    }else {
//        self.index++;
//    }
//    [self.player replaceCurrentItemWithPlayerItem:self.itemsArr[self.index]];
//    [self addPlayerListener];
//    [self.player play];
}
- (IBAction)silderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [self.player pause];
    //根据值计算时间
    float time = slider.value * CMTimeGetSeconds(self.player.currentItem.duration);
    //跳转到当前指定时间
    [self.player seekToTime:CMTimeMake(time, 1)];
    _playBtn.selected = YES;
    [self.player play];
}

- (void)bottomBtnDidClick:(UIButton *)sender {
    switch (sender.tag-100) {
        case 0:
        {
            self.playBtn.selected = NO;
            [self.player pause];
            
            MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
            NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
            baseUrl = [@"http" stringByAppendingString:baseUrl];
            
            //https://test.meshidai.com/bargaindist/newAuth.html?id=7&uid=xxx
//            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@bargaindist/newAuth.html?id=%ld&uid=%@&inviteCode=%@",baseUrl,(long)self.model.audio_id,kMeUnNilStr(kCurrentUser.uid),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            
            shareTool.shareTitle = kMeUnNilStr(self.model.audio_name);
            shareTool.shareDescriptionBody = kMeUnNilStr(self.model.audio_desc);
            shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(self.model.audio_images)]]];
            
            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
            } failure:^(NSError *error) {
                [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
            }];
        }
            break;
        case 1:
            [self collectionAudioWithNetWorking];
            break;
        case 2:
        {
            self.playBtn.selected = NO;
            [self.player pause];
            MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc] initWithType:1];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//收藏与取消收藏
- (void)collectionAudioWithNetWorking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postSetCollectionWithCollectionId:self.model.audio_id type:2 SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MEShowViewTool showMessage:kMeUnNilStr(responseObject.message) view:kMeCurrentWindow];
        if (strongSelf.model.is_collection == 1) {
            strongSelf.model.is_collection = 2;
        }else {
            strongSelf.model.is_collection = 1;
        }
        [self reloadBottomView];
    } failure:^(id object) {
    }];
}

- (void)reloadBottomView {
    for (id obj in _bottomView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == 101) {
                if (self.model.is_collection == 1) {
                    [btn setImage:[UIImage imageNamed:@"icon_collection_sel"] forState:UIControlStateNormal];
                }else {
                    [btn setImage:[UIImage imageNamed:@"icon_collection_nor"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title normalImage:(NSString *)normalImage tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#393939"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    btn.tag = tag;
    [btn addTarget:self action:@selector(bottomBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma setter&&getter
- (AVPlayerItem *)playerItem {
    if (!_playerItem) {
        _playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:kMeUnNilStr(self.model.audio_urls)]];
    }
    return _playerItem;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    }
    return _player;
}

- (NSArray *)itemsArr {
    if (!_itemsArr) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [temp addObject:self.player.currentItem];
        [self.audioList enumerateObjectsUsingBlock:^(MEOnlineCourseListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:kMeUnNilStr(model.audio_urls)]];
            [temp addObject:item];
        }];
        _itemsArr = [temp copy];
    }
    return _itemsArr;
}

@end
