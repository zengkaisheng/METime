//
//  MEMyCourseVIPModel.m
//  ME时代
//
//  Created by gao lei on 2019/9/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyCourseVIPModel.h"


@implementation MEMyCourseVIPDetailModel

MEModelIdToIdField

@end



@implementation MEMyCourseVIPSubModel

MEModelObjectClassInArrayWithDic((@{@"vip" : [MEMyCourseVIPDetailModel class]}))

@end



@implementation MEMyCourseVIPModel

@end
