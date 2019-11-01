//
//  MEDiagnoseOptionsCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEOptionsSubModel;
@class MELivingHabitsOptionModel;
@class MECustomerFollowTypeModel;
@class MEExpenseSourceModel;

@interface MEDiagnoseOptionsCell : UITableViewCell

@property (nonatomic, copy) kMeTextBlock contentBlock;

- (void)setUIWithModel:(MEOptionsSubModel *)model;

- (void)setUIWithContent:(NSString *)content;
//生活习惯
- (void)setUIWithHabitsModel:(MELivingHabitsOptionModel *)model;

//跟进形式
- (void)setUIWithFollowTypeModel:(MECustomerFollowTypeModel *)model;
//消费来源
- (void)setUIWithExpenseSourceModel:(MEExpenseSourceModel *)model;

@end

NS_ASSUME_NONNULL_END
