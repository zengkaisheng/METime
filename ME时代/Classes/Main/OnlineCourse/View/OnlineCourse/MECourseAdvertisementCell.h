//
//  MECourseAdvertisementCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MECourseAdvertisementCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (nonatomic,copy) kMeIndexBlock selectedBlock;

- (void)setUIWithArray:(NSArray *)array;

- (void)setNewCourseUIWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
