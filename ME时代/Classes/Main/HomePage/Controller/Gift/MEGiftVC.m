//
//  MEGiftVC.m
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGiftVC.h"
#import "MEGiftMainCell.h"
#import "MEGiftHeaderView.h"
#import "MEGiftFooterView.h"
#import "MEGiftMainNilCell.h"
#import "MEAdModel.h"
#import "MEShoppingCartModel.h"
#import "MEProductGitfListVC.h"
#import "MEMakeOrderVC.h"
#import "MEShopCartMakeOrderVC.h"

@interface MEGiftVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSArray *_arrDv;
    NSString *_allPrice;
    NSString *_strMessage;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEGiftHeaderView         *headerView;
@property (nonatomic, strong) MEGiftFooterView         *footerView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@end

@implementation MEGiftVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"许愿屋";
    _allPrice = @"¥0";
    _strMessage = @"";
    _arrDv = [NSArray array];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNetWork)];
//    [self.tableView.mj_header beginRefreshing];
    [self.refresh addHeadRefreshView];
    kShopCartReload
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestNetWork];
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"product_type":@(6),
             };
}

- (void)countPrice{
    double totlePrice = 0.0;
    for (MEShoppingCartModel *goodsModel in self.refresh.arrData) {
        double price = [goodsModel.money doubleValue];
        totlePrice += price * goodsModel.goods_num ;
    }
    NSString *price= [NSString stringWithFormat:@"￥%.2f", totlePrice];
    _allPrice = price;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEShoppingCartModel mj_objectArrayWithKeyValuesArray:data]];
    [self countPrice];
    kMeWEAKSELF
    [self.footerView setUIWithModel:_allPrice say:_strMessage contentBlock:^(NSString *str) {
        kMeSTRONGSELF
        strongSelf->_strMessage = str;
    }];
    self.tableView.tableFooterView = self.footerView;
    [self.tableView reloadData];
}

- (void)requestNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postAgetGiftBannerWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_arrDv = [MEAdModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        [strongSelf.headerView setUiWithModel:strongSelf->_arrDv];
        strongSelf.tableView.tableHeaderView = strongSelf.headerView;
        strongSelf.tableView.tableHeaderView.backgroundColor = kMEPink;
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    }];
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    kMeWEAKSELF
//    dispatch_group_async(group, queue, ^{
//
//    });
//    dispatch_group_async(group, queue, ^{
//        dispatch_semaphore_signal(semaphore);
//    });
//    dispatch_group_notify(group, queue, ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
//    });

}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.refresh.arrData.count == 0){
        MEGiftMainNilCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGiftMainNilCell class]) forIndexPath:indexPath];
        return cell;
    }
    MEGiftMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGiftMainCell class]) forIndexPath:indexPath];
    kMeWEAKSELF
    cell.allPriceBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf->_allPrice = str;
        [self.footerView setUIWithModel:strongSelf->_allPrice  say:strongSelf->_strMessage contentBlock:^(NSString *str) {
            kMeSTRONGSELF
            strongSelf->_strMessage = str;
        }];
        self.tableView.tableFooterView = self.footerView;
        [self.tableView reloadData];
    };
    [cell setUIWithModel:self.refresh.arrData block:^{
        kMeSTRONGSELF
        MEProductGitfListVC *vc = [[MEProductGitfListVC alloc]init];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.refresh.arrData.count == 0){
        return kMEGiftMainNilCellHeight;
    }
    return [MEGiftMainCell getCellHeightWithModel:self.refresh.arrData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.refresh.arrData.count == 0){
        MEProductGitfListVC *vc = [[MEProductGitfListVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGiftMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGiftMainCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGiftMainNilCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGiftMainNilCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = self.footerView;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableHeaderView.backgroundColor = kMEPink;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (MEGiftHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEGiftHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, [MEGiftHeaderView getViewHeight]);
        _headerView.backgroundColor = kMEPink;
    }
    return _headerView;
}

- (MEGiftFooterView *)footerView{
    if(!_footerView){
        _footerView = [[[NSBundle mainBundle]loadNibNamed:@"MEGiftFooterView" owner:nil options:nil] lastObject];
        _footerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, kMEGiftFooterViewHeight);
        kMeWEAKSELF
        _footerView.toAcount = ^{
            kMeSTRONGSELF
            if(strongSelf.refresh.arrData.count == 0){
                [MEShowViewTool showMessage:@"请选择礼物" view:strongSelf.view];
            }else{
                MEShopCartMakeOrderVC *ovc = [[MEShopCartMakeOrderVC alloc]initWithIsinteral:NO WithArrChartGood:strongSelf.refresh.arrData];
                ovc.isGift = YES;
                ovc.giftMessage = kMeUnNilStr(strongSelf->_strMessage);
                ovc.PayFinishBlock = ^{
                    kMeSTRONGSELF
                    [strongSelf.refresh reload];
                };
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        };
    }
    return _footerView;
}


- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCartCartGoodsList)];
        _refresh.delegate = self;
        _refresh.showFailView = NO;
    }
    return _refresh;
}

@end
