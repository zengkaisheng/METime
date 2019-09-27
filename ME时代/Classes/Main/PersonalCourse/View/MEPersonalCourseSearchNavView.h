//
//  MEPersonalCourseSearchNavView.h
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEPersonalCourseSearchNavView : UIView

@property (nonatomic ,copy) kMeBasicBlock searchBlock;
@property (nonatomic ,copy) kMeBasicBlock backBlock;
@property (nonatomic, assign) BOOL isNoHome;

@end

NS_ASSUME_NONNULL_END
