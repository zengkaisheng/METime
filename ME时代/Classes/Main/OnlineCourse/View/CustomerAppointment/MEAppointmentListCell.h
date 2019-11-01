//
//  MEAppointmentListCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEAppointmentListModel;
#define kMEAppointmentListCellHeight 137

@interface MEAppointmentListCell : UITableViewCell

@property (nonatomic ,copy) kMeIndexBlock tapBlock;
- (void)setUIWithModel:(MEAppointmentListModel *)model;

@end

NS_ASSUME_NONNULL_END
