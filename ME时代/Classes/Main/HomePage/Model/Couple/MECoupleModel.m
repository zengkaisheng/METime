//
//  MECoupleModel.m
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MECoupleModel.h"
#import "MECouponInfo.h"

@implementation MECoupleSmallImageModel

@end

@implementation MECoupleModel

- (void)resetModelWithModel:(MECouponInfo *)model{
    self.couponPrice = model.coupon_amount;
    self.coupon_end_time = model.coupon_end_time;
    self.coupon_remain_count = model.coupon_remain_count;
//    self.coupon_src_scene = model.coupon_src_scene;
//    self.coupon_start_fee = model.coupon_start_fee;
    self.coupon_start_time = model.coupon_start_time;
    self.coupon_total_count = model.coupon_total_count;
//    self.coupon_type = model.coupon_type;
}

- (NSString *)couponPrice{
    if(!_couponPrice){
        if(!self.coupon_info){
            return @"";
        }
        NSRange startRange = [self.coupon_info rangeOfString:@"减"];
        NSRange endRange = NSMakeRange(self.coupon_info.length-1, 1);
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        _couponPrice = [self.coupon_info substringWithRange:range];
    }
    return _couponPrice;
}

- (NSString *)truePrice{
    if(!_truePrice){
        if(!self.couponPrice){
            return @"";
        }
        CGFloat price = [self.zk_final_price floatValue] - [self.couponPrice floatValue];
        NSString *strPrice = [NSString stringWithFormat:@"%.2f",price];
        return strPrice;
    }
    return _truePrice;
}

- (NSString *)couponSale{
    if(!_couponSale){
        _couponSale = @((self.coupon_total_count - self.coupon_remain_count)).description;
    }
    return _couponSale;
}


@end
