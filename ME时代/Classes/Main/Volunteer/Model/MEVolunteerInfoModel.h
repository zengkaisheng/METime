//
//  MEVolunteerInfoModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEVolunteerInfoModel : MEBaseModel

@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, assign) NSInteger is_attention; //是否关注：1是0否
@property (nonatomic, assign) NSInteger is_praise;    //是否点赞：1是0否

@end

NS_ASSUME_NONNULL_END
