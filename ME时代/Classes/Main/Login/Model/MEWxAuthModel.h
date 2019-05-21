//
//  MEWxAuthModel.h
//  ME时代
//
//  Created by hank on 2018/9/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
/*
 union_id    是    string    平台唯一id
 app_openid    是    string    app 微信 openid
 gender    否    string    性别 1男,2女,3保密
 nick_name    否    string    昵称
 header_pic    否    string    头像
 type    否    string    推荐类型 前期默认为 1
 pid    否    string    推荐id 前期默认为 0
 
 */
@interface MEWxAuthModel : MEBaseModel

@property (nonatomic, copy) NSString *union_id;
@property (nonatomic, copy) NSString *app_openid;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *header_pic;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pid;

@end
