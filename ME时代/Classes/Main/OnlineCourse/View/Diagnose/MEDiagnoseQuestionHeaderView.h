//
//  MEDiagnoseQuestionHeaderView.h
//  ME时代
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

@end

NS_ASSUME_NONNULL_END
