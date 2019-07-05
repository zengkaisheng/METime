//
//  MEPriceAndStockModel.h
//  ME时代
//
//  Created by gao lei on 2018/9/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MECanBuyModel : MEBaseModel

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *tips;

@end


@interface MEPriceAndStockModel : MEBaseModel

@property (nonatomic, strong) NSString *goods_price;
@property (nonatomic, strong) NSString *seckill_price;
@property (nonatomic, strong) NSString *stock;
@property (nonatomic, strong) NSString *spec_img;

@property (nonatomic, strong) MECanBuyModel *can_buy;
//美豆相关
@property (nonatomic, strong) NSString * integral_lines;
//拼团相关
@property (nonatomic, strong) NSString * group_price;
@end



