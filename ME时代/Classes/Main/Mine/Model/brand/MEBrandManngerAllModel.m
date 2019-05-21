//
//  MEBrandManngerAllModel.m
//  ME时代
//
//  Created by hank on 2019/3/14.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandManngerAllModel.h"
@implementation MEBrandMemberInfo : MEBaseModel

@end
@implementation MEBrandTotalModel : MEBaseModel

@end

@implementation MEBrandPercentModel : MEBaseModel

@end

@implementation MEBrandCorporateModel : MEBaseModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{return @{@"one" : @"1-50",@"two" : @"51-80",@"three" : @"81-99",@"five" : @"100"};}
@end

@implementation MEBrandManngerAllModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{return @{@"anew_member" : @"new_member"};}

MEModelObjectClassInArrayWithDic((@{@"customer_interest" : [MEBrandPercentModel class],@"alive_member" : [MEBrandTotalModel class],@"anew_member" : [MEBrandTotalModel class]}))

@end
