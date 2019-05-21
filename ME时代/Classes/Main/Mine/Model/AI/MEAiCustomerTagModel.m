//
//  MEAiCustomerTagModel.m
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAiCustomerTagModel.h"


@implementation MEAiCustomerTagchildrenModel
MEModelIdToIdField
@end

@implementation MEAiCustomerTagModel

MEModelObjectClassInArrayWithDic(@{@"children":[MEAiCustomerTagchildrenModel class]})
MEModelIdToIdField

- (NSArray *)children{
    if(!_children){
        _children = [NSArray array];
    }
    return _children;
}

@end
