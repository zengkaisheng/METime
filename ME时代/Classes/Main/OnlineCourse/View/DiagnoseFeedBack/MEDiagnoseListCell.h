//
//  MEDiagnoseListCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEDiagnoseConsultModel;
@class MEDiagnoseReportModel;

@interface MEDiagnoseListCell : UITableViewCell

- (void)setUIWithConsultModel:(MEDiagnoseConsultModel *)model;
- (void)setUIWithReportModel:(MEDiagnoseReportModel *)model;

@end

NS_ASSUME_NONNULL_END
