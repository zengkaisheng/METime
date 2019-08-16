//
//  MEDiagnoseOrderListModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEDiagnoseOrderListModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * product_name;
@property (nonatomic, strong) NSString * product_image;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * telephone;
@property (nonatomic, strong) NSString * over_time;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, assign) NSInteger service_status;
@property (nonatomic, strong) NSString * appraise;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * effective_time;
@property (nonatomic, strong) NSString * buy_time;
@property (nonatomic, strong) NSString * pay_time;

@property (nonatomic, assign) BOOL isSpread;//是否展开 默认NO
@property (nonatomic, assign) CGFloat contentHeight;


@end

NS_ASSUME_NONNULL_END
