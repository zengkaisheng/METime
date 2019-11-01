//
//  MEMyVIPVC.m
//  志愿星
//
//  Created by gao lei on 2019/9/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyVIPVC.h"
#import "MEMyVIPDetailView.h"
#import "MEMyCourseVIPInfoModel.h"

#import "MEVIPViewController.h"
#import "MEMyVIPPayRecordVC.h"

#import "TDWebViewCell.h"
#import "MEMyCourseVIPModel.h"

@interface MEMyVIPVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) MEMyVIPDetailView *vipView;
@property (nonatomic, strong) MEMyCourseVIPInfoModel *model;

@property (nonatomic, strong) MEMyCourseVIPModel *vipModel;

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) TDWebViewCell *webCell;

@end

@implementation MEMyVIPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程VIP";
    self.view.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.vipView];
    
//    [self requestMyCourseVIPDetailWithNetWork];
    [self requestMyCourseVIPWithNetWork];
}

- (void)reloadUI {
    MEMyCourseVIPSubModel *c_vipModel = self.vipModel.C_vip;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(c_vipModel.vip_rule)] baseURL:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        self.tableView.hidden = YES;
        self.vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEMyVIPDetailView getViewHeightWithRuleHeight:height]);
        self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, [MEMyVIPDetailView getViewHeightWithRuleHeight:height]);
        
        //    [self.vipView setUIWithModel:self.model];
        [self.vipView setUIWithVIPModel:self.vipModel];
    });
    
    kMeWEAKSELF
    self.vipView.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        if (index == 1) {//C端开通或续费
            MEMyCourseVIPSubModel *c_vipModel = strongSelf.vipModel.C_vip;
            MEMyCourseVIPDetailModel *c_vip_detail = c_vipModel.vip.firstObject;
            MEVIPViewController *vc = [[MEVIPViewController alloc] initWithVIPModel:c_vip_detail];
            vc.finishBlock = ^{
                [strongSelf requestMyCourseVIPWithNetWork];
            };
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 2) {//查看交易记录
            MEMyVIPPayRecordVC *vc = [[MEMyVIPPayRecordVC alloc] init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 3) {//B端开通或续费
            MEMyCourseVIPSubModel *b_vipModel = strongSelf.vipModel.B_vip;
            MEMyCourseVIPDetailModel *b_vip_detail = b_vipModel.vip.firstObject;
            MEVIPViewController *vc = [[MEVIPViewController alloc] initWithVIPModel:b_vip_detail];
            vc.finishBlock = ^{
                [strongSelf requestMyCourseVIPWithNetWork];
            };
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.webCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_webCell){
        return 0;
    }
    return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
}

#pragma mark -- Networking
//我的VIP信息
- (void)requestMyCourseVIPDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetMyCourseVIPDetailWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEMyCourseVIPInfoModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//获取B端C端VIP
- (void)requestMyCourseVIPWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCourseVIPWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.vipModel = [MEMyCourseVIPModel mj_objectWithKeyValues:responseObject.data];
            MEMyCourseVIPSubModel *c_vip = strongSelf.vipModel.C_vip;
            MEMyCourseVIPSubModel *b_vip = strongSelf.vipModel.B_vip;
            if (c_vip.vip.count <= 0 && b_vip.vip.count <= 0) {
                [MECommonTool showMessage:@"暂无课程VIP信息" view:kMeCurrentWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }else{
            strongSelf.vipModel = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark -- setter&&getter
- (UIScrollView *)scrollerView{
    if(!_scrollerView){
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
        _scrollerView.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, [MEMyVIPDetailView getViewHeightWithRuleHeight:0]);
        _scrollerView.bounces = YES;
        _scrollerView.showsVerticalScrollIndicator =NO;
        _scrollerView.delegate = self;
        _scrollerView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollerView;
}

- (MEMyVIPDetailView *)vipView {
    if (!_vipView) {
        _vipView = [[[NSBundle mainBundle]loadNibNamed:@"MEMyVIPDetailView" owner:nil options:nil] lastObject];
        _vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEMyVIPDetailView getViewHeightWithRuleHeight:0]);
    }
    return _vipView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

@end
