//
//  MEAppointAttrModel.m
//  ME时代
//
//  Created by hank on 2018/10/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointAttrModel.h"

@implementation MEAppointAttrModel

- (instancetype)initAttr{
    if(self = [super init]){
        self.token = kMeUnNilStr(kCurrentUser.token);
        self.store_id = 0;
        self.storeName = @"";
        self.reserve_number = 1;
    }
    return self;
}

@end
