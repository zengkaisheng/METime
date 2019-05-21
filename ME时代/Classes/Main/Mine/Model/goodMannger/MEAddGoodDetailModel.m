//
//  MEAddGoodDetailModel.m
//  ME时代
//
//  Created by hank on 2019/3/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAddGoodDetailModel.h"


@implementation MEAddGoodDetailGroupModel : MEBaseModel

@end

@implementation MEAddGoodDetailSpecIdsValueModel : MEBaseModel
MEModelIdToIdField
@end

@implementation MEAddGoodDetailSpecIdsModel : MEBaseModel
MEModelObjectClassInArrayWithDic(@{@"spec_ids_value":[MEAddGoodDetailSpecIdsValueModel class]})

@end

@implementation MEAddGoodDetailSpecNameModel : MEBaseModel

@end

@implementation MEAddGoodDetailModel
MEModelObjectClassInArrayWithDic((@{@"spec_ids" : [MEAddGoodDetailSpecIdsModel class],@"spec_name" : [MEAddGoodDetailSpecNameModel class]}))

//- (NSString *)content{
//    return @"fdsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss<img style=\"width:100%\" src=\"http://images.meshidai.com/Fl4niy-VcRHz2G-xcsKZRmOL1mKG\" alt=\"暂无图片\" width=\"100%\" height=\"auto\"> <br><img style=\"width:100%\" src=\"http://images.meshidai.com/FuerLLEfbVo211M00HfTV9IFv9b5\" alt=\"暂无图片\"><br>";
//}
@end
