//
//  MECourseAudioPlayerVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MECourseDetailModel;
@class MEPersionalCourseDetailModel;

@interface MECourseAudioPlayerVC : MEBaseVC

- (instancetype)initWithModel:(MECourseDetailModel *)model audioList:(NSArray *)audioList;

//C端课程
- (instancetype)initWithCourseModel:(MEPersionalCourseDetailModel *)model audioList:(NSArray *)audioList;

@property (nonatomic, assign) CGFloat listenTime; //试听时间

- (void)reloadDatas;

@end

NS_ASSUME_NONNULL_END
