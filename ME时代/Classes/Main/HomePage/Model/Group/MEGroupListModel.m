//
//  MEGroupListModel.m
//  志愿星
//
//  Created by gao lei on 2019/7/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupListModel.h"

@implementation MEGroupPersonModel

MEModelIdToIdField

@end


@implementation MEGroupListModel

MEModelObjectClassInArrayWithDic(@{@"group_person" : [MEGroupPersonModel class]})

@end
