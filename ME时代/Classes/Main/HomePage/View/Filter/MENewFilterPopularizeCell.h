//
//  MENewFilterPopularizeCell.h
//  ME时代
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MENewFilterPopularizeCell : UITableViewCell

- (void)setUIWithArr:(NSArray *)arrModel;
- (void)setbgImageViewWithImage:(NSString *)image;
+ (CGFloat)getCellHeightWithArr:(NSArray*)arr;

@end

NS_ASSUME_NONNULL_END
