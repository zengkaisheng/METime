//
//  MERecruitDetailCell.h
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MERecruitDetailCell : UITableViewCell

- (void)setUIWithContent:(NSString *)content;
+ (CGFloat)getCellHeightWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
