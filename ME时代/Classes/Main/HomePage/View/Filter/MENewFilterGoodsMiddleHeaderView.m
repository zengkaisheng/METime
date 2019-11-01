//
//  MENewFilterGoodsMiddleHeaderView.m
//  志愿星
//
//  Created by gao lei on 2019/5/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewFilterGoodsMiddleHeaderView.h"
#import "MECommondCouponContentCell.h"
#import "MECoupleModel.h"
#import "MECoupleMailVC.h"
//#import "MECoupleHomeVC.h"
#import "MECoupleMailDetalVC.h"
#import "MENewFilterGoodVC.h"

const static CGFloat kMargin = 4;

@interface MENewFilterGoodsMiddleHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *BGImageV;
@property (nonatomic, strong) NSArray *arrModel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MENewFilterGoodsMiddleHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSomeThing];
    [self layoutIfNeeded];
}

- (void)initSomeThing{
    _arrModel = [NSArray array];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECommondCouponContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECommondCouponContentCell class])];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEPinduoduoCoupleModel *model = self.arrModel[indexPath.row];
    MENewFilterGoodVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MENewFilterGoodVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:model];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECommondCouponContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECommondCouponContentCell class]) forIndexPath:indexPath];
    MEPinduoduoCoupleModel *model = self.arrModel[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECommondCouponContentCellWdith* kMeFrameScaleX(), kMECommondCouponContentCellHeight* kMeFrameScaleX());
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


- (void)setUIWithArr:(NSArray *)arrModel{
    _arrModel = arrModel;
    if(arrModel.count){
        kMeWEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf.collectionView reloadData];
        });
    }
}

- (void)setbgImageViewWithImage:(NSString *)image {
    kSDLoadImg(_BGImageV, kMeUnNilStr(image));
}

@end
