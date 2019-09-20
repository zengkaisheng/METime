//
//  MEPersionalCourseDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/9/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersionalCourseDetailVC.h"
#import "MECourseDetailHeaderView.h"
#import "TDWebViewCell.h"
#import "MEPersionalCourseListCell.h"
#import "ViewPagerTitleButton.h"

#import "MEPersionalCourseDetailModel.h"
#import "MEPersonalCourseListModel.h"
#import "MEVIPViewController.h"
#import "MEPersionalVideoPlayVC.h"
#import "MECourseAudioPlayerVC.h"

@interface MEPersionalCourseDetailVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _courseId;
}

@property (nonatomic, strong) UIView *customNav;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *siftView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, strong) MECourseDetailHeaderView *headerView;
@property (strong, nonatomic) TDWebViewCell *webCell;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) MEPersionalCourseDetailModel *detailModel;

@property (nonatomic, strong) UIButton *tryBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation MEPersionalCourseDetailVC

- (instancetype)initWithCourseId:(NSInteger)courseId {
    if (self = [super init]) {
        _courseId = courseId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    self.index = 0;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeStatusBarHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,@""] baseURL:nil];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - kMeTabbarSafeBottomMargin, SCREEN_WIDTH, 49 + kMeTabbarSafeBottomMargin)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#707070"];
    [bottomView addSubview:lineView];
    
    [bottomView addSubview:self.tryBtn];
    [bottomView addSubview:self.buyBtn];
    [self.customNav addSubview:self.titleLbl];
    [self.view addSubview:self.customNav];
    [self.view addSubview:self.siftView];
    [self.view addSubview:self.backButton];
    
    [self requestCourseDetailWithNetWork];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"classify_id":@(self.detailModel.classify_id)
             };
}

- (void)handleResponse:(id)data{
    if (![data isKindOfClass:[NSArray class]]) {
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECourseListModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)reloadUI {
    [self.headerView setUIWithCourseModel:self.detailModel index:self.index];
    
    self.titleLbl.text = kMeUnNilStr(self.detailModel.name);
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(self.detailModel.detail).length>0?kMeUnNilStr(self.detailModel.detail):@"<p>暂无课程介绍</p>"] baseURL:nil];
    
    if (self.detailModel.is_charge == 2 || self.detailModel.is_buy == 1) {//免费或已购买
        self.tryBtn.hidden = YES;
        [self.buyBtn setTitle:@"立即播放" forState:UIControlStateNormal];
        self.buyBtn.frame = CGRectMake(30, 4.5, SCREEN_WIDTH-60, 40);
    }else {
        self.tryBtn.hidden = NO;
        [self.buyBtn setTitle:@"VIP免费" forState:UIControlStateNormal];
        [self.tryBtn setTitle:@" 试看" forState:UIControlStateNormal];
        self.buyBtn.frame = CGRectMake(SCREEN_WIDTH-31-201*kMeFrameScaleX(), 4.5, 201*kMeFrameScaleX(), 40);
    }
    
    [self.refresh addRefreshView];
}

#pragma mark -- Networking
//课程详情
- (void)requestCourseDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCourseDetailWithCourseId:_courseId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.detailModel = [MEPersionalCourseDetailModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.detailModel = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma Action
- (void)tryBtnDidClick {
    if (kMeUnNilStr(kCurrentUser.token).length <= 0) {
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf tryBtnAction];
        } failHandler:^(id object) {
        }];
    }else {
        [self tryBtnAction];
    }
}

- (void)tryBtnAction {
    if (self.detailModel.type == 1) {//视频
        MEPersionalVideoPlayVC *vc = [[MEPersionalVideoPlayVC alloc] initWithModel:self.detailModel videoList:[self.refresh.arrData copy]];
        vc.listenTime = self.detailModel.preview_time;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.detailModel.type == 2) {//音频
        MECourseAudioPlayerVC *vc = [[MECourseAudioPlayerVC alloc] initWithCourseModel:self.detailModel audioList:[self.refresh.arrData copy]];
        vc.listenTime = self.detailModel.preview_time;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)buyBtnDidClick {
    if (kMeUnNilStr(kCurrentUser.token).length <= 0) {
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf buyBtnAction];
        } failHandler:^(id object) {
        }];
    }else {
        [self buyBtnAction];
    }
}

- (void)buyBtnAction {
    if (self.detailModel.is_charge == 2 || self.detailModel.is_buy == 1) {
        if (self.detailModel.type == 1) {//视频
            MEPersionalVideoPlayVC *vc = [[MEPersionalVideoPlayVC alloc] initWithModel:self.detailModel videoList:[self.refresh.arrData copy]];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.detailModel.type == 2) {//音频
            MECourseAudioPlayerVC *vc = [[MECourseAudioPlayerVC alloc] initWithCourseModel:self.detailModel audioList:[self.refresh.arrData copy]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        MEVIPViewController *vc = [[MEVIPViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)siftBtnDidClick:(ViewPagerTitleButton *)sender {
    for (id obj in self.siftView.subviews) {
        if ([obj isKindOfClass:[ViewPagerTitleButton class]]) {
            ViewPagerTitleButton *btn = (ViewPagerTitleButton *)obj;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    self.index = sender.tag - 100;
    [self.headerView setUIWithCourseModel:self.detailModel index:self.index];
    [self.tableView reloadData];
}

- (void)reloadSiftViewWithIndex:(NSInteger)index {
    for (id obj in self.siftView.subviews) {
        if ([obj isKindOfClass:[ViewPagerTitleButton class]]) {
            ViewPagerTitleButton *btn = (ViewPagerTitleButton *)obj;
            if (btn.tag - 100 == index) {
                btn.selected = YES;
            }else {
                btn.selected = NO;
            }
        }
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.index == 0) {
        return 1;
    }
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        return self.webCell;
    }
    MEPersionalCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPersionalCourseListCell class]) forIndexPath:indexPath];
    MECourseListModel *listModel = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:listModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }
    return kMEPersionalCourseListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECourseListModel *model = self.refresh.arrData[indexPath.row];
    _courseId = model.idField;
    [self requestCourseDetailWithNetWork];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.customNav.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:scrollView.mj_offsetY/(kMECourseDetailHeaderViewHeight-41)];
    self.titleLbl.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:scrollView.mj_offsetY/(kMECourseDetailHeaderViewHeight-41)];
    self.siftView.hidden = scrollView.mj_offsetY>=(kMECourseDetailHeaderViewHeight-41)?NO:YES;
}

- (ViewPagerTitleButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag{
    ViewPagerTitleButton *btn = [[ViewPagerTitleButton alloc] init];
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFA8A8"] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(siftBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeStatusBarHeight-49-kMeTabbarSafeBottomMargin) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPersionalCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPersionalCourseListCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MECourseDetailHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MECourseDetailHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMECourseDetailHeaderViewHeight);
        kMeWEAKSELF
        _headerView.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            strongSelf.index = index;
            [strongSelf reloadSiftViewWithIndex:index];
            [strongSelf.tableView reloadData];
        };
    }
    return _headerView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCoursesGetCoursesList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关课程";
        }];
    }
    return _refresh;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

- (UIButton *)tryBtn {
    if (!_tryBtn) {
        _tryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tryBtn setTitle:@" 试听" forState:UIControlStateNormal];
        [_tryBtn setTitleColor:kME333333 forState:UIControlStateNormal];
        [_tryBtn setImage:[UIImage imageNamed:@"icon_coursePlayBtn"] forState:UIControlStateNormal];
        [_tryBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        _tryBtn.frame = CGRectMake(20, 0, 60, 49);
        [_tryBtn addTarget:self action:@selector(tryBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tryBtn;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"VIP免费" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_buyBtn setBackgroundColor:[UIColor colorWithHexString:@"#FE4B77"]];
        _buyBtn.frame = CGRectMake(SCREEN_WIDTH-31-201*kMeFrameScaleX(), 4.5, 201*kMeFrameScaleX(), 40);
        _buyBtn.layer.cornerRadius = 20;
        [_buyBtn addTarget:self action:@selector(buyBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (UIView *)customNav {
    if (!_customNav) {
        _customNav = [[UIView alloc] initWithFrame:CGRectMake(0, kMeStatusBarHeight, SCREEN_WIDTH, 44)];
        _customNav.backgroundColor = [UIColor clearColor];
    }
    return _customNav;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-120, 44)];
        _titleLbl.font = [UIFont systemFontOfSize:17];
        _titleLbl.textColor = [UIColor clearColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UIButton *)backButton {
    if(!_backButton) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(16, kMeStatusBarHeight, 44, 44);
        [backButton setImage:[UIImage imageNamed:@"icon-tmda"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
        _backButton = backButton;
    }
    return _backButton;
}

- (UIView *)siftView {
    if (!_siftView) {
        _siftView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.customNav.frame), SCREEN_WIDTH, 41)];
        NSArray *titles = @[@"课程介绍",@"课程列表"];
        CGFloat itemW = SCREEN_WIDTH/titles.count;
        for (int i = 0; i < titles.count; i++) {
            ViewPagerTitleButton *btn = [self createButtonWithTitle:titles[i] frame:CGRectMake(i*itemW, 0, itemW, 40) tag:100+i];
            if (i == 0) {
                btn.selected = YES;
            }
            [_siftView addSubview:btn];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_siftView addSubview:line];
        _siftView.hidden = YES;
    }
    return _siftView;
}

@end
