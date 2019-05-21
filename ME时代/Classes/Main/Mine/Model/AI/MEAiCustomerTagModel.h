//
//  MEAiCustomerTagModel.h
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAiCustomerTagchildrenModel : MEBaseModel

@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * label_name;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) BOOL isSelect;
@end

@interface MEAiCustomerTagModel : MEBaseModel

@property (nonatomic, strong) NSArray * children;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * store_id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
