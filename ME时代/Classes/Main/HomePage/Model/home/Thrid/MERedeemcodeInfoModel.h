//
//  MERedeemcodeInfoModel.h
//  ME时代
//
//  Created by hank on 2019/5/17.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MERedeemcodeInfoModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * explain;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * redeem_goods_id;
@property (nonatomic, strong) NSString * redeem_info;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
