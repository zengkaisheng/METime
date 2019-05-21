//
//  MEStoreApplyParModel.m
//  ME时代
//
//  Created by hank on 2019/3/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEStoreApplyParModel.h"

@implementation MEStoreApplyParModel

+ (instancetype)getModel{
    MEStoreApplyParModel *model = [MEStoreApplyParModel new];
    model.token = kMeUnNilStr(kCurrentUser.token);
    model.mask_imgModel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
    model.mask_info_imgModel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
    model.business_imagesModel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
    return model;
}

@end
