//
//  MEPersionalCourseDetailVC.h
//  ME时代
//
//  Created by gao lei on 2019/9/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEPersionalCourseDetailVC : MEBaseVC

- (instancetype)initWithCourseId:(NSInteger)courseId;

- (void)reloadUI;

@end

NS_ASSUME_NONNULL_END
