//
//  MEOnlineCourseRecommentCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEOnlineCourseHomeModel;

NS_ASSUME_NONNULL_BEGIN

@interface MEOnlineCourseRecommentCell : UITableViewCell

@property (nonatomic,copy) kMeIndexBlock selectedBlock;
- (void)setUpUIWithModel:(MEOnlineCourseHomeModel *)model;

@end

NS_ASSUME_NONNULL_END
