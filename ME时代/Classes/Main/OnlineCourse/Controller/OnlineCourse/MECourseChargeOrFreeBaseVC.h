//
//  MECourseChargeOrFreeBaseVC.h
//  志愿星
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECourseChargeOrFreeBaseVC : MEBaseVC

//type 0 视频 1 音频 isFree 是否收费 默认NO
- (instancetype)initWithType:(NSInteger)type isFree:(BOOL)isFree;

@end

NS_ASSUME_NONNULL_END
