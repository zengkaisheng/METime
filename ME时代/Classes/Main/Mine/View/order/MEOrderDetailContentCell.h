//
//  MEOrderDetailContentCell.h
//  ME时代
//
//  Created by gao lei on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEAppointDetailModel;
@class MEOrderGoodModel;
@class MEOrderDetailModel;

const static CGFloat kMEOrderDetailContentCellHeight = 131;

@interface MEOrderDetailContentCell : UITableViewCell

//
//- (void)setUiWithModel:(MEOrderDetailModel *)model;
//订单
- (void)setUIWithChildModel:(MEOrderGoodModel *)model;
//预约
- (void)setAppointUIWithChildModel:(MEAppointDetailModel *)model;

@end
