//
//  MEBynamicHomeModel.h
//  ME时代
//
//  Created by hank on 2019/1/24.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEBynamicHomepraiseModel : MEBaseModel

@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, strong) NSString * nick_name;

@end

@interface MEBynamicHomecommentModel : MEBaseModel

@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * content;

@end

@interface MEBynamicHomeModel : MEBaseModel

@property (nonatomic, strong) NSArray * comment;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, assign) NSString *idField;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSArray * praise;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL praise_over;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * goods_images;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * header_pic;

@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString *goods_title;
@property (nonatomic, copy) NSString *member_id;

@end

NS_ASSUME_NONNULL_END
