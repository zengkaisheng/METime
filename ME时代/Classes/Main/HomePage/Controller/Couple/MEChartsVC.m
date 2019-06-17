//
//  MEChartsVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEChartsVC.h"
#import "MEChartsCoupleCell.h"
#import "MECoupleModel.h"
#import "MECoupleMailDetalVC.h"

@interface MEChartsVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UIView *siftView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) BOOL isAddLimit;
@property (nonatomic, copy) NSString *sort;

@end

@implementation MEChartsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    self.isUp = YES;
    self.isAddLimit = NO;
    self.sort = @"";
    
    if (self.isHot) {
        self.title = @"今日热卖专场";
        self.tableView.frame = CGRectMake(0, kMeNavBarHeight + 1, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight - 1);
    }else {
        [self.view addSubview:self.siftView];
        self.title = @"排行榜";
    }
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    [self showHUD];
}

- (void)siftBtnAction:(UIButton *)sender {
    UIButton *siftBtn = (UIButton *)sender;
    for (UIButton *btn in self.siftView.subviews) {
        if (btn.tag == siftBtn.tag) {
            if (siftBtn.selected == YES && siftBtn.tag != 100) {
                if (self.isUp == YES) {
                    self.isUp = NO;
                    [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateSelected];
                }else {
                    [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
                    self.isUp = YES;
                }
            }else {
                siftBtn.selected = YES;
                if (siftBtn.tag == 103) {
                    self.isUp = YES;
                    [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
                }else {
                    self.isUp = NO;
                    if (siftBtn.tag != 100) {
                        [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateSelected];
                    }
                }
            }
        }else {
            btn.selected = NO;
        }
    }
    switch (siftBtn.tag) {
        case 100:
        {
            self.sort = @"";
            self.isAddLimit = NO;
        }
            break;
        case 101:
        {
            if (self.isUp) {
                self.sort = @"tk_rate_asc";
            }else {
                self.sort = @"tk_rate_des";
            }
            self.isAddLimit = YES;
        }
            break;
        case 102:
        {
            if (self.isUp) {
                self.sort = @"total_sales_asc";
            }else {
                self.sort = @"total_sales_des";
            }
            self.isAddLimit = NO;
        }
            break;
        case 103:
        {
            if (self.isUp) {
                self.sort = @"price_asc";
            }else {
                self.sort = @"price_des";
            }
            self.isAddLimit = YES;
        }
            break;
        default:
            break;
    }
    [self showHUD];
    [self.refresh reload];
}

- (void)showHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];;
    hud.mode = MBProgressHUDModeIndeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

//综合 _material_id=13366 其他不用传_material_id
#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    //    return @{@"r":@"Port/index",@"type":@"total",@"appkey":@"58de5a1fe2",@"v":@"2"};
    if (self.isHot) {
        return @{@"type":@(6)};
    }else {
        if ([self.sort length] > 0) {
            if (self.isAddLimit) {
                return @{@"sort":self.sort,@"start_price":@"5"};
            }
            return @{@"sort":self.sort};
        }else {
            return @{@"material_id":@(13366)};
        }
    }
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEChartsCoupleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEChartsCoupleCell class]) forIndexPath:indexPath];
    MECoupleModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEChartsCoupleCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleModel *model = self.refresh.arrData[indexPath.row];
    MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
    [self.navigationController pushViewController:vc animated:YES];
}
//cell分割线与屏幕等宽，两个方法同时添加iOS 10有效
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIButton *)createSiftButtomWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *siftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [siftBtn setTitle:title forState:UIControlStateNormal];
    [siftBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [siftBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [siftBtn setTitleColor:[UIColor colorWithHexString:@"#E74192"] forState:UIControlStateSelected];
    if (tag != 100) {
        [siftBtn setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
        [siftBtn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
    }
    //jiagedown  jiagenomal  jiageup
    [siftBtn setTag:tag];
    [siftBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-70];
    [siftBtn addTarget:self action:@selector(siftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    siftBtn.backgroundColor = [UIColor whiteColor];
    
    return siftBtn;
}

#pragma helper
- (UIView *)siftView {
    if (!_siftView) {
        _siftView = [[UIView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight + 1, SCREEN_WIDTH, 39)];
        _siftView.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"综合",@"佣金",@"销量",@"价格"];
        CGFloat itemW = SCREEN_WIDTH / titles.count;
        for (int i = 0; i < titles.count; i++) {
            UIButton *siftBtn = [self createSiftButtomWithTitle:titles[i] tag:100+i];
            siftBtn.frame = CGRectMake(itemW * i, 0, itemW, 39);
            if (i == 0) {
                siftBtn.selected = YES;
            }
            [_siftView addSubview:siftBtn];
        }
    }
    return _siftView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight + 41, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight - 41) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEChartsCoupleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEChartsCoupleCell class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
//        NSString *str = MEIPcommonTaobaokeGetCoupon;
//        if(_isMater){
//            str = MEIPcommonTaobaokeGetDgMaterialOptional;
//        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonTaobaokeGetDgMaterialOptional)];
        _refresh.delegate = self;
//        if(_isMater){
            _refresh.isCoupleMater = YES;
//        }else{
//            _refresh.isCouple = YES;
//        }
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有优惠产品";
        }];
    }
    return _refresh;
}

@end
