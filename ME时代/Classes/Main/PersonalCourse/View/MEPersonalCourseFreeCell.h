//
//  MEPersonalCourseFreeCell.h
//  志愿星
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEPersonalCourseFreeCell : UITableViewCell

@property (nonatomic,copy)kMeIndexBlock indexBlock;

- (void)setUIWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
