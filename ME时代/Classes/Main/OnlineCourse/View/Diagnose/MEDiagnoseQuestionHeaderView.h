//
//  MEDiagnoseQuestionHeaderView.h
//  志愿星
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEReportQuestionsModel;
@class MEReportAnalyseModel;

@interface MEDiagnoseQuestionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) kMeBOOLBlock tapBlock;

- (void)setUIWithTitle:(NSString *)title font:(CGFloat)font isHiddenBtn:(BOOL)isHidden;

- (void)setUIWithQuestionModel:(MEReportQuestionsModel *)model;

- (void)setUIWithAnalyseModel:(MEReportAnalyseModel *)model;

- (void)setUIWithSectionTitle:(NSString *)title isAdd:(BOOL)isAdd;

@property (nonatomic, assign) BOOL isShowArrow;
@property (nonatomic, assign) BOOL isShowLine;
- (void)setUIWithSectionTitle:(NSString *)title isHeader:(BOOL)isHeader;

@end

NS_ASSUME_NONNULL_END
