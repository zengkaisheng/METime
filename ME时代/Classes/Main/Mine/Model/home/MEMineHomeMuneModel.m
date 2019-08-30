//
//  MEMineHomeMuneModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMineHomeMuneModel.h"

@implementation MEMineHomeMuneChildrenModel

MEModelIdToIdField

@end


@implementation MEMineHomeMuneModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic(@{@"children":[MEMineHomeMuneChildrenModel class]})

@end
