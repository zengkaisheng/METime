//
//  MEAddGoodGoodAttributeCell.h
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEAddGoodModel;
const static CGFloat kMEAddGoodGoodAttributeCellHeight = 1019;

@interface MEAddGoodGoodAttributeCell : UITableViewCell

@property (nonatomic,copy)kMeBasicBlock selectSpecBlock;
@property (nonatomic,copy)kMeBasicBlock selectRichEditBlock;
- (void)setUIWithModel:(MEAddGoodModel *)model;

@property (weak, nonatomic) IBOutlet UIImageView *imgGood;
@property (weak, nonatomic) IBOutlet UIImageView *imgGoodHot;
@property (weak, nonatomic) IBOutlet UIImageView *imgRecommend;

//0 商品 1热门 2推荐
@property (nonatomic, copy) kMeIndexBlock selectImgBlock;
@end

NS_ASSUME_NONNULL_END
