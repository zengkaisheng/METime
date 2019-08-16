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

@interface MEVideoCourseDetailCell : UITableViewCell

- (void)setUIWithArr:(NSArray*)arr model:(MECourseDetailModel *)model;

@property (nonatomic, copy) kMeIndexBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
