//
//  MEOpenVIPView.h
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MECourseVIPModel;
@class MEMyCourseVIPDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface MEOpenVIPView : UIView

@property (nonatomic, copy) kMeBasicBlock finishBlock;

- (void)setUIWithModel:(MECourseVIPModel *)model;

- (void)setUIWithVIPModel:(MEMyCourseVIPDetailModel *)model;

+ (CGFloat)getViewHeightWithRuleHeight:(CGFloat)ruleHeight;
@end

NS_ASSUME_NONNULL_END
