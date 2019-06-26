//
//  MEBargainListModel.h
//  ME时代
//
//  Created by gao lei on 2019/6/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEBargainListModel : MEBaseModel

@property (nonatomic, strong) NSString * amount_money;
@property (nonatomic, assign) NSInteger bargin_count;
@property (nonatomic, assign) NSInteger bargin_num;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger finish_bargin_num;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * product_price;
@property (nonatomic, assign) NSInteger start_num;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger today_finish_bargin_num;

@end

NS_ASSUME_NONNULL_END
