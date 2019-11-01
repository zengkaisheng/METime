//
//  MEMyVIPPayRecordCell.m
//  志愿星
//
//  Created by gao lei on 2019/9/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyVIPPayRecordCell.h"
#import "MEMyCourseVIPInfoModel.h"

@interface MEMyVIPPayRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *yearLbl;
@property (weak, nonatomic) IBOutlet UILabel *buyTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *effectiveTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *overTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderSnLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;


@end


@implementation MEMyVIPPayRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEMyCourseVIPInfoModel *)model {
    _yearLbl.text = kMeUnNilStr(model.vipName);
    _buyTimeLbl.text = [NSString stringWithFormat:@"购买时间：%@",kMeUnNilStr(model.pay_time)];
    _effectiveTimeLbl.text = [NSString stringWithFormat:@"生效时间：%@",kMeUnNilStr(model.effective_time)];
    _overTimeLbl.text = [NSString stringWithFormat:@"到期时间：%@",kMeUnNilStr(model.over_time)];
    _payTypeLbl.text = [NSString stringWithFormat:@"支付方式：%@",kMeUnNilStr(model.payment_name)];
    _orderSnLbl.text = [NSString stringWithFormat:@"订单编号：%@",kMeUnNilStr(model.order_sn)];
    _amountLbl.text = [NSString stringWithFormat:@"支付金额：%@元",kMeUnNilStr(model.vip_price)];
}

@end
