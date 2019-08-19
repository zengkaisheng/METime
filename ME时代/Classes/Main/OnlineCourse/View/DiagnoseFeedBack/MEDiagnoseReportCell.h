//
//  MEDiagnoseReportCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEReportDiagnosisModel;
@class MEReportAnalyseModel;

@interface MEDiagnoseReportCell : UITableViewCell

//诊断问题
- (void)setUIWithDiagnosisModel:(MEReportDiagnosisModel *)model;

//诊断分析
- (void)setUIWithAnalyseModel:(MEReportAnalyseModel *)model;

@end

NS_ASSUME_NONNULL_END
