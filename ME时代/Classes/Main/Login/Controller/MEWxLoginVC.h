//
//  MEWxLoginVC.h
//  ME时代
//
//  Created by hank on 2018/10/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEWxLoginVC : MEBaseVC

+ (void)presentLoginVCWithIsShowCancel:(BOOL)isShowCancel SuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail;
+ (void)presentLoginVCWithSuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail;
@property (strong, nonatomic) kMeObjBlock blockSuccess;
@property (strong, nonatomic) kMeObjBlock blockFail;

@end
