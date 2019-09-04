//
//  MEMyCollectionModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEMyCollectionModel : MEBaseModel

@property (nonatomic, assign) NSInteger c_id;
@property (nonatomic, strong) NSString * c_images;
@property (nonatomic, strong) NSString * c_images_url;
@property (nonatomic, strong) NSString * c_name;
@property (nonatomic, assign) NSInteger c_type;
@property (nonatomic, strong) NSString * c_type_name;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * c_desc;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
