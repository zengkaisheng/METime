//
//  MEPersionalVideoPlayVC.m
//  ME时代
//
//  Created by gao lei on 2019/9/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersionalVideoPlayVC.h"
#import "MEPersionalCourseDetailModel.h"
#import "XMPlayer.h"
#import "AppDelegate.h"
#import "MEVideoCourseDetailCell.h"
#import "MEPersonalCourseListModel.h"
#import "MECourseDetailModel.h"

#import "MEDiagnosePromptView.h"
#import "MEOnlineDiagnoseVC.h"
#import "TDWebViewCell.h"
#import "MEFeedBackVC.h"

#import "MECustomBuyCourseView.h"
#import "MEPayStatusVC.h"
#import "MEMyOrderDetailVC.h"
#import "MEVIPViewController.h"
#import "MEMyCourseVIPModel.h"

@interface MEPersionalVideoPlayVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isShowBuy;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) XMPlayerView *playerView;
@property (nonatomic, strong) MEPersionalCourseDetailModel *model;
@property (nonatomic, strong) NSArray *videoList;
@property (strong, nonatomic) TDWebViewCell *webCell;

@property (nonatomic, strong) MEMyCourseVIPModel *vipModel;

@end

@implementation MEPersionalVideoPlayVC

- (instancetype)initWithModel:(MEPersionalCourseDetailModel *)model videoList:(NSArray *)videoList{
    if (self = [super init]) {
        self.model = model;
        self.videoList = videoList;
    }
    return self;
}

- (void)dealloc {
    kNSNotificationCenterDealloc
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView stopPlaying];
    //白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    if (!self.model) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    _isShowBuy = NO;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeStatusBarHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    
    [self.view addSubview:self.playerView];
    [self.playerView show];
    kMeWEAKSELF
    self.playerView.listenBlock = ^{
        kMeSTRONGSELF
        if (!strongSelf->_isShowBuy) {
            [MECustomBuyCourseView showCustomBuyVIPViewWithTitle:@"试看结束" confirmBtn:@"购买VIP" buyBlock:^{
                kMeSTRONGSELF
                [strongSelf requestMyCourseVIPWithNetWork];
            } cancelBlock:^{
                
            } superView:kMeCurrentWindow];
            strongSelf->_isShowBuy = YES;
        }else {
            strongSelf->_isShowBuy = NO;
        }
    };
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI) name:kMEReloadUI object:nil];
    
    // 监听屏幕旋转方向
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationHandler)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self reloadUI];
}

- (void)reloadUI {
    self.playerView.videoURL = [NSURL URLWithString:kMeUnNilStr(self.model.courses_url)];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(self.model.detail).length>0?kMeUnNilStr(self.model.detail):@"<p>暂无课程介绍</p>"] baseURL:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark -- Networking
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

- (void)reloadDatas {
    [self requestVideoDetailWithNetWorkWithCourseId:self.model.idField];
}
//视频
- (void)requestVideoDetailWithNetWorkWithCourseId:(NSInteger)courseId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCourseDetailWithCourseId:courseId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEPersionalCourseDetailModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.model = nil;
    }];
}

//收藏与取消收藏
- (void)collectionCourseWithNetWorking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postSetCollectionWithCollectionId:self.model.idField type:3 SuccessBlock:^(ZLRequestResponse *responseObject) {
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
//点赞与取消点赞
- (void)setLikeCourseWithNetWorking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postSetLikeCourseWithCourseId:self.model.idField SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MEShowViewTool showMessage:kMeUnNilStr(responseObject.message) view:kMeCurrentWindow];
        if (strongSelf.model.is_like == 1) {
            strongSelf.model.is_like = 2;
        }else {
            strongSelf.model.is_like = 1;
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
            }else if (btn.tag == 102) {
                if (self.model.is_like == 1) {
                    [btn setImage:[UIImage imageNamed:@"icon_courseLike_sel"] forState:UIControlStateNormal];
                }else {
                    [btn setImage:[UIImage imageNamed:@"icon_courseLike_nor"] forState:UIControlStateNormal];
                }
            }
        }
    }
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return self.webCell;
    }
    MEVideoCourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVideoCourseDetailCell class]) forIndexPath:indexPath];
    [cell setPersionalUIWithArr:self.videoList model:self.model];
    kMeWEAKSELF
    cell.selectBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        [strongSelf.playerView stopPlaying];
        MECourseListModel *model = strongSelf.videoList[index];
        [strongSelf requestVideoDetailWithNetWorkWithCourseId:model.idField];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }
    return 79;
}

#pragma mark -- Action
- (void)bottomBtnDidClick:(UIButton *)sender {
    switch (sender.tag-100) {
        case 0:
        {
            [self.playerView stopPlaying];
            
            MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
            NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
            baseUrl = [@"http" stringByAppendingString:baseUrl];
            
            //http://test.meshidai.com/clientCourseShare/newAuth.html?id=18&inviteCode=P8786A
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@clientCourseShare/newAuth.html?id=%ld&inviteCode=%@",baseUrl,(long)self.model.idField,[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            
            shareTool.shareTitle = kMeUnNilStr(self.model.name);
            shareTool.shareDescriptionBody = kMeUnNilStr(self.model.desc);
            shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(self.model.courses_images)]]];
            
            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
            } failure:^(NSError *error) {
                [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
            }];
        }
            break;
        case 1:
            [self collectionCourseWithNetWorking];
            break;
        case 2:
        {
            [self setLikeCourseWithNetWorking];
        }
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
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

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

- (XMPlayerView *)playerView {
    if (!_playerView) {
        CGFloat palyerW = [UIScreen mainScreen].bounds.size.width;
        _playerView = [[XMPlayerView alloc] init];
        _playerView.frame = CGRectMake(0, kMeStatusBarHeight, palyerW, 210);
        _playerView.playerViewType = XMPlayerViewAiqiyiVideoType;
        _playerView.videoURL = [NSURL URLWithString:kMeUnNilStr(self.model.courses_url)];
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
        NSArray *btns = @[@{@"title":@"分享",@"image":@"icon_share"},@{@"title":@"收藏",@"image":@"icon_collection_nor"},@{@"title":@"点赞",@"image":@"icon_courseLike_nor"}];
        CGFloat btnHeight = 49;
        CGFloat btnWidth = SCREEN_WIDTH/3;
        for (int i = 0; i < btns.count; i++) {
            NSDictionary *dict = btns[i];
            UIButton *btn = [self createButtonWithTitle:dict[@"title"] normalImage:dict[@"image"] tag:100+i];
            if (i == 1) {
                if (self.model.is_collection == 1) {
                    [btn setImage:[UIImage imageNamed:@"icon_collection_sel"] forState:UIControlStateNormal];
                }
            }else if (i == 2) {
                if (self.model.is_like == 1) {
                    [btn setImage:[UIImage imageNamed:@"icon_courseLike_sel"] forState:UIControlStateNormal];
                }
            }
            btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, btnHeight);
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-8, 10, 8, -10)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(12, -10, -12, 10)];
            [_bottomView addSubview:btn];
        }
    }
    return _bottomView;
}

@end
