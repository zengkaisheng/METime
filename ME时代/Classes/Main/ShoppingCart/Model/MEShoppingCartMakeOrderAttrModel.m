//
//  MEShoppingCartMakeOrderAttrModel.m
//  ME时代
//
//  Created by hank on 2018/9/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShoppingCartMakeOrderAttrModel.h"

@implementation MEShoppingCartMakeOrderAttrModel

- (instancetype)init{
    if(self = [super init]){
        self.token = kMeUnNilStr(kCurrentUser.token);
        self.order_type = @"1";
        self.channel = @"app";
    }
    return self;
}

@end
