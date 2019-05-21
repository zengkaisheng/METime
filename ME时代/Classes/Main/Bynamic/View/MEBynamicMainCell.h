//
//  MEBynamicMainCell.h
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBynamicHomeModel;
@interface MEBynamicMainCell : UITableViewCell
- (void)setUIWithModel:(MEBynamicHomeModel *)model;
+ (CGFloat)getCellHeightithModel:(MEBynamicHomeModel *)model;
@property (nonatomic, copy) kMeBasicBlock shareBlock;
@property (nonatomic, copy) kMeBasicBlock LikeBlock;
@property (nonatomic, copy) kMeBasicBlock CommentBlock;
@property (nonatomic, copy) kMeBasicBlock delBlock;
@property (nonatomic, copy) kMeBasicBlock saveBlock;
@end

NS_ASSUME_NONNULL_END
