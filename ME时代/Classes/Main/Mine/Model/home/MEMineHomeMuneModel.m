//
//  MEMineHomeMuneModel.m
//  志愿星
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMineHomeMuneModel.h"

@implementation MEMineHomeMuneChildrenModel

MEModelIdToIdField

@end

@implementation MEMineHomeMuneSubModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic(@{@"children":[MEMineHomeMuneChildrenModel class]})

@end

@implementation MEMineHomeMuneModel

MEModelObjectClassInArrayWithDic((@{@"menu":[MEMineHomeMuneSubModel class],@"order":[MEMineHomeMuneSubModel class]}))

@end
