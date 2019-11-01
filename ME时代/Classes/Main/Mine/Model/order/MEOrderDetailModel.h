//
//  MEOrderDetailModel.h
//  志愿星
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MELogistModel.h"

@interface MEexpressDetailModel : MEBaseModel

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, strong) NSString * express_name;
@property (nonatomic, strong) NSString * express_num;
@property (nonatomic, strong) NSString * express_url;

@end

@interface MEStoreGetModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
//1 未提取 2已提取
@property (nonatomic, assign) NSInteger get_status;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * updated_at;

@end

@interface MEOrderDetailExpressModel : MEBaseModel

@property (nonatomic, strong) NSString * express_company; //快递公司
@property (nonatomic, strong) NSString * express_num;     //快递单号

@end

@interface MEOrderDetailAddressModel : MEBaseModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * mobile;

@property (nonatomic, assign) NSInteger address_id;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *city_id;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString *province_id;
@property (nonatomic, strong) NSString *standby_mobile;
@property (nonatomic, assign) NSInteger uid;

@end

@interface MEOrderDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * all_freight;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_apprise;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * order_amount;
@property (nonatomic, strong) NSString * order_discount_amount;
@property (nonatomic, assign) NSInteger order_discount_num;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * order_status;
@property (nonatomic, assign) NSInteger order_type;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * order_status_name;
@property (nonatomic, strong) NSArray * children;
@property (nonatomic, strong) MEOrderDetailAddressModel * address;
@property (nonatomic, strong) MEOrderDetailExpressModel * express;
//@property (nonatomic, strong) MELogistModel *logistics;
@property (nonatomic, strong) MEStoreGetModel *store_get;

@property (nonatomic, strong) NSString * actual_money;
@property (nonatomic, strong) NSString * all_integral;
@property (nonatomic, strong) NSString * cellphone;     //店铺电话
@property (nonatomic, strong) NSString * check_top_up_member_id;
@property (nonatomic, strong) NSString * check_top_up_time;
@property (nonatomic, strong) NSString * girl_number;   //女神卡
@property (nonatomic, assign) NSInteger group_id;
@property (nonatomic, assign) NSInteger group_sn;
@property (nonatomic, strong) NSString * pay_time;      //支付时间
@property (nonatomic, strong) NSString * tips;          //提示
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * store_name;    //店铺名称
@property (nonatomic, assign) NSInteger top_up_status;
@property (nonatomic, strong) NSString * top_up_status_name;//充值状态
@property (nonatomic, strong) NSString * warehouse_ids;

@property (nonatomic, strong) NSArray *express_detail;

@property (nonatomic, assign) BOOL isTopUp;//联通充值订单
@end
