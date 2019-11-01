//
//  MEPosterModel.m
//  志愿星
//
//  Created by hank on 2018/11/30.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEPosterModel.h"


@implementation MEPosterChildrenModel

MEModelIdToIdField

@end

@implementation MEPosterModel

MEModelIdToIdField
MEModelObjectClassInArrayWithDic(@{@"children" : [MEPosterChildrenModel class]})

@end
