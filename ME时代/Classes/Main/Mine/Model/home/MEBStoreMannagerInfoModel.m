//
//  MEBStoreMannagerInfoModel.m
//  ME时代
//
//  Created by hank on 2019/2/19.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBStoreMannagerInfoModel.h"

@implementation MEBStoreMannagercontentInfoModel

+ (MEBStoreMannagercontentInfoModel *)initWithType:(MEBStoreMannagerInfoType )type title:(NSString *)title subTitle:(NSString *)subTitle{
    MEBStoreMannagercontentInfoModel *model = [MEBStoreMannagercontentInfoModel new];
    model.type = type;
    model.title = title;
    model.subTitle = subTitle;
    return model;
}

@end

@implementation MEBStoreMannagerInfoModel

- (NSMutableArray *)arrModel{
    if(!_arrModel){
        _arrModel = [NSMutableArray array];
    }
    return _arrModel;
}

@end
