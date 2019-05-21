//
//  MEMakeOrderVC.h
//  ME时代
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

//来自好友分享
@property(nonatomic, copy) NSString *uid;

@end
