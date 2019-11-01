//
//  MEVideoCourseDetailCell.m
//  志愿星
//
//  Created by gao lei on 2019/8/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEVideoCourseDetailCell.h"
#import "MECourseListItem.h"
#import "MEOnlineCourseListModel.h"
#import "MECourseDetailModel.h"

#import "MEPersionalCourseDetailModel.h"

@interface MEVideoCourseDetailCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_arrModel;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *courseCountBtn;
@property (weak, nonatomic) IBOutlet UILabel *listTitleLbl;

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
    [_arrModel enumerateObjectsUsingBlock:^(MEOnlineCourseListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.isSelected = NO;
    }];
    MEOnlineCourseListModel *model = _arrModel[indexPath.row];
    model.isSelected = YES;
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    if(_selectBlock){
        kMeCallBlock(_selectBlock,indexPath.row);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECourseListItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECourseListItem class]) forIndexPath:indexPath];
    MEOnlineCourseListModel *model = _arrModel[indexPath.row];
    [item setUIWithModel:model];
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
    _collectionView.hidden = YES;
    _listTitleLbl.hidden = YES;
    _courseCountBtn.hidden = YES;
}

- (void)setUIWithArr:(NSArray*)arr model:(MECourseDetailModel *)model{
    _arrModel = kMeUnArr(arr);
    if (kMeUnNilStr(model.video_name).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.video_name);
    }else if (kMeUnNilStr(model.audio_name).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.audio_name);
    }
    
    _timeLbl.text = kMeUnNilStr(model.updated_at);
    _learnCountLbl.text = [NSString stringWithFormat:@"%ld次学习",model.browse];
    [_courseCountBtn setTitle:[NSString stringWithFormat:@"共%ld课",arr.count] forState:UIControlStateNormal];
    [_collectionView reloadData];
}
//C端课程
- (void)setPersionalUIWithArr:(NSArray*)arr model:(MEPersionalCourseDetailModel *)model {
    _arrModel = kMeUnArr(arr);
    _titleLbl.text = kMeUnNilStr(model.name);
    
    _timeLbl.text = kMeUnNilStr(model.updated_at);
    _learnCountLbl.text = [NSString stringWithFormat:@"%@次学习",kMeUnNilStr(model.study_num)];
    [_courseCountBtn setTitle:[NSString stringWithFormat:@"共%ld课",arr.count] forState:UIControlStateNormal];
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
