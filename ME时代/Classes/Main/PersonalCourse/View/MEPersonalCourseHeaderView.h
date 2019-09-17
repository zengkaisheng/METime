//
//  MEPersonalCourseHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define MEPersonalCourseHeaderViewHeight 212*kMeFrameScaleY()

@interface MEPersonalCourseHeaderView : UIView

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;

@property (nonatomic,copy)kMeIndexBlock selectedIndexBlock; //banner图点击下标
@property (nonatomic,copy)kMeIndexBlock titleSelectedIndexBlock;

- (void)setUIWithBannerImages:(NSArray *)images titleArray:(NSArray *)titles;

- (void)reloadTitleViewWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
