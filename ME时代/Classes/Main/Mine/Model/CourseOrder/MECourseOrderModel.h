//
//  MECourseOrderModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MECourseOrderGoodsModel : MEBaseModel

@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * product_name;
@property (nonatomic, strong) NSString * product_image;
@property (nonatomic, assign) NSString * product_amount;
@property (nonatomic, assign) NSString * product_images_url;

@end


@interface MECourseOrderModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, assign) NSInteger order_type;
@property (nonatomic, strong) NSString * order_amount;
@property (nonatomic, strong) NSString * order_status;
@property (nonatomic, strong) MECourseOrderGoodsModel * order_goods;
@property (nonatomic, strong) NSString * order_status_name;
@property (nonatomic, strong) NSString * order_type_name;
@property (nonatomic, assign) NSInteger product_number;
@property (nonatomic, strong) NSString * created_at;

@end

NS_ASSUME_NONNULL_END

