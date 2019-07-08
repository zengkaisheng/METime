//
//  MEOrderCell.h
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEOrderModel;
@class MERefundModel;
@class MEGroupOrderModel;

const static CGFloat kMEOrderCellNeedPayBtnHeight = 95.5;
const static CGFloat kMEOrderCellNoPayedBtnHeight = 52;

@interface MEOrderCell : UITableViewCell

- (void)setUIWithModel:(MEOrderModel *)model Type:(MEOrderStyle)type;
+ (CGFloat)getCellHeightWithModel:(MEOrderModel *)model Type:(MEOrderStyle)type;

//自提
- (void)setSelfUIWithModel:(MEOrderModel *)model;
+ (CGFloat)getCellSelfHeightWithModel:(MEOrderModel *)model;
@property (nonatomic, copy) kMeBasicBlock touchBlock;
@property (nonatomic, copy) kMeBasicBlock cancelOrderBlock;
//退款
- (void)setUIWithRefundModel:(MERefundModel *)model;
+ (CGFloat)getCellHeightWithRefundModel:(MERefundModel *)model;
//拼团
- (void)setUIWithGroupModel:(MEGroupOrderModel *)model;
+ (CGFloat)getCellHeightWithGroupModel:(MEGroupOrderModel *)model;

@end
