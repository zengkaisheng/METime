//
//  MEAppointmentDateMainCell.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentDateMainCell.h"
#import "MEAppointmentDateCell.h"

@interface MEAppointmentDateMainCell  ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_arrWeek;
    NSInteger _currentIndex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MEAppointmentDateMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSomeThing];
    // Initialization code
}

- (void)initSomeThing{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointmentDateCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEAppointmentDateCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _currentIndex = indexPath.row;
    kMeCallBlock(_selectBlock,_currentIndex);
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrWeek.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEAppointmentDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEAppointmentDateCell class]) forIndexPath:indexPath];
    METimeModel *model = _arrWeek[indexPath.row];
    [cell setUIWithModel:model isSelect:_currentIndex==indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMEAppointmentDateCellWidth, kMEAppointmentDateCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, k15Margin, 0, k15Margin);
}

- (void)setUIWithArr:(NSArray *)arr currentIndex:(NSInteger)index{
    _currentIndex = index;
    _arrWeek = arr;
    [self.collectionView reloadData];
}



@end
