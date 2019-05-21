//
//  MEBrandAbilityAnalysisDataModel.m
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandAbilityAnalysisDataModel.h"

@implementation MEBrandAbilityAnalysisDataModel

+ (MEBrandAbilityAnalysisDataModel *)modelWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    MEBrandAbilityAnalysisDataModel *model = [MEBrandAbilityAnalysisDataModel new];
    model.title = title;
    model.subtitle = subtitle;
    return model;
}

@end
