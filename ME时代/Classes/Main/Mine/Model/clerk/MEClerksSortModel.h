//
//  MEClerksSortModel.h
//  ME时代
//
//  Created by hank on 2019/1/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/*
 "member_id": 87970,
 "name": "Kita",
 "nick_name": "Kita",
 "header_pic": "http://thirdwx.qlogo.cn/mmopen/GNk4eEwUyr7qFZpJQKRTQWjiaI9OmXSGEs6XQj0492LT4sph8O8M2r5nqqOibhbovliakDOibU8BVTHqDavGVSmmJ6ibw3tGkfu0Y/132",
 "cellphone": "",
 "sex": 1,
 "user_type": 5,
 "created_at": "2019-01-06 14:03:41",
 "share": 0,
 "brokerage": "0.00",
 "read": 0
 */
@interface MEClerksSortModel : MEBaseModel
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * user_type;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * share;
@property (nonatomic, strong) NSString * brokerage;
@property (nonatomic, strong) NSString * read;
@end

NS_ASSUME_NONNULL_END
