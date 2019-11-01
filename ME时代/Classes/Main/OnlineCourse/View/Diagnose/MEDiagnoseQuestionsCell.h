//
//  MEDiagnoseQuestionsCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEDiagnosisSubModel;
@class MEReportQuestionsModel;
@class MEReportAnalyseModel;

@interface MEDiagnoseQuestionsCell : UITableViewCell

@property (nonatomic, copy) kMeBOOLBlock tapBlock;
//诊断问题回答相关
- (void)setUIWithDiagnosisModel:(MEDiagnosisSubModel *)model;
+ (CGFloat)getCellHeightWithModel:(MEDiagnosisSubModel *)model;

//诊断报告相关
//诊断问题报告
- (void)setUIWithQuestionModel:(MEReportQuestionsModel *)model;
+ (CGFloat)getCellHeightWithQuestionModel:(MEReportQuestionsModel *)model;
//诊断分析
- (void)setUIWithArray:(NSArray *)array;
+ (CGFloat)getCellHeightWithArray:(NSArray *)array;

- (void)setUIWithAnalyseModel:(MEReportAnalyseModel *)model;
+ (CGFloat)getCellHeightWithAnalyseModel:(MEReportAnalyseModel *)model;

@end

NS_ASSUME_NONNULL_END
