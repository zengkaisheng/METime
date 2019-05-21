//
//  MEWithdrawalParamModel.h
//  ME时代
//
//  Created by hank on 2018/12/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEWithdrawalParamModel : MEBaseModel

@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *order_type;
@end
