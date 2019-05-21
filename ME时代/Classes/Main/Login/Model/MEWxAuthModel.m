//
//  MEWxAuthModel.m
//  ME时代
//
//  Created by hank on 2018/9/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEWxAuthModel.h"

@implementation MEWxAuthModel

- (instancetype)init{
    if(self = [super init]){
        self.type = @"1";
        self.pid = @"0";
    }
    return self;
}

@end
