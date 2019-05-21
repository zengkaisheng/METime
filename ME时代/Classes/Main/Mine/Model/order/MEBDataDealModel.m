//
//  MEBDataDealModel.m
//  ME时代
//
//  Created by hank on 2018/12/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBDataDealModel.h"


@implementation MEBDataDealageAccessStr:MEBaseModel
@end
@implementation MEBDataDealageAccess:MEBaseModel
@end

@implementation MEBDataDealAge:MEBaseModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{return @{@"one" : @"1-18",@"two" : @"19-25",@"three" : @"26-40",@"five" : @"41-50"};}
@end

@implementation MEBDataDealGoodsNum:MEBaseModel

@end

@implementation MEBDataDealstoreCustomer:MEBaseModel

MEModelObjectClassInArrayWithDic(@{@"GoodsNum" : [MEBDataDealGoodsNum class]})

@end

@implementation MEBDataDealAchievementMember: MEBaseModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{return @{@"people" : @"new"};}
@end

@implementation MEBDataDealAchievementCatagery: MEBaseModel

@end

@implementation MEBDataDealStoreAchievement: MEBaseModel
MEModelObjectClassInArrayWithDic(@{@"AchievementCatagery" : [MEBDataDealAchievementCatagery class]})
@end

@implementation MEBDataDealBusinessModel : MEBaseModel

@end

@implementation MEBDataDealmarketingModel : MEBaseModel

@end

@implementation MEBDataDealstoreProject : MEBaseModel

@end


@implementation MEBDataDealmemberModel : MEBaseModel

@end

@implementation MEBDataDealgoodsModel : MEBaseModel

@end

@implementation MEBDataDealbrokerageModel : MEBaseModel

@end

@implementation MEBDataDealorderModel : MEBaseModel

@end

@implementation MEBDataDealModel

@end
