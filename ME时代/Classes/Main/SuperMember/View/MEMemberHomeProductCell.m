//
//  MEMemberHomeProductCell.m
//  ME时代
//
//  Created by hank on 2018/10/16.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMemberHomeProductCell.h"
#import "MEProductCell.h"
#import "MEGoodModel.h"
#import "MESuperMemberHomeModel.h"
#import "MEProductDetailsVC.h"
#import "MEMemberHomeVC.h"

@interface MEMemberHomeProductCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_arrModel;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MEMemberHomeProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSomeThing];
    _arrModel = [NSArray array];
    // Initialization code
}

- (void)initSomeThing{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEProductCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEMemberHomeVC *homeVC = (MEMemberHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEMemberHomeVC class] targetResponderView:self];
    if(homeVC){
        MEGoodModel *model = _arrModel [indexPath.row];
        MEProductDetailsVC *details = [[MEProductDetailsVC alloc]initWithId:model.product_id];
        [homeVC.navigationController pushViewController:details animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEProductCell class]) forIndexPath:indexPath];
    MEGoodModel *model = _arrModel[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat selfW = SCREEN_WIDTH - (k15Margin *4);
    CGFloat w =  (selfW-k15Margin*2)/2;
    return CGSizeMake(w, kMEProductCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

// 单元的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

// 每个小单元的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)setUiWithModel:(MESuperMemberHomeModel *)model{
    CGFloat w = SCREEN_WIDTH - (k15Margin *4);
    _consImageHeight.constant =((w * 240)/690);
    _arrModel = kMeUnArr(model.member_buy);
    [_collectionView reloadData];
}

+ (CGFloat)getCellHeightWithModel:(MESuperMemberHomeModel *)model{
    CGFloat height = 30;
    CGFloat w = SCREEN_WIDTH - (k15Margin *4);
    height+=((w * 240)/690);
    NSArray *arr = kMeUnArr(model.member_buy);;
    NSInteger section = (arr.count/2)+((arr.count%2)==1?1:0);
    height+= (section * kMEProductCellHeight);
    return height;
}

@end
