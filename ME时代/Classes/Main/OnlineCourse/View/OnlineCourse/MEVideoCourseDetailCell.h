//
//  MEVideoCourseDetailCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MECourseDetailModel;
@class MEPersionalCourseDetailModel;

@interface MEVideoCourseDetailCell : UITableViewCell

- (void)setUIWithArr:(NSArray*)arr model:(MECourseDetailModel *)model;

//C端课程
- (void)setPersionalUIWithArr:(NSArray*)arr model:(MEPersionalCourseDetailModel *)model;

@property (nonatomic, copy) kMeIndexBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
