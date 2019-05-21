//
//  MECouponOrderCell.m
//  ME时代
//
//  Created by hank on 2018/12/27.
//  Copyright © 2018 hank. All rights reserved.
//

#import "MECouponOrderCell.h"
#import "MECouponMoneyModel.h"
#import "MEJDCouponMoneyModel.h"
#import "MECouponBtModel.h"

@interface MECouponOrderCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCommission;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end

@implementation MECouponOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MECouponMoneyModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.goods_thumbnail_url));
    _lblTitle.text = kMeUnNilStr(model.goods_name);
    _lblTime.text = [NSString stringWithFormat:@"下单时间:%@",kMeUnNilStr(model.created_at)];
    
    _lblPrice.text =  [NSString stringWithFormat:@"消费金额¥%@",[MECommonTool changeformatterWithFen:@(model.order_amount)]];
    _lblCommission.text = [NSString stringWithFormat:@"佣金估计¥%@",[MECommonTool changeformatterWithFen:@(model.promotion_amount)]];
    _lblStatus.text = kMeUnNilStr(model.status);
}

- (void)setJDUIWithModel:(MEJDCouponMoneyModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.imgUrl));
    _lblTitle.text = kMeUnNilStr(model.skuName);
    _lblTime.text = [NSString stringWithFormat:@"下单时间:%@",kMeUnNilStr(model.orderTime)];
    
    _lblPrice.text =  [NSString stringWithFormat:@"消费金额¥%@",kMeUnNilStr(model.price)];
    _lblCommission.text = [NSString stringWithFormat:@"佣金估计¥%@",kMeUnNilStr(model.actualFee)];
    _lblStatus.text = kMeUnNilStr(model.status);
}

- (void)setTbUIWithModel:(MECouponBtModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.pic_url));
    _lblTitle.text = kMeUnNilStr(model.item_title);
    _lblTime.text = [NSString stringWithFormat:@"下单时间:%@",kMeUnNilStr(model.create_time)];
    
    _lblPrice.text =  [NSString stringWithFormat:@"消费金额¥%@",kMeUnNilStr(model.price)];
    _lblCommission.text = [NSString stringWithFormat:@"佣金估计¥%@",kMeUnNilStr(model.expected_money)];
    _lblStatus.text = kMeUnNilStr(model.status_name);
}

@end
