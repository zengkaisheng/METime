//
//  MESActivityContentModel.h
//  ME时代
//
//  Created by hank on 2018/12/3.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
typedef enum : NSUInteger {
    MESActivityContentModelProductType = 1,
    MESActivityContentModelHtmlType = 2,
    MESActivityContentModelUrlType = 3,
} MESActivityContentModelType;
@interface MESActivityContentModel : MEBaseModel

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger show_type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger tool;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;

@end
