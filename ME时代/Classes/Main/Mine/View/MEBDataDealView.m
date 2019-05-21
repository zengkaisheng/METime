//
//  MEBDataDealView.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBDataDealView.h"
#import "MEBDataDealModel.h"

@interface MEBDataDealView ()

@property (weak, nonatomic) IBOutlet UILabel *lblGengerRate;
@property (weak, nonatomic) IBOutlet UILabel *lblAllUserCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayUserCount;
@property (weak, nonatomic) IBOutlet UILabel *lblAllCost;
@property (weak, nonatomic) IBOutlet UILabel *lblGenerCostRate;
@property (weak, nonatomic) IBOutlet UILabel *lblAllOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblCanUserMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblNotUseMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblUsedMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayMoney;

@end

@implementation MEBDataDealView

- (void)setUIWithModel:(MEBDataDealModel *)Model{
//    _lblGengerRate.text = [NSString stringWithFormat:@"%@/%@/%@",kMeUnNilStr(Model.member.man),kMeUnNilStr(Model.member.women),kMeUnNilStr(Model.member.privary)];
    _lblAllUserCount.text = kMeUnNilStr(Model.member.total);
    _lblTodayUserCount.text = kMeUnNilStr(Model.member.today_new_member);
    _lblAllCost.text = kMeUnNilStr(Model.goods.total_sales);
//    _lblGenerCostRate.text = [NSString stringWithFormat:@"%@/%@/%@",kMeUnNilStr(Model.goods.man_sales),kMeUnNilStr(Model.goods.women_sales),kMeUnNilStr(Model.goods.privary_sales)];
    _lblAllOrder.text = kMeUnNilStr(Model.order.total_order_count);
    _lblTodayOrder.text = kMeUnNilStr(Model.order.today_order_count);
//    _lblCanUserMoney.text = kMeUnNilStr(Model.brokerage.can_use_brokerage);
//    _lblNotUseMoney.text = kMeUnNilStr(Model.brokerage.settle_accounts_no);
//    _lblUsedMoney.text = kMeUnNilStr(Model.brokerage.settle_accounts_ok);
//    _lblTodayMoney.text = kMeUnNilStr(Model.brokerage.today_brokerage);
}

@end
