//
//  MEMakeOrderVC.h
//  志愿星
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MEGoodDetailModel;
@interface MEMakeOrderVC : MEBaseVC

//isInteral yes 是积分兑换 NO 普通商品
- (instancetype)initWithIsinteral:(BOOL)isInteral goodModel:(MEGoodDetailModel *)goodModel;
//产品的980活动   默认不是
@property (nonatomic, assign) BOOL isProctComd;
@property (nonatomic, assign) BOOL isReceivePrize;//领取中奖奖品
@property (nonatomic, copy) NSString *activity_id;
//来自好友分享
@property(nonatomic, copy) NSString *uid;

@property(nonatomic, assign) NSInteger bargainId;
@property(nonatomic, copy) NSString *reducePrice;

@end
