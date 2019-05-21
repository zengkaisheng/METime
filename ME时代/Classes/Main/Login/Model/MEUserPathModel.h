//
//  MEUserPathModel.h
//  ME时代
//
//  Created by hank on 2018/11/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEUserPathModel : MEBaseModel

@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *group;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, assign) NSInteger idField;
@end
