//
//  MEPersionalCourseListVC.h
//  ME时代
//
//  Created by gao lei on 2019/9/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEPersionalCourseListVC : MEBaseVC

@property (nonatomic, assign) BOOL isFree;

- (instancetype)initWithClassifyId:(NSInteger)classifyId;

@end

NS_ASSUME_NONNULL_END
