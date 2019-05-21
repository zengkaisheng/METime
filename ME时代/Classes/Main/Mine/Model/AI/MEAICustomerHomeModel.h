//
//  MEAICustomerHomeModel.h
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAICustomerHomeModel : MEBaseModel

@property (nonatomic, strong) NSString * comunication;
@property (nonatomic, assign) NSInteger count_type;
@property (nonatomic, strong) NSString * header_pic;
//最后活跃时间
//@property (nonatomic, strong) NSString * maxcreatedAt;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * predict_bargain;
@end

NS_ASSUME_NONNULL_END
