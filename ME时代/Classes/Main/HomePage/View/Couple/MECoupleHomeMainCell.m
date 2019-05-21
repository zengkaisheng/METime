//
//  MECoupleHomeMainCell.m
//  ME时代
//
//  Created by hank on 2019/1/3.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MECoupleHomeMainCell.h"
#import "MECoupleHomeMainContentCell.h"
#import "MECoupleModel.h"
#import "MECoupleMailVC.h"
#import "MECoupleHomeVC.h"
#import "MECoupleMailDetalVC.h"

const static CGFloat kMargin = 4;

@interface MECoupleHomeMainCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    MECoupleHomeMainCellImageType _type;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageHeight;
@property (nonatomic, strong) NSArray *arrModel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation MECoupleHomeMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
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

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleModel *model = _arrModel[indexPath.row];
    MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailDetalVC *dvc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url)];
        [homevc.navigationController pushViewController:dvc animated:YES];
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


- (void)setUIWithArr:(NSArray *)arrModel type:(MECoupleHomeMainCellImageType)type{
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
    MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
    if(homevc){
        switch (_type) {
            case kTodayHotImageType:
            {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTopBuyType];
                [homevc.navigationController pushViewController:vc animated:YES];
            }
                break;
            case k99BuyImageType:
            {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearch99BuyType];
                [homevc.navigationController pushViewController:vc animated:YES];
            }
                break;
            case kBigJuanImageType:
            {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchBigJuanType];
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
