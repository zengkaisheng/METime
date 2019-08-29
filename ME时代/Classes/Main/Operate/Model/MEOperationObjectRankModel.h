//
//  MEOperationObjectRankModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEOperationObjectRankModel : MEBaseModel

@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger total_money;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
