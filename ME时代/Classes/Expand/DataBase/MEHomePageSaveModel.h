//
//  MEHomePageSaveModel.h
//  ME时代
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

#define kMEHomePageSaveModelSaveModelPath @"kMEHomePageSaveModelSaveModelPath"

@interface MEHomePageSaveModel : MEBaseModel

/**
 轮播
 */
@property (nonatomic, strong)NSArray *arrAdsModel;

/**
 爆抢Top
 */
@property (nonatomic, strong)NSArray *arrHotModel;

/**
 产品
 */
@property (nonatomic, strong)NSArray *arrProductModel;

/**
 服务
 */
@property (nonatomic, strong)NSArray *arrServiceModel;




+ (MEHomePageSaveModel *)getSaveModel;
+ (void)saveAdsModel:(NSArray *)arrAdsModel;
+ (void)saveHotModel:(NSArray *)arrHotModel;
+ (void)saveProductModel:(NSArray *)arrProductModel;
+ (void)saveServiceModel:(NSArray *)arrServiceModel;

+ (NSArray *)getAdsModel;
+ (NSArray *)getHotModel;
+ (NSArray *)getProductModel;
+ (NSArray *)getServiceModel;

@end
