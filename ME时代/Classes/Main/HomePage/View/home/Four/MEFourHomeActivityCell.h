//
//  MEFourHomeActivityCell.h
//  志愿星
//
//  Created by gao lei on 2019/7/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEBargainListModel;
@class MEGroupListModel;
@class MEGoodModel;

const static CGFloat kMMEFourHomeActivityCellHeight = 115;

@interface MEFourHomeActivityCell : UITableViewCell

@property (nonatomic,copy) kMeIndexBlock tapBlock;

- (void)setUIWithBargainModel:(MEBargainListModel *)model;

- (void)setUIWithGroupModel:(MEGroupListModel *)model;

- (void)setUIWithGoodModel:(MEGoodModel *)model;

@end

NS_ASSUME_NONNULL_END
