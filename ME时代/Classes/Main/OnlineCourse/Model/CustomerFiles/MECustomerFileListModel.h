//
//  MECustomerFileListModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECustomerFileListModel : MEBaseModel

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) NSInteger idField;
//服务列表
@property (nonatomic, assign) NSInteger customer_files_id;

@end

NS_ASSUME_NONNULL_END
