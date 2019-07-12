//
//  MENewCoupleHomeMainHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/6/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewCoupleHomeMainHeaderView.h"
#import "MECoupleHomeMainContentCell.h"
#import "MECoupleModel.h"
#import "MECoupleMailVC.h"
#import "MENewCoupleHomeVC.h"
#import "MECoupleMailDetalVC.h"

const static CGFloat kMargin = 4;

@interface MENewCoupleHomeMainHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    MENewCoupleHomeMainHeaderViewImageType _type;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageHeight;
@property (nonatomic, strong) NSArray *arrModel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation MENewCoupleHomeMainHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSomeThing];
    CGFloat imaggW = SCREEN_WIDTH - 8;
    CGFloat imageH = (imaggW *100)/732;
    _consImageHeight.constant = imageH;
    [self layoutIfNeeded];
}

- (void)initSomeThing{
    _arrModel = [NSArray array];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleHomeMainContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleHomeMainContentCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)recordClickNumberWithParams:(NSDictionary *)params typeStr:(NSString *)typeStr{
    NSString *paramsStr = [NSString convertToJsonData:params];
    [MEPublicNetWorkTool recordTapActionWithParameter:@{@"type":typeStr,@"parameter":paramsStr}];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleModel *model = _arrModel[indexPath.row];
    
    NSString *typeStr;
    switch (self.recordType) {
        case 1:
            typeStr = @"3";
            break;
        case 3:
            typeStr = @"25";
            break;
        default:
            break;
    }
    NSDictionary *params = @{@"num_iid":kMeUnNilStr(model.num_iid),@"item_title":kMeUnNilStr(model.title),@"uid":kMeUnNilStr(kCurrentUser.uid)};
    [self recordClickNumberWithParams:params typeStr:typeStr];
    
    MENewCoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MENewCoupleHomeVC class] targetResponderView:self];
    if(homevc){
        if(kMeUnNilStr(model.coupon_id).length){
            MECoupleMailDetalVC *dvc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
            dvc.recordType = self.recordType;
            [homevc.navigationController pushViewController:dvc animated:YES];
        }else{
            model.coupon_click_url = [NSString stringWithFormat:@"https:%@",kMeUnNilStr(model.coupon_share_url)];//;
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithModel:model];
            vc.recordType = self.recordType;
            [homevc.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleHomeMainContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleHomeMainContentCell class]) forIndexPath:indexPath];
    MECoupleModel *model = _arrModel[indexPath.row];
    [cell setUIWIthModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECoupleHomeMainContentCellWidth, kMECoupleHomeMainContentCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMargin;
}


- (void)setUIWithArr:(NSArray *)arrModel type:(MENewCoupleHomeMainHeaderViewImageType)type{
    _type = type;
    NSString *strImage = @"";
    switch (type) {
        case kTodayHotImageType:
            strImage = @"todayBuys";
            break;
        case k99BuyImageType:
            strImage = @"99Buy";
            break;
        case kBigJuanImageType:
            strImage = @"dajuan";
            break;
        default:
            break;
    }
    _imgPic.image = [UIImage imageNamed:strImage];
    _arrModel = arrModel;
    if(arrModel.count){
        kMeWEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf.collectionView reloadData];
        });
    }
}

- (IBAction)tapAction:(UIButton *)sender {
    MENewCoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MENewCoupleHomeVC class] targetResponderView:self];
    if(homevc){
        switch (_type) {
            case kTodayHotImageType:
            {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTopBuyType];
                vc.recordType = self.recordType;
                [homevc.navigationController pushViewController:vc animated:YES];
            }
                break;
            case k99BuyImageType:
            {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearch99BuyType];
                vc.recordType = self.recordType;
                [homevc.navigationController pushViewController:vc animated:YES];
            }
                break;
            case kBigJuanImageType:
            {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchBigJuanType];
                vc.recordType = self.recordType;
                [homevc.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

+ (CGFloat)getCellHeightWithArr:(NSArray*)arr{
    CGFloat imaggW = SCREEN_WIDTH - 8;
    CGFloat imageH = (imaggW *100)/732;
    if(arr.count == 0){
        return imageH;
    }
    CGFloat height = 221-50;
    return height+imageH;
}

@end
