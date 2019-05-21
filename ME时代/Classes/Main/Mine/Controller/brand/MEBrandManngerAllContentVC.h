//
//  MEBrandManngerAllContentVC.h
//  ME时代
//
//  Created by hank on 2019/3/8.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class MEBrandMemberInfo;

typedef void (^kMEBrandMemberInfoBlock)(MEBrandMemberInfo *model);

@interface MEBrandManngerAllContentVC : MEBaseVC

@property (nonatomic ,copy) kMEBrandMemberInfoBlock modelBlock;

@end

NS_ASSUME_NONNULL_END
