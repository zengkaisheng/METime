//
//  MEQuestionHeaderCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEDiagnosisSubModel;

@interface MEQuestionHeaderCell : UITableViewCell

- (void)setUIWithDiagnosisModel:(MEDiagnosisSubModel *)model;

@end

NS_ASSUME_NONNULL_END
