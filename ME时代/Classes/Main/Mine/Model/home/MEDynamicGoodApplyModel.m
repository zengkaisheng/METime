//
//  MEDynamicGoodApplyModel.m
//  SunSum
//
//  Created by hank on 2019/3/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEDynamicGoodApplyModel.h"
#import "MEBynamicPublishGridModel.h"

@implementation MEDynamicGoodApplyModel

MEModelIdToIdField

+ (instancetype)getModel{
    MEDynamicGoodApplyModel *model = [MEDynamicGoodApplyModel new];
    model.token = kMeUnNilStr(kCurrentUser.token);
    model.images = [NSMutableArray array];
    MEBynamicPublishGridModel *imagemodel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
    [model.images addObject:imagemodel];
    return model;
}


@end
