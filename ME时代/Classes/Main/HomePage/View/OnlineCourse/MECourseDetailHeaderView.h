//
//  MECourseDetailHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MECourseDetailModel;
NS_ASSUME_NONNULL_BEGIN

#define kMECourseDetailHeaderViewHeight 379

@interface MECourseDetailHeaderView : UIView

@property (nonatomic, copy) kMeIndexBlock selectedBlock;

- (void)setUIWithModel:(MECourseDetailModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
