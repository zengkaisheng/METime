//
//  MEChooseStatusVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEChooseStatusVC : MEBaseVC

@property (strong, nonatomic) kMeIndexBlock indexBlock;

+ (void)presentChooseStatusVCWithIndexBlock:(kMeIndexBlock)indexBlock;

@end

NS_ASSUME_NONNULL_END
