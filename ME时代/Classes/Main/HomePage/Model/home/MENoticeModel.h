//
//  MENoticeModel.h
//  ME时代
//
//  Created by hank on 2018/11/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MENoticeModel : MEBaseModel

@property (nonatomic, strong) NSString * ids;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger is_read;//1未读 2已读
@end
