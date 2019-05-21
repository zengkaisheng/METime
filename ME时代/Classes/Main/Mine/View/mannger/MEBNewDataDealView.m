//
//  MEBNewDataDealView.m
//  ME时代
//
//  Created by hank on 2019/2/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBNewDataDealView.h"
#import "MEBDataDealModel.h"

@interface MEBNewDataDealView ()


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


@property (weak, nonatomic) IBOutlet UILabel *lblBusinessFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblBusinessReserverDataRate;
@property (weak, nonatomic) IBOutlet UILabel *lblBusinessReserverMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblBusinessAchievementMounth;
@property (weak, nonatomic) IBOutlet UILabel *lblBusinessAchievementPercent;

@property (weak, nonatomic) IBOutlet UILabel *lblMarketTotalPeople;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketTotalDeal;

@property (weak, nonatomic) IBOutlet UILabel *lblDealPeoplePercent;
@property (weak, nonatomic) IBOutlet UILabel *lblAllProjectPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblNomalProjectPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblPromotionProjectPercent;


@property (weak, nonatomic) IBOutlet UILabel *lblDealPeoplePercentTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblGengerRateTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayUserCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketTotalPeopleTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketTotalDealTitle;

@end

@implementation MEBNewDataDealView

- (void)awakeFromNib{
    [super awakeFromNib];
    _lblDealPeoplePercentTitle.adjustsFontSizeToFitWidth = YES;
    _lblGengerRateTitle.adjustsFontSizeToFitWidth = YES;
    _lblTodayUserCountTitle.adjustsFontSizeToFitWidth = YES;
    _lblMarketTotalPeopleTitle.adjustsFontSizeToFitWidth = YES;
    _lblMarketTotalDealTitle.adjustsFontSizeToFitWidth = YES;
}

- (void)setUIWithModel:(MEBDataDealModel *)Model{
//    _lblGengerRate.text = [NSString stringWithFormat:@"%@:%@:%@",kMeUnNilStr(Model.member.man),kMeUnNilStr(Model.member.women),kMeUnNilStr(Model.member.privary)];
    _lblAllUserCount.text = kMeUnNilStr(Model.member.total);
    _lblTodayUserCount.text = kMeUnNilStr(Model.member.today_new_member);
    _lblAllCost.text = kMeUnNilStr(Model.goods.total_sales);
//    _lblGenerCostRate.text = [NSString stringWithFormat:@"%@:%@:%@",kMeUnNilStr(Model.goods.man_sales),kMeUnNilStr(Model.goods.women_sales),kMeUnNilStr(Model.goods.privary_sales)];
    _lblAllOrder.text = kMeUnNilStr(Model.order.total_order_count);
    _lblTodayOrder.text = kMeUnNilStr(Model.order.today_order_count);
    
//    _lblCanUserMoney.text = kMeUnNilStr(Model.brokerage.can_use_brokerage);
//    _lblNotUseMoney.text = kMeUnNilStr(Model.brokerage.settle_accounts_no);
//    _lblUsedMoney.text = kMeUnNilStr(Model.brokerage.settle_accounts_ok);
//    _lblTodayMoney.text = kMeUnNilStr(Model.brokerage.today_brokerage);
    
    
    _lblBusinessFollow.text = kMeUnNilStr(Model.business.follow);
    
//    _lblBusinessReserverDataRate.text = kMeUnNilStr(Model.business.reserveDealPercent);
//    _lblBusinessAchievementPercent.text = kMeUnNilStr(Model.business.achievementPercent);

    
    
    _lblBusinessReserverMonth.text = kMeUnNilStr(Model.business.reserveMounth);
    _lblBusinessAchievementMounth.text = kMeUnNilStr(Model.business.achievementMounth);
    
    
    _lblMarketTotalPeople.text = kMeUnNilStr(Model.marketing.totalPeople);
    _lblMarketTotalDeal.text = kMeUnNilStr(Model.marketing.totalDeal);
    
    _lblDealPeoplePercent.text = kMeUnNilStr(Model.storeProject.dealPeoplePercent);
    
//    _lblAllProjectPercent.text = kMeUnNilStr(Model.storeProject.allProjectPercent);
//    _lblNomalProjectPercent.text = kMeUnNilStr(Model.storeProject.nomalProjectPercent);
//    _lblPromotionProjectPercent.text = kMeUnNilStr(Model.storeProject.promotionProjectPercent);
}

- (IBAction)structAction:(UIButton *)sender {
    kMeCallBlock(_StructBlock);
}

- (IBAction)stroeCumterAction:(UIButton *)sender {
    kMeCallBlock(_storeCustomer);
}




@end
