//
//  MEGroupOrderDetailHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/7/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupOrderDetailHeaderView.h"
#import "MEGroupOrderDetailModel.h"

@interface MEGroupOrderDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@end


@implementation MEGroupOrderDetailHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setUIWithModel:(MEGroupOrderDetailModel *)model {
    
//    switch ([kMeUnNilStr(model.order_status) integerValue]) {
//        case 3:
//            _orderStatus.text = @"订单状态：待收货";
//            break;
//        case 4:
//            _orderStatus.text = @"订单状态：已完成";
//            break;
//        case 7:
//            _orderStatus.text = @"订单状态：退款中";
//            break;
//        case 8:
//            _orderStatus.text = @"订单状态：已退款";
//            break;
//        case 10:
//            _orderStatus.text = @"订单状态：拼团进行中";
////            _timeLbl.text = @"若拼单失败，款项将在7个工作日内退回到微信余额";
//            break;
//        case 11:
//            _orderStatus.text = @"订单状态：拼团成功";
//            break;
//        case 12:
//            _orderStatus.text = @"订单状态：拼团失败";
////            _timeLbl.text = @"款项将在7个工作日内退回到微信余额";
//            break;
//        default:
//            break;
//    }
    _orderStatus.text = [NSString stringWithFormat:@"订单状态：%@",kMeUnNilStr(model.order_status_name)];
    _timeLbl.text = kMeUnNilStr(model.desc);
    
    _nameLbl.text = kMeUnNilStr(model.address.name);
    _phoneLbl.text = kMeUnNilStr(model.address.mobile);
    _addressLbl.text = [NSString stringWithFormat:@"%@%@%@%@",model.address.province_id,model.address.city_id,model.address.area_id,model.address.detail];
    
}

@end
