//
//  MEPersionalVideoPlayVC.h
//  ME时代
//
//  Created by gao lei on 2019/9/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MEPersionalCourseDetailModel;

@interface MEPersionalVideoPlayVC : MEBaseVC

- (instancetype)initWithModel:(MEPersionalCourseDetailModel *)model videoList:(NSArray *)videoList;

@property (nonatomic, assign) NSInteger listenTime; //试听时间

- (void)reloadDatas;

@end

NS_ASSUME_NONNULL_END
