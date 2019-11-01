//
//  MEHomeTestTitleCell.h
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEHomeTestTitleModel;
@interface MEHomeTestTitleCell : UITableViewCell

+ (CGFloat)getCellheightWithMolde:(MEHomeTestTitleModel *)model;
- (void)setUIWithModel:(MEHomeTestTitleModel *)model;

@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (nonatomic,copy)kMeBasicBlock delBlock;
@property (nonatomic,copy)kMeBasicBlock shareBlock;
@end

NS_ASSUME_NONNULL_END
