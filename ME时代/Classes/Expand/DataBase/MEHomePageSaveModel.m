//
//  MEHomePageSaveModel.m
//  ME时代
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEHomePageSaveModel.h"

@implementation MEHomePageSaveModel

+ (MEHomePageSaveModel *)getSaveModel{
    MEHomePageSaveModel *saveModel = [MEHomePageSaveModel getObjctForKey:kMEHomePageSaveModelSaveModelPath path:TCodingPathDocument];
    if(!saveModel){
        saveModel = [MEHomePageSaveModel new];
    }
    return saveModel;
}
+ (void)saveAdsModel:(NSArray *)arrAdsModel{
    MEHomePageSaveModel *saveModel = [self getSaveModel];
    saveModel.arrAdsModel = arrAdsModel;
    [saveModel writeObjectForKey:kMEHomePageSaveModelSaveModelPath path:TCodingPathDocument];
}
+ (void)saveHotModel:(NSArray *)arrHotModel{
    MEHomePageSaveModel *saveModel = [self getSaveModel];
    saveModel.arrHotModel = arrHotModel;
    [saveModel writeObjectForKey:kMEHomePageSaveModelSaveModelPath path:TCodingPathDocument];
}
+ (void)saveProductModel:(NSArray *)arrProductModel{
    MEHomePageSaveModel *saveModel = [self getSaveModel];
    saveModel.arrProductModel = arrProductModel;
    [saveModel writeObjectForKey:kMEHomePageSaveModelSaveModelPath path:TCodingPathDocument];
}
+ (void)saveServiceModel:(NSArray *)arrServiceModel{
    MEHomePageSaveModel *saveModel = [self getSaveModel];
    saveModel.arrServiceModel = arrServiceModel;
    [saveModel writeObjectForKey:kMEHomePageSaveModelSaveModelPath path:TCodingPathDocument];
}

+ (NSArray *)getAdsModel{
    MEHomePageSaveModel *saveModel = [self getSaveModel];
    return kMeUnArr(saveModel.arrAdsModel);
}
+ (NSArray *)getHotModel{
    MEHomePageSaveModel *saveModel = [self getSaveModel];
    return kMeUnArr(saveModel.arrHotModel);
}
+ (NSArray *)getProductModel{
    MEHomePageSaveModel *saveModel = [self getSaveModel];
    return kMeUnArr(saveModel.arrProductModel);
}
+ (NSArray *)getServiceModel{
    MEHomePageSaveModel *saveModel = [self getSaveModel];
    return kMeUnArr(saveModel.arrServiceModel);
}

@end
