//
//  MEDynamicGoodApplyStatusContentVC.h
//  SunSum
//
//  Created by hank on 2019/3/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MEDynamicGoodApplyStatusContentWaitType = 1,
    MEDynamicGoodApplyStatusContentSucessType = 2,
    MEDynamicGoodApplyStatusContentFailType = 3,
} MEDynamicGoodApplyStatusContentType;
@interface MEDynamicGoodApplyStatusContentVC : MEBaseVC

- (instancetype)initWithType:(MEDynamicGoodApplyStatusContentType)type;
@end

NS_ASSUME_NONNULL_END
