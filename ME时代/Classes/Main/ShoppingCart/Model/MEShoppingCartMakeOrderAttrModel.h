//
//  MEShoppingCartMakeOrderAttrModel.h
//  ME时代
//
//  Created by hank on 2018/9/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
/*
 token    是    string    用户唯一凭证
 cart_id    是    string    购物车id
 user_address    否    string    用户地址id
 order_type    否    string    订单类型
 remark    否    string    买家留言
 */
@interface MEShoppingCartMakeOrderAttrModel : MEBaseModel

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *cart_id;
@property (nonatomic, copy) NSString *user_address;
//1 普通下单 9 秒杀
@property (nonatomic, copy) NSString *order_type;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *remark;
@end
