//
//  MEOrderDetailContentCell.h
//  志愿星
//
//  Created by gao lei on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEAppointDetailModel;
@class MEOrderGoodModel;
@class MEOrderDetailModel;
@class MERefundGoodModel;
@class MEGroupOrderDetailModel;

const static CGFloat kMEOrderDetailContentCellHeight = 131;

@interface MEOrderDetailContentCell : UITableViewCell

//
//- (void)setUiWithModel:(MEOrderDetailModel *)model;
//订单
- (void)setUIWithChildModel:(MEOrderGoodModel *)model;
//预约
- (void)setAppointUIWithChildModel:(MEAppointDetailModel *)model;

//退款
- (void)setUIWithRefundModel:(MERefundGoodModel *)model;
@property (nonatomic, assign) BOOL isApplyRefund;  //是否申请退款
@property (nonatomic, assign) BOOL isRefundDetail;  //是否退款详情

//拼团
- (void)setUIWithGroupModel:(MEGroupOrderDetailModel *)model;

@end
