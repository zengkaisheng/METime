//
//  MEAiCustomerDetailModel.h
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAiCustomerDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * cellphone;
@property (nonatomic, strong) NSString * follow_up;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSArray * label;
@property (nonatomic, strong) NSArray * label_id;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString * predict_bargain;
@property (nonatomic, assign) NSInteger star_level;
@property (nonatomic, strong) NSString *tls_id;
@end

NS_ASSUME_NONNULL_END
