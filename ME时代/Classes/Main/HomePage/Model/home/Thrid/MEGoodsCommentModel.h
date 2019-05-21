//
//  MEGoodsCommentModel.h
//  ME时代
//
//  Created by hank on 2019/1/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGoodsCommentModel : MEBaseModel

@property (nonatomic, strong) NSString * comment;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * dateted_at;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, assign) NSInteger value;

#warning
@property (nonatomic, strong) NSString * sku;

@end

NS_ASSUME_NONNULL_END
