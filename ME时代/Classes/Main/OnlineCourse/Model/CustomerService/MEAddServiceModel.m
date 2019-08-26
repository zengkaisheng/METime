//
//  MEAddServiceModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddServiceModel.h"

@implementation MEAddServiceModel

- (NSString *)token {
    return kMeUnNilStr(kCurrentUser.token);
}

@end
