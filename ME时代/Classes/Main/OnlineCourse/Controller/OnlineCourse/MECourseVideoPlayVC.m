//
//  MECourseVideoPlayVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseVideoPlayVC.h"
#import "XMPlayer.h"
#import "AppDelegate.h"
#import "MEVideoCourseDetailCell.h"
#import "MECourseDetailModel.h"
#import "MEOnlineCourseListModel.h"
#import "MECourseDetailModel.h"

#import "MEDiagnosePromptView.h"
#import "MEOnlineDiagnoseVC.h"

@interface MECourseVideoPlayVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) XMPlayerView *playerView;
@property (nonatomic, strong) MECourseDetailModel *model;
@property (nonatomic, strong) NSArray *videoList;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation MECourseVideoPlayVC

- (instancetype)initWithModel:(MECourseDetailModel *)model videoList:(NSArray *)videoList{
    if (self = [super init]) {
        self.model = model;
        self.videoList = videoList;
    }
    return self;
}

- (void)dealloc {
    if (self.playerView) {
        [self.playerView quite];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 支持 横屏 竖屏
    AppDelegateOrientationMaskLandscape
    //黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //隐藏
//    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView stopPlaying];
    //白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //显示
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    self.isShow = NO;
    if (!self.model) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeStatusBarHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    
    [self.view addSubview:self.playerView];
    [self.playerView show];
    kMeWEAKSELF
    self.playerView.pauseBlock = ^{
        //弹窗提示诊断
        kMeSTRONGSELF
        if (!strongSelf.isShow) {
            [MEDiagnosePromptView showDiagnosePromptViewWithSuccessBlock:^{
                MEOnlineDiagnoseVC *diagnoseVC = [[MEOnlineDiagnoseVC alloc] init];
                [strongSelf.navigationController pushViewController:diagnoseVC animated:YES];
            } superView:strongSelf.view];
            strongSelf.isShow = YES;
        }
        
    };
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    
    // 监听屏幕旋转方向
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationHandler)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self reloadUI];
}

- (void)reloadUI {
    self.playerView.videoURL = [NSURL URLWithString:self.model.video_urls];
//    kMeWEAKSELF
//    [self.videoList enumerateObjectsUsingBlock:^(MEOnlineCourseListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        kMeSTRONGSELF
//        if (strongSelf.model.idField == model.idField) {
//            model.isSelected = YES;
//        }else {
//            model.isSelected = NO;
//        }
//    }];
    [self.tableView reloadData];
}

#pragma mark -- Networking
//视频
- (void)requestVideoDetailWithNetWorkWithDetailsId:(NSInteger)detailsId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetVideoDetailWithVideoId:detailsId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MECourseDetailModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.model = nil;
    }];
}

// 屏幕旋转处理
- (void)orientationHandler {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        PopGestureRecognizerCancel
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.playerView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.playerView.frame));
    }else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        PopGestureRecognizerOpen
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.playerView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.playerView.frame)-50-kMeTabbarSafeBottomMargin);
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEVideoCourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVideoCourseDetailCell class]) forIndexPath:indexPath];
    [cell setUIWithArr:self.videoList model:self.model];
    kMeWEAKSELF
    cell.selectBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        [strongSelf.playerView stopPlaying];
        MEOnlineCourseListModel *model = strongSelf.videoList[index];
        [strongSelf requestVideoDetailWithNetWorkWithDetailsId:model.idField];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

#pragma mark -- Action
- (void)bottomBtnDidClick:(UIButton *)sender {
    switch (sender.tag-100) {
        case 0:
            NSLog(@"点击了分享按钮");
            break;
        case 1:
            NSLog(@"点击了收藏按钮");
            break;
        case 2:
            NSLog(@"点击了咨询按钮");
            break;
        default:
            break;
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
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_playerView.frame)-50-kMeTabbarSafeBottomMargin) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVideoCourseDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVideoCourseDetailCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (XMPlayerView *)playerView {
    if (!_playerView) {
        CGFloat palyerW = [UIScreen mainScreen].bounds.size.width;
        _playerView = [[XMPlayerView alloc] init];
        _playerView.frame = CGRectMake(0, kMeStatusBarHeight, palyerW, 210);
        _playerView.playerViewType = XMPlayerViewAiqiyiVideoType;
        _playerView.videoURL = [NSURL URLWithString:kMeUnNilStr(self.model.video_urls)];
//                                @"https://www.xingyi888.com/xingyi/upload/video/201806/cbc13a1ed0309138ce559dfad8de42b8ca26234c.mp4"];
        //                           @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
        _playerView.isAllowCyclePlay = NO;
        _playerView.previewTime = self.listenTime;
        kMeWEAKSELF
        _playerView.backBlock = ^{
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _playerView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-kMeTabbarSafeBottomMargin, SCREEN_WIDTH, 50+kMeTabbarSafeBottomMargin)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#707070"];
        [_bottomView addSubview:line];
        NSArray *btns = @[@{@"title":@"分享",@"image":@"icon_share"},@{@"title":@"收藏",@"image":@"icon_courseLike"},@{@"title":@"咨询",@"image":@"icon_consult_white"}];
        CGFloat btnHeight = 49;
        CGFloat btnWidth = 60;
        for (int i = 0; i < btns.count; i++) {
            NSDictionary *dict = btns[i];
            UIButton *btn = [self createButtonWithTitle:dict[@"title"] normalImage:dict[@"image"] tag:100+i];
            btn.frame = CGRectMake((SCREEN_WIDTH-btnWidth)/2*i, 0, btnWidth, btnHeight);
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-8, 10, 8, -10)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(12, -10, -12, 10)];
            [_bottomView addSubview:btn];
        }
    }
    return _bottomView;
}

@end
