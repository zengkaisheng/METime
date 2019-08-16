//
//  MECourseDetailVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECourseDetailVC : MEBaseVC

//type 0视频 1音频
- (instancetype)initWithId:(NSInteger)detailsId type:(NSInteger)type;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
