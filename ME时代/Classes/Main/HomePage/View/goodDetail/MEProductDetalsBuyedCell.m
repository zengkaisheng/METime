//
//  MEProductDetalsBuyedCell.m
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEProductDetalsBuyedCell.h"
#import "MEProductDetalsBuyedContentCell.h"
#import "MEGoodModel.h"
//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MEHomePageVC.h"
#import "MEServiceDetailsVC.h"
#import "MEMineExchangeDetailVC.h"

const static CGFloat kMargin = 15;

@interface MEProductDetalsBuyedCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL _isService;
    MEStoreDetailModel *_storeDetailModel;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrModel;

@end

@implementation MEProductDetalsBuyedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSomeThing];
    // Initialization code
}

- (void)initSomeThing{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetalsBuyedContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEProductDetalsBuyedContentCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isService){
        MEServiceDetailsVC *dVC = [MECommonTool getVCWithClassWtihClassName:[MEServiceDetailsVC class] targetResponderView:self];
        if(dVC){
            MEGoodModel *model = self.arrModel[indexPath.row];
            //有_storeDetailModel是门店进去的 nil是首页进去的
            if(_storeDetailModel){
                MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id storeDetailModel:_storeDetailModel];
                [dVC.navigationController pushViewController:dvc animated:YES];
            }else{
                MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
                [dVC.navigationController pushViewController:dvc animated:YES];
            }
        }
    }else{
        METhridProductDetailsVC *dVC = [MECommonTool getVCWithClassWtihClassName:[METhridProductDetailsVC class] targetResponderView:self];
        if(dVC){
            MEGoodModel *model = self.arrModel[indexPath.row];
            METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
            [dVC.navigationController pushViewController:dvc animated:YES];
        }else{
            MEMineExchangeDetailVC *mvc = [MECommonTool getVCWithClassWtihClassName:[MEMineExchangeDetailVC class] targetResponderView:self];
            if(mvc){
                MEGoodModel *model = self.arrModel[indexPath.row];
                METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                [mvc.navigationController pushViewController:dvc animated:YES];
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEProductDetalsBuyedContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEProductDetalsBuyedContentCell class]) forIndexPath:indexPath];
    if(_isService){
        MEGoodModel *model = self.arrModel[indexPath.row];
        [cell setUIServiceWithModel:model];
    }else{
        MEGoodModel *model = self.arrModel[indexPath.row];
        [cell setUIWithModel:model];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMEProductDetalsBuyedContentCellWidth, kMEProductDetalsBuyedContentCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kMargin, 2, kMargin);
}

- (void)setUIWithArr:(NSArray *)arrModel{
    _isService = NO;
    _arrModel = arrModel;
    [self.collectionView reloadData];
}

- (void)setServiceUIWithArr:(NSArray *)arrModel{
    _isService = YES;
    _arrModel = arrModel;
    [self.collectionView reloadData];
}

- (void)setServiceUIWithArr:(NSArray *)arrModel storeDetailModel:(MEStoreDetailModel *)storeDetailModel{
    _storeDetailModel = storeDetailModel;
    [self setServiceUIWithArr:arrModel];
}


@end
