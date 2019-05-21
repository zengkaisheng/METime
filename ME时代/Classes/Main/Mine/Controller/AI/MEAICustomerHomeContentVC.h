//
//  MEAICustomerHomeContentVC.h
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MEAICustomerHomeContentVCAddType = 0,
    MEAICustomerHomeContentVCFollowType = 1,
    MEAICustomerHomeContentVCActiveType = 2,
} MEAICustomerHomeContentVCType;

@interface MEAICustomerHomeContentVC : MEBaseVC

-(instancetype)initWithType:(MEAICustomerHomeContentVCType)type;

@end

NS_ASSUME_NONNULL_END
