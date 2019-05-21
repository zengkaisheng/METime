//
//  MEBrandStoryModel.m
//  ME时代
//
//  Created by hank on 2019/4/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandStoryModel.h"

@implementation MEBrandStoryContentModel : MEBaseModel

@end

@implementation MEBrandStoryModel

- (NSMutableArray *)arrdata{
    if(!_arrdata){
        _arrdata = [NSMutableArray array];
    }
    return _arrdata;
}

@end
