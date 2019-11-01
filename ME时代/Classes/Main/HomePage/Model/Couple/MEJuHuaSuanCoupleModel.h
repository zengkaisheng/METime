//
//  MEJuHuaSuanCoupleModel.h
//  志愿星
//
//  Created by gao lei on 2019/6/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEJuHSItemUspListModel : MEBaseModel

@property (nonatomic, strong) NSArray *string;

@end


@interface MEJuHSUspDescListModel : MEBaseModel

@property (nonatomic, strong) NSArray *string;

@end


@interface MEJuHSPriceUspListModel : MEBaseModel

@property (nonatomic, strong) NSArray *string;

@end


@interface MEJuHuaSuanCoupleModel : MEBaseModel

@property (nonatomic, strong) NSString * act_price;
@property (nonatomic, strong) NSString * category_name;
@property (nonatomic, assign) NSInteger item_id;
@property (nonatomic, strong) MEJuHSItemUspListModel * item_usp_list;
@property (nonatomic, assign) NSInteger ju_id;
@property (nonatomic, assign) NSInteger online_end_time;
@property (nonatomic, assign) NSInteger online_start_time;
@property (nonatomic, strong) NSString * orig_price;
@property (nonatomic, assign) BOOL pay_postage;
@property (nonatomic, strong) NSString * pc_url;
@property (nonatomic, strong) NSString * pic_url_for_p_c;
@property (nonatomic, strong) NSString * pic_url_for_w_l;
@property (nonatomic, assign) NSInteger platform_id;
@property (nonatomic, strong) MEJuHSPriceUspListModel * price_usp_list;
@property (nonatomic, assign) NSInteger show_end_time;
@property (nonatomic, assign) NSInteger show_start_time;
@property (nonatomic, assign) NSInteger tb_first_cat_id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) MEJuHSUspDescListModel * usp_desc_list;
@property (nonatomic, strong) NSString * wap_url;

@end

NS_ASSUME_NONNULL_END
