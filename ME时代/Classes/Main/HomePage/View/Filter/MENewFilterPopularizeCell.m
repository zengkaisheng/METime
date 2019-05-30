//
//  MENewFilterPopularizeCell.m
//  ME时代
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewFilterPopularizeCell.h"
#import "MECommondCouponContentCell.h"
#import "MECoupleModel.h"
#import "MECoupleMailVC.h"
#import "MECoupleHomeVC.h"
#import "MECoupleMailDetalVC.h"
#import "MENewFilterGoodsVC.h"

const static CGFloat kMargin = 4;

@interface MENewFilterPopularizeCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *BGImageV;
@property (nonatomic, strong) NSArray *arrModel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MENewFilterPopularizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSomeThing];
    CGFloat imaggW = SCREEN_WIDTH - 8;
    CGFloat imageH = (imaggW *100)/732;
    self.backgroundColor = kMEf5f4f4;
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
    MENewFilterGoodsVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MENewFilterGoodsVC class] targetResponderView:self];
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

+ (CGFloat)getCellHeightWithArr:(NSArray*)arr{
    CGFloat imaggW = SCREEN_WIDTH - 8;
    CGFloat imageH = (imaggW *100)/732;
    if(arr.count == 0){
        return imageH;
    }
    CGFloat height = 221-50;
    return height+imageH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
