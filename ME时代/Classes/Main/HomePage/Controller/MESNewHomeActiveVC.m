//
//  MESNewHomeActiveVC.m
//  ME时代
//
//  Created by hank on 2018/12/3.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESNewHomeActiveVC.h"
#import "TDWebViewCell.h"
#import "MESNewHomeActiveCommondCell.h"
//#import "MENewHomePage.h"
#import "MEShoppingMallVC.h"
#import "MEGoodModel.h"

@interface MESNewHomeActiveVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_content;
}
@property (nonatomic, strong) UITableView           *tableView;
@property (strong, nonatomic) TDWebViewCell                  *webCell;
@property (strong, nonatomic) UIButton                  *btnToProduct;
@property (nonatomic, strong) NSMutableArray            *arrProduct;
@end


@implementation MESNewHomeActiveVC

- (void)dealloc{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    kTDWebViewCellDidFinishLoadNotificationCancel
}

- (instancetype)initWithContent:(NSString *)content{
    if(self = [super init]){
        _content = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnToProduct];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(networkRequest)];
    [self.tableView.mj_header beginRefreshing];
    kMeWEAKSELF
    [MEPublicNetWorkTool postRecommendProductWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf.arrProduct = [MEGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        
    }];
    kTDWebViewCellDidFinishLoadNotification
}

kTDWebViewCellDidFinishLoadNotificationMethod

- (void)networkRequest{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(_content)] baseURL:nil];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showMessage:@"获取详情中" toView:self.view];
//    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return self.webCell;
    }else{
        MESNewHomeActiveCommondCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MESNewHomeActiveCommondCell class])];
        [cell setUiWithModel:self.arrProduct];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }else{
        return [MESNewHomeActiveCommondCell getCellHeightWithModel:self.arrProduct];
    }
}

- (void)ToProduct:(UIButton *)btn{
    MEShoppingMallVC *vc = [[MEShoppingMallVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-45) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MESNewHomeActiveCommondCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MESNewHomeActiveCommondCell class])];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetailsSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEProductDetailsSectionView class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (UIButton *)btnToProduct{
    if(!_btnToProduct){
        _btnToProduct = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnToProduct setTitle:@"前往优选商城" forState:UIControlStateNormal];
        _btnToProduct.frame =CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45);
        [_btnToProduct addTarget:self action:@selector(ToProduct:) forControlEvents:UIControlEventTouchUpInside];
        _btnToProduct.backgroundColor = kMEPink;
        [_btnToProduct setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnToProduct.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _btnToProduct;
}

- (NSMutableArray *)arrProduct{
    if(!_arrProduct){
        _arrProduct = [NSMutableArray array];
    }
    return _arrProduct;
}

@end
