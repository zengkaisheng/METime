//
//  MECourseOrderCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MECourseOrderModel;

@interface MECourseOrderCell : UITableViewCell

- (void)setupUIWithModel:(MECourseOrderModel *)model;

@end

NS_ASSUME_NONNULL_END
