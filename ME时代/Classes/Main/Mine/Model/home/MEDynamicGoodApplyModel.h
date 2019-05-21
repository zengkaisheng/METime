//
//  MEDynamicGoodApplyModel.h
//  SunSum
//
//  Created by hank on 2019/3/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEDynamicGoodApplyModel : MEBaseModel
@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *goods_detail;
@property (nonatomic, copy) NSString *token;

@property (nonatomic ,strong) NSMutableArray *images;
@property (nonatomic ,assign) NSInteger status;
@property (nonatomic ,strong) NSString *idField;
@property (nonatomic ,strong) NSString *member_id;
@property (nonatomic ,strong) NSString *created_at;
@property (nonatomic ,strong) NSString *status_name;
+ (instancetype)getModel;
@end

NS_ASSUME_NONNULL_END
