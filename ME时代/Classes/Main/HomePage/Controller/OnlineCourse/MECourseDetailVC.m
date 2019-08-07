//
//  MECourseDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseDetailVC.h"
#import "MECourseDetailHeaderView.h"
#import "TDWebViewCell.h"
#import "MECourseDetailListCell.h"
#import "MECourseDetailCommentCell.h"
#import "ViewPagerTitleButton.h"

@interface MECourseDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *customNav;
@property (nonatomic, strong) UIView *siftView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MECourseDetailHeaderView *headerView;
@property (strong, nonatomic) TDWebViewCell *webCell;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIButton *tryBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation MECourseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    self.type = 0;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,@"<img src=\"http://images.meshidai.com/2f1022a12c59f66ca99aadc51f4128f2\" alt=\"\" />"] baseURL:nil];
    [self.tableView reloadData];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#707070"];
    [bottomView addSubview:lineView];
    
    [bottomView addSubview:self.tryBtn];
    [bottomView addSubview:self.buyBtn];
    [self.view addSubview:self.customNav];
    [self.view addSubview:self.siftView];
    [self.view addSubview:self.backButton];
}
#pragma Action
- (void)tryBtnDidClick {
    NSLog(@"点击了试听按钮");
}

- (void)buyBtnDidClick {
    NSLog(@"点击了购买按钮");
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)siftBtnDidClick:(UIButton *)sender {
    for (ViewPagerTitleButton *btn in self.siftView.subviews) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.type = sender.tag - 100;
    [self.headerView setUIWithModel:@{} index:self.type];
    [self.tableView reloadData];
}

- (void)reloadSiftViewWithIndex:(NSInteger)index {
    for (UIButton *btn in self.siftView.subviews) {
        if (btn.tag - 100 == index) {
            btn.selected = YES;
        }else {
            btn.selected = NO;
        }
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.refresh.arrData.count;
    if (self.type == 0) {
        return 1;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        return self.webCell;
    }
    MECourseDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECourseDetailListCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }
    return kMECourseDetailListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.customNav.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:scrollView.mj_offsetY/(kMECourseDetailHeaderViewHeight-41)];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20-49) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECourseDetailListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECourseDetailListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECourseDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECourseDetailCommentCell class])];
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
            strongSelf.type = index;
            [strongSelf reloadSiftViewWithIndex:index];
            [strongSelf.tableView reloadData];
        };
    }
    return _headerView;
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
        [_tryBtn setImage:[UIImage imageNamed:@"dynamicCommentLike"] forState:UIControlStateNormal];
        [_tryBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
        _tryBtn.frame = CGRectMake(20, 0, 60, 49);
        [_tryBtn addTarget:self action:@selector(tryBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tryBtn;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"￥100.00购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_buyBtn setBackgroundColor:[UIColor colorWithHexString:@"#FE4B77"]];
        _buyBtn.frame = CGRectMake(SCREEN_WIDTH-31-201*kMeFrameScaleX(), 4.5, 201*kMeFrameScaleX(), 40);
        _buyBtn.layer.cornerRadius = 20;
        [_buyBtn addTarget:self action:@selector(buyBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (UIView *)customNav {
    if (!_customNav) {
        _customNav = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _customNav.backgroundColor = [UIColor clearColor];
    }
    return _customNav;
}

- (UIButton *)backButton {
    if(!_backButton) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(16, 20, 44, 44);
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
            ViewPagerTitleButton *btn = [self createButtonWithTitle:titles[i] frame:CGRectMake(i*itemW, 0, itemW, 41) tag:100+i];
            [_siftView addSubview:btn];
        }
        _siftView.hidden = YES;
    }
    return _siftView;
}

@end
