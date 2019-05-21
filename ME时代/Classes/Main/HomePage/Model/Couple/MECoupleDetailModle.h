//
//  MECoupleDetailModle.h
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MECoupleDetailImageModle : MEBaseModel

@property (nonatomic, copy) NSArray *string;

@end

@interface MECoupleDetailModle : MEBaseModel

@property (nonatomic, strong) NSString * cat_leaf_name;
@property (nonatomic, strong) NSString * cat_name;
@property (nonatomic, strong) NSString * item_url;
@property (nonatomic, strong) NSString * material_lib_type;
@property (nonatomic, strong) NSString * nick;
@property (nonatomic, assign) NSInteger num_iid;
@property (nonatomic, strong) NSString * pict_url;
@property (nonatomic, strong) NSString * provcity;
@property (nonatomic, strong) NSString * reserve_price;
@property (nonatomic, assign) NSInteger seller_id;
@property (nonatomic, strong) MECoupleDetailImageModle * small_images;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, assign) NSInteger volume;
@property (nonatomic, strong) NSString * zk_final_price;



@end
