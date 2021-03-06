//
//  MEGroupUserContentCell.h
//  志愿星
//
//  Created by gao lei on 2019/7/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEGroupUserContentModel;

@interface MEGroupUserContentCell : UITableViewCell

@property (nonatomic, copy) kMeBasicBlock groupBlock;
- (void)setUIWithModel:(MEGroupUserContentModel *)model;

@end

NS_ASSUME_NONNULL_END
