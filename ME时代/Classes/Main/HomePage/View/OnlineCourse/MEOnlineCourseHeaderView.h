//
//  MEOnlineCourseHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEOnlineCourseHeaderViewHeight 250

@interface MEOnlineCourseHeaderView : UIView

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (nonatomic,copy) kMeIndexBlock selectedBlock;

- (void)setUIWithArray:(NSArray *)array type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
