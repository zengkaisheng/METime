//
//  MEVolunteerCommentsView.h
//  ME时代
//
//  Created by gao lei on 2019/11/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEVolunteerCommentsView : UIView

@property (assign, nonatomic) CGFloat viewHeight;    //view的自定义高度
@property (nonatomic, copy) kMeBasicBlock reloadBlock;
//招募活动
- (instancetype)initWithActivityId:(NSString *)activityId;
//公益秀
- (instancetype)initWithShowId:(NSString *)showId;

@end

NS_ASSUME_NONNULL_END
