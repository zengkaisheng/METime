//
//  MEMyOrderDetailCell.h
//  志愿星
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEMyOrderDetailCellHeight = 49;

@interface MEMyOrderDetailCell : UITableViewCell

- (void)setUIWithModel:(id)model Type:(MEOrderSettlmentStyle)type orderType:(MEOrderStyle)orderType;
- (void)setAppointUIWithModel:(id)model appointType:(MEAppointmentSettlmentStyle)type orderType:(MEAppointmenyStyle)orderType;

- (void)setUIWithAmount:(NSString *)amount;

- (void)setUIWithRefundDetail:(NSString *)desc;

- (void)setGroupUIWithInfo:(NSDictionary *)info;

- (void)setLianTongUIWithContent:(NSString *)content;

@end
