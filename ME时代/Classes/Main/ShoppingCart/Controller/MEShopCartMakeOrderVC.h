//
//  MEShopCartMakeOrderVC.h
//  ME时代
//
//  Created by hank on 2018/9/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEShopCartMakeOrderVC : MEBaseVC

- (instancetype)initWithIsinteral:(BOOL)isInteral WithArrChartGood:(NSArray *)arrCartModel;
@property (nonatomic, assign) BOOL isGift;
@property (nonatomic, copy) NSString *giftMessage;
@property (nonatomic, copy)kMeBasicBlock PayFinishBlock;

@end
