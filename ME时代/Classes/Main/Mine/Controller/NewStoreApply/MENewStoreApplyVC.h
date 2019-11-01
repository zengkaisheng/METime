//
//  MENewStoreApplyVC.h
//  志愿星
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"
@class MEStoreApplyParModel;

NS_ASSUME_NONNULL_BEGIN

@interface MENewStoreApplyVC : MEBaseVC

@property (nonatomic, copy) kMeBasicBlock finishBlock;
@property (nonatomic, strong) MEStoreApplyParModel *parModel;

@end

NS_ASSUME_NONNULL_END
