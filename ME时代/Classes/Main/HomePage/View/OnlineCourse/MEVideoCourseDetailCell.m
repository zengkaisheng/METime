//
//  MEVideoCourseDetailCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEVideoCourseDetailCell.h"
#import "MECourseListItem.h"


@interface MEVideoCourseDetailCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_arrModel;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *courseCountLbl;

@end

@implementation MEVideoCourseDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = 0;
    _arrModel = @[];
    [self initSomeThing];
}

#pragma mark- CollectionView Delegate And DataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_selectBlock){
        kMeCallBlock(_selectBlock,indexPath.row);
        return;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECourseListItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECourseListItem class]) forIndexPath:indexPath];
//    MEJDCoupleModel *model = _arrModel[indexPath.row];
    [item setUIWithModel:indexPath.row];
    return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECourseListItemWdith, kMECourseListItemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kMECourseListItemMargin, 0, kMECourseListItemMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMECourseListItemMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)initSomeThing{
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECourseListItem class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECourseListItem class])];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

- (void)setUIWithArr:(NSArray*)arr{
    _arrModel = kMeUnArr(arr);
    [_collectionView reloadData];
}

- (IBAction)CourseCountBtnAction:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
