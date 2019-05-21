//
//  MEBynamicPublishGridModel.m
//  ME时代
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBynamicPublishGridModel.h"

@implementation MEBynamicPublishGridModel

+ (MEBynamicPublishGridModel *)modelWithImage:(UIImage *)image isAdd:(BOOL)isAdd{
    MEBynamicPublishGridModel *model = [MEBynamicPublishGridModel new];
    model.image = image;
    model.isAdd = isAdd;
    model.status = MEBynamicPublishGridModelIdelStatus;
    return model;
}

@end
