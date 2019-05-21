//
//  MEPosterContentListCell.m
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEPosterContentListCell.h"
#import "MEPosterContentListContentCell.h"
#import "MEPosterModel.h"
#import "MECreatePosterVC.h"
#import "MEPosterContentListVC.h"

@interface MEPosterContentListCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    MEPosterModel *_model;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;


@property (nonatomic, strong) NSArray *arrModel;
@end

@implementation MEPosterContentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSomeThing];
}

- (void)initSomeThing{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPosterContentListContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEPosterContentListContentCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (IBAction)moreAction:(UIButton *)sender {
    kMeCallBlock(_moreBlock);
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEPosterChildrenModel *model = _model.children[indexPath.row];
    MECreatePosterVC *vc = [[MECreatePosterVC alloc]initWithModel:model];
    MEPosterContentListVC *homeVC = [MECommonTool getVCWithClassWtihClassName:[MEPosterContentListVC class] targetResponderView:self];
    if(homeVC){
        [homeVC.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.children.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEPosterContentListContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEPosterContentListContentCell class]) forIndexPath:indexPath];
    MEPosterChildrenModel *model = _model.children[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMEPosterContentListContentCellWdith,kMEPosterContentListContentCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return k10Margin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return k10Margin;
}

- (void)setUIWithModel:(MEPosterModel *)model{
    if(kMeUnArr(model.children).count == 0){
        self.collectionView.hidden = YES;
    }else{
        self.collectionView.hidden = NO;
    }
    _model = model;
    _lblTitle.text = kMeUnNilStr(model.classify_name);
    _lblSubTitle.text = kMeUnNilStr(model.desc);
    [self.collectionView reloadData];
}

+ (CGFloat)getCellWithModel:(MEPosterModel *)model{
    CGFloat height = kMEPosterContentListCellHeight;
    if(kMeUnArr(model.children).count == 0){
        height -=177;
    }
    return height;
}

@end
