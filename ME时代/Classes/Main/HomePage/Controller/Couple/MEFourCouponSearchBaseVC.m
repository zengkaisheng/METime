//
//  MEFourCouponSearchBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/17.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourCouponSearchBaseVC.h"
#import "MECoupleMailCell.h"
//TB
#import "MECoupleModel.h"

//PDD
#import "MEPinduoduoCoupleModel.h"
#import "MECoupleMailDetalVC.h"
//JD
#import "MEJDCoupleModel.h"
#import "MEJDCoupleMailDetalVC.h"

#define kMEGoodsMargin ((IS_iPhoneX?10:7.5)*kMeFrameScaleX())

@interface MEFourCouponSearchBaseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIView *siftView;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) BOOL isAddLimit;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, copy) NSString *queryStr;

@end

@implementation MEFourCouponSearchBaseVC

- (instancetype)initWithType:(NSInteger)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    self.navBarHidden = YES;
    self.isUp = YES;
    self.isAddLimit = NO;
    self.sort = @"";
    self.queryStr = @"";
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.siftView];
    [self sortDataWithSiftTag:100];
    [self.refresh addRefreshView];
    [self showHUD];
}

- (void)searchCouponDataWithQueryStr:(NSString *)query {
    self.queryStr = query;
    for (UIButton *btn in self.siftView.subviews) {
        if (btn.tag == 100) {
            [self siftBtnAction:btn];
        }
    }
}

- (void)siftBtnAction:(UIButton *)sender {
    UIButton *siftBtn = (UIButton *)sender;
    
    [self reloadStatusWithSiftButton:siftBtn];
    
    [self sortDataWithSiftTag:siftBtn.tag];
    [self showHUD];
    
    [self.refresh reload];
}
//刷新筛选按钮状态
- (void)reloadStatusWithSiftButton:(UIButton *)siftBtn {
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
}

- (void)sortDataWithSiftTag:(NSInteger)tag {
    switch (tag) {
        case 100:
        {
            switch (self.type) {
                case 0:
                {
                    self.dic = @{@"q":self.queryStr};
                }
                    break;
                case 1:
                {
                    self.dic = @{@"sort_type":@(0),@"keyword":self.queryStr};
                }
                    break;
                case 2:
                {
                    self.dic = @{@"eliteId":@(16),@"keyword":self.queryStr};
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 101:
        {
            switch (self.type) {
                case 0:
                {
                    if (self.isUp) {
                        self.sort = @"tk_rate_asc";
                    }else {
                        self.sort = @"tk_rate_des";
                    }
                    self.dic = @{@"q":self.queryStr,@"sort":self.sort,@"start_price":@"5"};
                }
                    break;
                case 1:
                {
                    if (self.isUp) {
                        self.dic = @{@"sort_type":@(13),@"keyword":self.queryStr};
                    }else {
                        self.dic = @{@"sort_type":@(14),@"keyword":self.queryStr};
                    }
                }
                    break;
                case 2:
                {
                    if (self.isUp) {
                        self.dic = @{@"eliteId":@(16),@"sortName":@"commission",@"sort":@"asc",@"keyword":self.queryStr};
                    }else {
                        self.dic = @{@"eliteId":@(16),@"sortName":@"commission",@"sort":@"desc",@"keyword":self.queryStr};
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 102:
        {
            switch (self.type) {
                case 0:
                {
                    if (self.isUp) {
                        self.sort = @"total_sales_asc";
                    }else {
                        self.sort = @"total_sales_des";
                    }
                    self.dic = @{@"q":self.queryStr,@"sort":self.sort};
                }
                    break;
                case 1:
                {
                    if (self.isUp) {
                        self.dic = @{@"sort_type":@(5),@"keyword":self.queryStr};
                    }else {
                        self.dic = @{@"sort_type":@(6),@"keyword":self.queryStr};
                    }
                }
                    break;
                case 2:
                {
                    if (self.isUp) {
                        self.dic = @{@"eliteId":@(16),@"sortName":@"goodComments",@"sort":@"asc",@"keyword":self.queryStr};
                    }else {
                        self.dic = @{@"eliteId":@(16),@"sortName":@"goodComments",@"sort":@"desc",@"keyword":self.queryStr};
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 103:
        {
            switch (self.type) {
                case 0:
                {
                    if (self.isUp) {
                        self.sort = @"price_asc";
                    }else {
                        self.sort = @"price_des";
                    }
                    self.dic = @{@"q":self.queryStr,@"sort":self.sort,@"start_price":@"5"};
                }
                    break;
                case 1:
                {
                    if (self.isUp) {
                        self.dic = @{@"sort_type":@(9),@"keyword":self.queryStr};
                    }else {
                        self.dic = @{@"sort_type":@(10),@"keyword":self.queryStr};
                    }
                }
                    break;
                case 2:
                {
                    if (self.isUp) {
                        self.dic = @{@"eliteId":@(16),@"sortName":@"price",@"sort":@"asc",@"keyword":self.queryStr};
                    }else {
                        self.dic = @{@"eliteId":@(16),@"sortName":@"price",@"sort":@"desc",@"keyword":self.queryStr};
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)showHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];;
    hud.mode = MBProgressHUDModeIndeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){

    }

    return self.dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    switch (self.type) {
        case 0:
            [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
            break;
        case 1:
            [self.refresh.arrData addObjectsFromArray:[MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:data]];
            break;
        case 2:
            [self.refresh.arrData addObjectsFromArray:[MEJDCoupleModel mj_objectArrayWithKeyValuesArray:data]];
            break;
        default:
            break;
    }
    
}

#pragma mark- CollectionView Delegate And DataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case 0:
        {
            MECoupleModel *model = self.refresh.arrData[indexPath.row];
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            MEJDCoupleModel *model = self.refresh.arrData[indexPath.row];
            MEJDCoupleMailDetalVC *vc = [[MEJDCoupleMailDetalVC alloc]initWithModel:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    switch (self.type) {
        case 0:
        {
            MECoupleModel *model = self.refresh.arrData[indexPath.row];
            [cell setUIWithModel:model];
        }
            break;
        case 1:
        {
            MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
            [cell setpinduoduoUIWithModel:model];
        }
            break;
        case 2:
        {
            MEJDCoupleModel *model = self.refresh.arrData[indexPath.row];
            [cell setJDUIWithModel:model];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin, kMEGoodsMargin, kMEGoodsMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
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
    if ([title isEqualToString:@"优惠券"]) {
        [siftBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-95];
    }else {
        [siftBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-70];
    }
    [siftBtn addTarget:self action:@selector(siftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    siftBtn.backgroundColor = [UIColor whiteColor];
    
    return siftBtn;
}

#pragma helper
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-40) collectionViewLayout:layout];
        _collectionView.backgroundColor = kMEf5f4f4;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        switch (self.type) {
            case 0:
            {
                _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonTaobaokeGetDgMaterialOptional)];
                _refresh.isCoupleMater = YES;
                _refresh.isDataInside = YES;
            }
                break;
            case 1:
            {
                _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonduoduokeGetgetGoodsList)];
                _refresh.isPinduoduoCoupleMater = YES;
                _refresh.isDataInside = YES;
            }
                break;
            case 2:
            {
                _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonjingdonggoodsgoodsQuery)];
                _refresh.isJD = YES;
                _refresh.isDataInside = NO;
            }
                break;
            default:
                break;
        }
        _refresh.delegate = self;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有优惠产品";
        }];
    }
    return _refresh;
}

- (UIView *)siftView {
    if (!_siftView) {
        _siftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 40)];
        _siftView.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"综合",@"优惠券",@"销量",@"价格"];
        CGFloat itemW = SCREEN_WIDTH / titles.count;
        for (int i = 0; i < titles.count; i++) {
            UIButton *siftBtn = [self createSiftButtomWithTitle:titles[i] tag:100+i];
            siftBtn.frame = CGRectMake(itemW * i, 0, itemW, 40);
            if (i == 0) {
                siftBtn.selected = YES;
            }
            [_siftView addSubview:siftBtn];
        }
    }
    return _siftView;
}

@end
