//
//  MESuperMemberHomeModel.m
//  ME时代
//
//  Created by hank on 2018/10/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESuperMemberHomeModel.h"
#import "MEGoodModel.h"

@implementation MESuperMemberHomeModel

MEModelObjectClassInArrayWithDic((@{@"meidou_exchang" : [NSDictionary class],@"member_buy" : [MEGoodModel class]}))


- (NSArray *)member_buy{
    if(!_member_buy){
        return [NSArray array];
    }
    return _member_buy;
}

- (NSArray *)meidou_exchang{
    if(!_meidou_exchang){
        return [NSArray array];
    }
    return _meidou_exchang;
}
@end
