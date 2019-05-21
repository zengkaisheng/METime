//
//  MEStoreApplyModel.h
//  ME时代
//
//  Created by hank on 2019/3/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEStoreApplyModel : MEBaseModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * authAt;
@property (nonatomic, strong) NSString * business_images;
@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * errotDesc;
@property (nonatomic, strong) NSString * id_number;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, assign) NSInteger is_change;
@property (nonatomic, assign) NSInteger is_money;
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * mask_img;
@property (nonatomic, strong) NSString * mask_info_img;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * province;
//当待审核、审核通过时的提示信息
@property (nonatomic, strong) NSString *message;
//审核失败、被禁用时
@property (nonatomic, strong) NSString *errot_desc;
@property (nonatomic, strong) NSString * qq;
@property (nonatomic, assign) NSInteger stars;
//状态： 0初始状态 1待审核 2审核通过 3审核不通过 4禁用
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * store_name;
@property (nonatomic, strong) NSString * true_name;
@property (nonatomic, strong) NSString * updated_at;

@property (nonatomic, strong) NSString * business_images_url;
@property (nonatomic, strong) NSString * mask_img_url;
@property (nonatomic, strong) NSString * mask_info_img_url;
@end

NS_ASSUME_NONNULL_END
