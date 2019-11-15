//
//  MEMyAccountRecordModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEMyAccountRecordModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * type_name;

@end

NS_ASSUME_NONNULL_END
