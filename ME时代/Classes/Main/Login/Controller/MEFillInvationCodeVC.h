//
//  MEFillInvationCodeVC.h
//  志愿星
//
//  Created by gao lei on 2019/6/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEFillInvationCodeVC : MEBaseVC

+ (void)presentFillInvationCodeVCWithSuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail;

@property (strong, nonatomic) kMeObjBlock blockSuccess;
@property (strong, nonatomic) kMeObjBlock blockFail;

@end

NS_ASSUME_NONNULL_END
