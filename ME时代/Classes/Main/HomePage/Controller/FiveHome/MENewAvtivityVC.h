//
//  MENewAvtivityVC.h
//  志愿星
//
//  Created by gao lei on 2019/11/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MENewAvtivityVC : MEBaseVC

@property (nonatomic, assign) BOOL isHome;

- (instancetype)initWithType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
