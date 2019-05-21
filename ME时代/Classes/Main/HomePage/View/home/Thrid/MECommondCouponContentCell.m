//
//  MECommondCouponContentCell.m
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MECommondCouponContentCell.h"
#import "MEPinduoduoCoupleModel.h"

@interface MECommondCouponContentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblJuan;


@end

@implementation MECommondCouponContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblPrice.adjustsFontSizeToFitWidth = YES;
    _lblJuan.adjustsFontSizeToFitWidth = YES;
}

- (void)setUIWithModel:(MEPinduoduoCoupleModel *)model{
     [_imgPic sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(model.goods_thumbnail_url)] placeholderImage:kImgPlaceholder];
    _lblPrice.text = [NSString stringWithFormat:@"¥%@", [MECommonTool changeformatterWithFen:@(model.min_group_price)]];
    _lblJuan.text = [NSString stringWithFormat:@"%@元券",[MECommonTool changeformatterWithFen:@(model.coupon_discount)]];
}

@end
