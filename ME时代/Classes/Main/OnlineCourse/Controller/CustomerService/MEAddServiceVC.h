//
//  MEAddServiceVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddServiceVC : MEBaseVC

@property (nonatomic, copy) kMeObjBlock finishBlock;
@property (nonatomic, assign) BOOL isAddService;
- (instancetype)initWithInfo:(NSDictionary *)info filesId:(NSInteger)filesId;

@end

NS_ASSUME_NONNULL_END
