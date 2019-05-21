//
//  MEBdataTopCell.m
//  ME时代
//
//  Created by hank on 2019/3/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBdataTopCell.h"
#import "MEBDataDealModel.h"

@interface  MEBdataTopCell()

@property (weak, nonatomic) IBOutlet UILabel *lblAllCost;
@property (weak, nonatomic) IBOutlet UILabel *lblAllUserCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayUserCount;

@property (weak, nonatomic) IBOutlet UILabel *lblAllOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblBusinessFollow;

@property (weak, nonatomic) IBOutlet UILabel *lblBusinessReserverMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblBusinessAchievementMounth;
@property (weak, nonatomic) IBOutlet UILabel *lblAchievementMouth;

@end

@implementation MEBdataTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEBDataDealModel *)Model{

    _lblAllCost.text = kMeUnNilStr(Model.goods.total_sales);
    _lblAllUserCount.text = kMeUnNilStr(Model.member.total);
    _lblTodayUserCount.text = kMeUnNilStr(Model.member.today_new_member);

    
    _lblAllOrder.text = kMeUnNilStr(Model.order.total_order_count);
    _lblTodayOrder.text = kMeUnNilStr(Model.order.today_order_count);
    _lblBusinessFollow.text = kMeUnNilStr(Model.business.follow);

    _lblBusinessReserverMonth.text = kMeUnNilStr(Model.business.reserveMounth);
    _lblBusinessAchievementMounth.text = kMeUnNilStr(Model.business.achievementMounth);
    _lblAchievementMouth.text = kMeUnNilStr(Model.storeAchievement.AchievementMouth);
    
}


@end
