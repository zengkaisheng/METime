//
//  MEMyVIPDetailView.h
//  志愿星
//
//  Created by gao lei on 2019/9/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEMyCourseVIPInfoModel;
@class MEMyCourseVIPModel;

@interface MEMyVIPDetailView : UIView

@property (nonatomic, copy) kMeIndexBlock indexBlock;

- (void)setUIWithModel:(MEMyCourseVIPInfoModel *)model;

- (void)setUIWithVIPModel:(MEMyCourseVIPModel *)model;

+ (CGFloat)getViewHeightWithRuleHeight:(CGFloat)ruleHeight;

@end

NS_ASSUME_NONNULL_END
