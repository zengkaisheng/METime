//
//  MEApplePayModel.h
//  志愿星
//
//  Created by gao lei on 2019/10/9.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEApplePayModel : MEBaseModel

@property (nonatomic, strong) NSString * original_purchase_date_ms;
@property (nonatomic, strong) NSString * original_purchase_date_pst;
@property (nonatomic, strong) NSString * original_transaction_id;
@property (nonatomic, strong) NSString * product_id;
@property (nonatomic, strong) NSString * purchase_date_ms;
@property (nonatomic, strong) NSString * transaction_id;
@property (nonatomic, strong) NSString * order_price_true;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * token;

@end

NS_ASSUME_NONNULL_END
