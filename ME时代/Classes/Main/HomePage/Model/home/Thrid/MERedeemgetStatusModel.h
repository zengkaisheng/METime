//
//  MERedeemgetStatusModel.h
//  ME时代
//
//  Created by hank on 2019/5/17.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MERedeemgetStatusModel : MEBaseModel
//1跳转商品 2跳转提交
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger goods_id;

@end

NS_ASSUME_NONNULL_END
