//
//  MEGoodManngerGoodSpec.h
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGoodManngerGoodSpec : MEBaseModel

@property (nonatomic, strong) NSString * spec_name;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * list_order;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * idField;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString *specContent;

@end

NS_ASSUME_NONNULL_END
