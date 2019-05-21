//
//  MEMyAppointmentCell.h
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEAppointmentModel;
const static CGFloat kMEMyAppointmentCellHeight = 165.0;

@interface MEMyAppointmentCell : UITableViewCell

- (void)setBUIWithModel:(MEAppointmentModel *)model Type:(MEAppointmenyStyle)type;
- (void)setUIWithModel:(MEAppointmentModel *)model Type:(MEAppointmenyStyle)type;
@property (nonatomic, copy) kMeBasicBlock cancelAppointBlock;

@end
