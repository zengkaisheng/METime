//
//  MECommunityServiceBaseVC.h
//  ME时代
//
//  Created by gao lei on 2019/10/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECommunityServiceBaseVC : MEBaseVC

- (instancetype)initWithClassifyId:(NSInteger)classifyId categoryHeight:(CGFloat)categoryHeight;

- (void)reloadDatas;

@end

NS_ASSUME_NONNULL_END
