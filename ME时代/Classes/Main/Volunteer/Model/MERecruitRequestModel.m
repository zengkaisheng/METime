//
//  MERecruitRequestModel.m
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecruitRequestModel.h"

@implementation MERecruitRequestModel

- (NSString *)token {
    return kMeUnNilStr(kCurrentUser.token);
}

@end
