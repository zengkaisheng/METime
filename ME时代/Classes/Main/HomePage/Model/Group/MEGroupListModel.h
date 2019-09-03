//
//  MEGroupListModel.h
//  ME时代
//
//  Created by gao lei on 2019/7/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGroupPersonModel : MEBaseModel

@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * product_images;

@end


@interface MEGroupListModel : MEBaseModel

@property (nonatomic, strong) NSString * group_desc;
@property (nonatomic, strong) NSString * group_num;
@property (nonatomic, strong) NSArray * group_person;
@property (nonatomic, strong) NSString * image_url;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, assign) NSInteger over_time;
@property (nonatomic, assign) NSInteger person_number;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * red_packet;
@property (nonatomic, strong) NSString * start_time;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * desc;

@end

NS_ASSUME_NONNULL_END
