//
//  MEFiveCouponListView.m
//  ME时代
//
//  Created by gao lei on 2019/10/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFiveCouponListView.h"
#import "MECoupleModel.h"
#import "MECoupleMailCell.h"
#import "MEFiveHomeNavView.h"

#import "MEFiveHomeVC.h"
#import "MECoupleMailDetalVC.h"

#define kMEGoodsMargin ((IS_iPhoneX?8:7.5)*kMeFrameScaleX())

@interface MEFiveCouponListView ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) NSArray *arrDicParm;

@end


@implementation MEFiveCouponListView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type materialArray:(NSArray *)materialArray {
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _arrDicParm = [materialArray copy];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = kMEf5f4f4;
    
    [self addSubview:self.collectionView];
    [self.refresh addFooterRefreshView];
    [self.refresh reload];
}

#pragma -- mark -- RefreshToolDelegate
- (NSDictionary *)requestParameter{
    NSDictionary *dic = _arrDicParm[_type];
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)viewHideFooterView:(BOOL)isHide {
    self.collectionView.mj_footer.hidden = isHide;
}

#pragma mark -- ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentSize = CGSizeMake(self.frame.size.width, 0);
            kMeCallBlock(_scrollBlock);
        }else if (scrollView.contentOffset.y > 100){
            self.collectionView.mj_footer.hidden = NO;
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint viewPoint = [self.collectionView convertPoint:CGPointMake(0,0) toView:[UIApplication sharedApplication].windows.lastObject];
    if (viewPoint.y > kMEFiveHomeNavViewHeight+52) {
        self.collectionView.mj_footer.hidden = YES;
        self.collectionView.scrollEnabled = NO;
//        return NO;
    }else {
        if (self.collectionView.contentOffset.y < 0) {
            kMeCallBlock(_scrollBlock);
            self.collectionView.scrollEnabled = NO;
            return NO;
        }
        self.collectionView.scrollEnabled = YES;
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark- CollectionView Delegate And DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    MECoupleModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleModel *model = self.refresh.arrData[indexPath.row];
    
     MEFiveHomeVC *homeVC = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
    
    if (homeVC) {
        NSDictionary *params = @{@"num_iid":kMeUnNilStr(model.num_iid),@"item_title":kMeUnNilStr(model.title),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:@"3" params:params];
        
        if(kMeUnNilStr(model.coupon_id).length){
            MECoupleMailDetalVC *dvc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
            dvc.recordType = 1;
            [homeVC.navigationController pushViewController:dvc animated:YES];
        }else{
            model.coupon_click_url = [NSString stringWithFormat:@"https:%@",kMeUnNilStr(model.coupon_share_url)];
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithModel:model];
            vc.recordType = 1;
            [homeVC.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin+2, kMEGoodsMargin, kMEGoodsMargin+2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}

#pragma setter&&getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
        
        _collectionView.backgroundColor = kMEf5f4f4;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        NSString *str = MEIPcommonTaobaokeGetDgMaterialOptional;
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(str)];
        _refresh.delegate = self;
        _refresh.isCoupleMater = YES;
        _refresh.isPinduoduoCoupleMater = NO;
        _refresh.isDataInside = YES;
        _refresh.showFailView = NO;
    }
    return _refresh;
}
#pragma -- helper
- (void)saveClickRecordsWithType:(NSString *)type params:(NSDictionary *)params {
    NSDate *date = [[NSDate alloc] init];
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [tempDic setObject:[date getNowDateFormatterString] forKey:@"created_at"];
    
    NSString *paramsStr = [NSString convertToJsonData:[tempDic copy]];
    NSMutableArray *records = [[NSMutableArray alloc] init];
    if ([kMeUserDefaults objectForKey:kMEGetClickRecord]) {
        [records addObjectsFromArray:(NSArray *)[kMeUserDefaults objectForKey:kMEGetClickRecord]];
    }
    
    [records addObject:@{@"type":kMeUnNilStr(type),@"parameter":paramsStr}];
    [kMeUserDefaults setObject:records forKey:kMEGetClickRecord];
    [kMeUserDefaults synchronize];
}

@end
