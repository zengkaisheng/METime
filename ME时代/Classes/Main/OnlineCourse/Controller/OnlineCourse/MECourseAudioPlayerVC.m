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

#import "MECustomBuyCourseView.h"
#import "MEPayStatusVC.h"
#import "MEMyOrderDetailVC.h"

#import "MEPersionalCourseDetailModel.h"
#import "MEVIPViewController.h"
#import "MEPersonalCourseListModel.h"
#import "MEMyCourseVIPModel.h"

@interface MECourseAudioPlayerVC (){
    NSString *_order_sn;
    NSString *_order_amount;
    BOOL _isPayError;//防止跳2次错误页面
    BOOL _isShowBuy;
}

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

@property (nonatomic, strong) MEPersionalCourseDetailModel *detailModel;
@property (nonatomic, assign) BOOL isC;

@property (nonatomic, strong) MEMyCourseVIPModel *vipModel;
@end

@implementation MECourseAudioPlayerVC

- (instancetype)initWithModel:(MECourseDetailModel *)model audioList:(NSArray *)audioList{
    if (self = [super init]) {
        self.model = model;
        self.audioList = audioList;
        self.isC = NO;
    }
    return self;
}
//C端课程
- (instancetype)initWithCourseModel:(MEPersionalCourseDetailModel *)model audioList:(NSArray *)audioList {
    if (self = [super init]) {
        self.detailModel = model;
        self.audioList = audioList;
        self.isC = YES;
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
    _isShowBuy = YES;
    _backBtnConsTop.constant = kMeStatusBarHeight;
    _bottomViewConsHeight.constant += kMeTabbarSafeBottomMargin;
    
    CGFloat btnWidth = SCREEN_WIDTH/4;
    NSArray *btns = @[@{@"title":@"分享",@"image":@"icon_share"},@{@"title":@"收藏",@"image":@"icon_collection_nor"},@{@"title":@"咨询",@"image":@"icon_consult_white"},@{@"title":@"诊断",@"image":@"icon_diagnose"}];
    
    if (self.isC) {
        kSDLoadImg(_headerPic, kMeUnNilStr(self.detailModel.courses_images));
        _nameLbl.text = kMeUnNilStr(self.detailModel.name);
        
        btnWidth = SCREEN_WIDTH/3;
        btns = @[@{@"title":@"分享",@"image":@"icon_share"},@{@"title":@"收藏",@"image":@"icon_collection_nor"},@{@"title":@"点赞",@"image":@"icon_courseLike_nor"}];
    }else {
        kSDLoadImg(_headerPic, kMeUnNilStr(self.model.images_url));
        _nameLbl.text = kMeUnNilStr(self.model.audio_name);
    }
    
    CGFloat btnHeight = 49;
    for (int i = 0; i < btns.count; i++) {
        NSDictionary *dict = btns[i];
        UIButton *btn = [self createButtonWithTitle:dict[@"title"] normalImage:dict[@"image"] tag:100+i];
        if (self.isC) {
            if (i == 1) {
                if (self.detailModel.is_collection == 1) {
                    [btn setImage:[UIImage imageNamed:@"icon_collection_sel"] forState:UIControlStateNormal];
                }
            }else if (i == 2) {
                if (self.detailModel.is_like == 1) {
                    [btn setImage:[UIImage imageNamed:@"icon_courseLike_sel"] forState:UIControlStateNormal];
                }
            }
        }else {
            if (i == 1) {
                if (self.model.is_collection == 1) {
                    [btn setImage:[UIImage imageNamed:@"icon_collection_sel"] forState:UIControlStateNormal];
                }
            }
        }
        
        btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, btnHeight);
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
                    if (!strongSelf->_isShowBuy) {
                        if (strongSelf.isC) {
                            [MECustomBuyCourseView showCustomBuyVIPViewWithTitle:@"试听结束" confirmBtn:@"购买VIP" buyBlock:^{
                                kMeSTRONGSELF
                                [strongSelf requestMyCourseVIPWithNetWork];
                            } cancelBlock:^{
                                
                            } superView:kMeCurrentWindow];
                        }else {
                            [MEShowViewTool showMessage:@"试听已结束" view:strongSelf.view];
                            [MECustomBuyCourseView showCustomBuyCourseViewWithTitle:kMeUnNilStr(strongSelf.model.audio_name) content:kMeUnNilStr(strongSelf.model.audio_price) buyBlock:^{
                                [strongSelf buyCourseWithNetworking];
                            } cancelBlock:^{
                                
                            } superView:kMeCurrentWindow];
                        }
                        strongSelf->_isShowBuy = YES;
                    }else {
                        strongSelf->_isShowBuy = NO;
                    }
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
        if (!self.isC) {
            [self showPromptView];
        }
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
        if (!self.isC) {
            [self showPromptView];
        }
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
            
            if (self.isC) {
                //http://test.meshidai.com/clientCourseShare/newAuth.html?id=18&inviteCode=P8786A
                shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@clientCourseShare/newAuth.html?id=%ld&inviteCode=%@",baseUrl,(long)self.detailModel.idField,[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
                
                shareTool.shareTitle = kMeUnNilStr(self.detailModel.name);
                shareTool.shareDescriptionBody = kMeUnNilStr(self.detailModel.desc);
                shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(self.detailModel.courses_images)]]];
            }else {
                //http://test.meshidai.com/audioShare/newAuth.html?id=2&inviteCode=222
                shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@audioShare/newAuth.html?id=%ld&inviteCode=%@",baseUrl,(long)self.model.audio_id,[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
                
                shareTool.shareTitle = kMeUnNilStr(self.model.audio_name);
                shareTool.shareDescriptionBody = kMeUnNilStr(self.model.audio_desc);
                shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(self.model.audio_images)]]];
            }
            NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            
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
            if (self.isC) {
                [self setLikeCourseWithNetWorking];
            }else {
                self.playBtn.selected = NO;
                [self.player pause];
                MEFeedBackVC *feedbackVC = [[MEFeedBackVC alloc] initWithType:1];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }
        }
            break;
        case 3:
        {
            self.playBtn.selected = NO;
            [self.player pause];
            MEOnlineDiagnoseVC *diagnoseVC = [[MEOnlineDiagnoseVC alloc] init];
            [self.navigationController pushViewController:diagnoseVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark -- networking
//获取B端C端VIP
- (void)requestMyCourseVIPWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCourseVIPWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.vipModel = [MEMyCourseVIPModel mj_objectWithKeyValues:responseObject.data];
            MEMyCourseVIPSubModel *c_vipModel = strongSelf.vipModel.C_vip;
            MEMyCourseVIPDetailModel *c_vip_detail = c_vipModel.vip.firstObject;
            MEVIPViewController *vc = [[MEVIPViewController alloc] initWithVIPModel:c_vip_detail];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }else{
            strongSelf.vipModel = nil;
        }
    } failure:^(id object) {
        //        kMeSTRONGSELF
    }];
}
//收藏与取消收藏
- (void)collectionAudioWithNetWorking {
    kMeWEAKSELF
    NSInteger courseId = 0;
    NSInteger type = 0;
    if (self.isC) {
        courseId = self.detailModel.idField;
        type = 3;
    }else {
        courseId = self.model.audio_id;
        type = 2;
    }
    [MEPublicNetWorkTool postSetCollectionWithCollectionId:courseId type:type SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MEShowViewTool showMessage:kMeUnNilStr(responseObject.message) view:kMeCurrentWindow];
        if (strongSelf.isC) {
            if (strongSelf.detailModel.is_collection == 1) {
                strongSelf.detailModel.is_collection = 2;
            }else {
                strongSelf.detailModel.is_collection = 1;
            }
        }else {
            if (strongSelf.model.is_collection == 1) {
                strongSelf.model.is_collection = 2;
            }else {
                strongSelf.model.is_collection = 1;
            }
        }
        [self reloadBottomView];
    } failure:^(id object) {
    }];
}

//点赞与取消点赞
- (void)setLikeCourseWithNetWorking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postSetLikeCourseWithCourseId:self.detailModel.idField SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MEShowViewTool showMessage:kMeUnNilStr(responseObject.message) view:kMeCurrentWindow];
        if (strongSelf.detailModel.is_like == 1) {
            strongSelf.detailModel.is_like = 2;
        }else {
            strongSelf.detailModel.is_like = 1;
        }
        [self reloadBottomView];
    } failure:^(id object) {
    }];
}

- (void)reloadDatas {
    kMeWEAKSELF
    if (self.isC) {
        [MEPublicNetWorkTool postGetCourseDetailWithCourseId:self.detailModel.idField successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                strongSelf.detailModel = [MEPersionalCourseDetailModel mj_objectWithKeyValues:responseObject.data];
            }else{
                strongSelf.model = nil;
            }
            //若播放完成，则重播
            [strongSelf.player seekToTime:kCMTimeZero];
            strongSelf.listenTime = 0;
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else {
        [MEPublicNetWorkTool postGetAudioDetailWithAudioId:self.model.audio_id successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                strongSelf.model = [MECourseDetailModel mj_objectWithKeyValues:responseObject.data];
            }else{
                strongSelf.model = nil;
            }
            //若播放完成，则重播
            [strongSelf.player seekToTime:kCMTimeZero];
            strongSelf.listenTime = 0;
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)buyCourseWithNetworking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postCreateOrderWithCourseId:[NSString stringWithFormat:@"%@",@(self.model.audio_id)] orderType:@"2" successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_order_sn = responseObject.data[@"order_sn"];
        strongSelf->_order_amount = responseObject.data[@"order_amount"];
        [MEPublicNetWorkTool postPayOnlineOrderWithOrderSn:strongSelf->_order_sn successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            PAYPRE
            strongSelf->_isPayError = NO;
            MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
            
            BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_order_amount];
            if(!isSucess){
                [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
            }
        } failure:^(id object) {
            
        }];
    } failure:^(id object) {
        
    }];
}

#pragma mark - Pay
- (void)WechatSuccess:(NSNotification *)noti{
    [self payResultWithNoti:[noti object] result:WXPAY_SUCCESSED];
}

- (void)payResultWithNoti:(NSString *)noti result:(NSString *)result{
    PAYJUDGE
    kMeWEAKSELF
    if ([noti isEqualToString:result]) {
        if(_isPayError){
            [self.navigationController popViewControllerAnimated:NO];
        }
        MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
            kMeSTRONGSELF
            MECourseAudioPlayerVC *vc = (MECourseAudioPlayerVC *)[MECommonTool getClassWtihClassName:[MECourseAudioPlayerVC class] targetVC:strongSelf];
            [vc reloadDatas];
            if(vc){
                [strongSelf.navigationController popToViewController:vc animated:YES];
            }else{
                [strongSelf.navigationController popToViewController:strongSelf animated:YES];
            }
        }];
        [self.navigationController pushViewController:svc animated:YES];
        NSLog(@"支付成功");
        _isPayError = NO;
    }else{
        if(!_isPayError){
            kMeWEAKSELF
            MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithFailRePayBlock:^{
                kMeSTRONGSELF
                [MEPublicNetWorkTool postPayOnlineOrderWithOrderSn:strongSelf->_order_sn successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                    
                    BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_order_amount];
                    if(!isSucess){
                        [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                    }
                } failure:^(id object) {
                    
                }];
            } CheckOrderBlock:^{
                kMeSTRONGSELF
                MEMyOrderDetailVC *vc = [[MEMyOrderDetailVC alloc]initWithType:MEAllNeedPayOrder orderGoodsSn:kMeUnNilStr(strongSelf->_order_sn)];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }];
            [self.navigationController pushViewController:svc animated:YES];
        }
        NSLog(@"支付失败");
        _isPayError = YES;
    }
}

- (void)reloadBottomView {
    for (id obj in _bottomView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (self.isC) {
                if (btn.tag == 101) {
                    if (self.detailModel.is_collection == 1) {
                        [btn setImage:[UIImage imageNamed:@"icon_collection_sel"] forState:UIControlStateNormal];
                    }else {
                        [btn setImage:[UIImage imageNamed:@"icon_collection_nor"] forState:UIControlStateNormal];
                    }
                }else if (btn.tag == 102) {
                    if (self.detailModel.is_like == 1) {
                        [btn setImage:[UIImage imageNamed:@"icon_courseLike_sel"] forState:UIControlStateNormal];
                    }else {
                        [btn setImage:[UIImage imageNamed:@"icon_courseLike_nor"] forState:UIControlStateNormal];
                    }
                }
            }else {
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
        NSString *audioUrl = @"";
        if (self.isC) {
            audioUrl = kMeUnNilStr(self.detailModel.courses_url);
        }else {
            audioUrl = kMeUnNilStr(self.model.audio_urls);
        }
        _playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:audioUrl]];
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
        if (self.isC) {
            [self.audioList enumerateObjectsUsingBlock:^(MECourseListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:kMeUnNilStr(model.courses_url)]];
                [temp addObject:item];
            }];
        }else {
            [self.audioList enumerateObjectsUsingBlock:^(MEOnlineCourseListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:kMeUnNilStr(model.audio_urls)]];
                [temp addObject:item];
            }];
        }
        _itemsArr = [temp copy];
    }
    return _itemsArr;
}

@end
