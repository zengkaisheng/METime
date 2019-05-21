//
//  MECoupleHomeMainGoodGoodsCell.m
//  ME时代
//
//  Created by hank on 2019/1/3.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MECoupleHomeMainGoodGoodsCell.h"
#import "MECoupleMailCell.h"
#import "MECoupleModel.h"
#import "MECoupleMailDetalVC.h"
#import "MECoupleHomeVC.h"
#import "MEPinduoduoCoupleModel.h"

@interface MECoupleHomeMainGoodGoodsCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_arrModel;
    BOOL _isTbK;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MECoupleHomeMainGoodGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _arrModel = @[];
    [self initSomeThing];
    // Initialization code
}

#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_selectBlock){
        kMeCallBlock(_selectBlock,indexPath.row);
        return;
    }
    if(_isTbK){
         MECoupleModel *model = _arrModel[indexPath.row];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url)];
        MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
        if(homevc){
            [homevc.navigationController pushViewController:vc animated:YES];
        }
    }else{
        MEPinduoduoCoupleModel *model = _arrModel[indexPath.row];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:model];
        MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
        if(homevc){
            [homevc.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    if(_isTbK){
        MECoupleModel *model = _arrModel[indexPath.row];
        [cell setUIWithModel:model];
    }else{
        MEPinduoduoCoupleModel *model = _arrModel[indexPath.row];
        [cell setpinduoduoUIWithModel:model];
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMEMargin, 0, kMEMargin, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEMargin;
}

- (void)initSomeThing{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.backgroundColor = kMEf5f4f4;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

- (void)setUIWithArr:(NSArray*)arr{
    _isTbK = YES;
    _arrModel = kMeUnArr(arr);
    [_collectionView reloadData];
}

- (void)setPinduoduoUIWithArr:(NSArray*)arr{
    _isTbK = NO;
    _arrModel = kMeUnArr(arr);
    [_collectionView reloadData];
}

+ (CGFloat)getCellHeightWithArr:(NSArray*)arr{
    if(arr.count == 0){
        return 0;
    }
    NSInteger section = (arr.count/2)+((arr.count%2)==1?1:0);
    CGFloat height =  (section * (kMECoupleMailCellHeight+kMEMargin))+kMEMargin;
    return height;
}
@end
