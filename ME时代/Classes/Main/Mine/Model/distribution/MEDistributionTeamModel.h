//
//  MEDistributionTeamModel.h
//  ME时代
//
//  Created by hank on 2018/9/26.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

/*
 
 "created_at" = "2018-09-22 20:24:23";
 "header_pic" = "https://wx.qlogo.cn/mmopen/vi_32/ECa2GQqoLUm5cy0fIaXHm7Quicf7QsvT8T2JL3F0FXGbno529WfWC62XqwacpXD184iaLviceV29ib6h9CicbcicMjzQ/132";
 id = 76;
 "member_id" = 76;
 "nick_name" = kakAwayi;
 pid = 4;
 type = 3;
 "updated_at" = "2018-09-22 20:24:23";
 
 */

@interface MEDistributionTeamModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger  idField;
@property (nonatomic, assign) NSInteger  member_id;
@property (nonatomic, assign) NSInteger  pid;
@property (nonatomic, assign) NSInteger  type;
//云IM
@property (nonatomic, strong) NSString * tls_id;
@end
