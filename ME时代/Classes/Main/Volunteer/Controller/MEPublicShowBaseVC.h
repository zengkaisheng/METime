//
//  MEPublicShowBaseVC.h
//  志愿星
//
//  Created by gao lei on 2019/10/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEPublicShowBaseVC : MEBaseVC

@property (nonatomic, assign) BOOL isHome;
- (instancetype)initWithClassifyId:(NSInteger)classifyId categoryHeight:(CGFloat)categoryHeight;

@end

NS_ASSUME_NONNULL_END
