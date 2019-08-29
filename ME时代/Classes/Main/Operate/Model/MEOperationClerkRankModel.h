//
//  MEOperationClerkRankModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEOperationClerkRankModel : MEBaseModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger money;

@end

NS_ASSUME_NONNULL_END
