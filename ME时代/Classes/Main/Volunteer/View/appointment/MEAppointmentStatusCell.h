//
//  MEAppointmentStatusCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEAppointDetailModel;

@interface MEAppointmentStatusCell : UITableViewCell

- (void)setUIWithModel:(MEAppointDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
