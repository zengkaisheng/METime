//
//  MESuperMemberHomeModel.h
//  ME时代
//
//  Created by hank on 2018/10/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

/*
 "meidou_exchang": [],
 "member_buy": []
 */

@interface MESuperMemberHomeModel : MEBaseModel

@property (nonatomic, copy) NSArray *meidou_exchang;
@property (nonatomic, copy) NSArray *member_buy;

@end
