//
//  MEWaitPublishPrizeCell.h
//  志愿星
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEPrizeDetailsModel;

const static CGFloat kMEWaitPublishPrizeCellHeight = 426;

@interface MEWaitPublishPrizeCell : UITableViewCell

@property (nonatomic, copy) kMeIndexBlock indexBlock;
@property (nonatomic, copy) kMeBasicBlock checkBlock;
- (void)setUIWithModel:(MEPrizeDetailsModel *)model;

@end

NS_ASSUME_NONNULL_END
