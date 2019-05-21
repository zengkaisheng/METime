//
//  METhridProductDetailsCommentCell.m
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridProductDetailsCommentCell.h"
#import "METhridProductDetailsCommentContontCell.h"
#import "MEGoodDetailModel.h"

const static CGFloat kMargin = 10;
@interface METhridProductDetailsCommentCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrModel;
@property (weak, nonatomic) IBOutlet UILabel *lblCommendNum;
@property (weak, nonatomic) IBOutlet UILabel *lblGood;

@end

@implementation METhridProductDetailsCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSomeThing];
    // Initialization code
}

- (void)initSomeThing{
    _lblCommendNum.adjustsFontSizeToFitWidth = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridProductDetailsCommentContontCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([METhridProductDetailsCommentContontCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    METhridProductDetailsCommentContontCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([METhridProductDetailsCommentContontCell class]) forIndexPath:indexPath];
    MEGoodDetailCommentModel *model = self.arrModel[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     MEGoodDetailCommentModel *model = self.arrModel[indexPath.row];
    if(kMeUnArr(model).images.count>0){
        return CGSizeMake(kMEThridProductDetailsCommentContontCellWdith, kMEThridProductDetailsCommentContontCellHeight);
    }else{
        return CGSizeMake(kMEThridProductDetailsCommentContontCellWdith-kMEThridProductDetailsCommentContontCellHeight, kMEThridProductDetailsCommentContontCellHeight);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kMargin, 0, kMargin);
}


- (void)setUIWithArr:(NSArray *)arrModel commentNum:(NSString *)commentNum goodNUm:(NSString*)goodNUm{
    _lblCommendNum.text = [NSString stringWithFormat:@"商品评价(%@)",kMeUnNilStr(commentNum)];
    _lblGood.text = nil;
    NSString *strGood = [NSString stringWithFormat:@"好评 %@",goodNUm];
    _lblGood.attributedText = [strGood attributeWithRangeOfString:@"好评" color:kMEblack];
    _arrModel = arrModel;
    [self.collectionView reloadData];
}

@end
