//
//  MESActivityModel.m
//  ME时代
//
//  Created by hank on 2018/12/3.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESActivityModel.h"


@implementation MESActivityModel

MEModelObjectClassInArrayWithDic(@{@"banner" : [MESActivityContentModel class]})

- (MESActivityContentModel *)background{
    if(!_background){
        _background = [MESActivityContentModel new];
    }
    return _background;
}

- (NSArray *)banner{
    if(!_banner){
        _banner = [NSArray array];
    }
    return _banner;
}

@end
