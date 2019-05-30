//
//  MENewProductCell.h
//  ME时代
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MENewProductCell : UITableViewCell

- (void)setUIWithArr:(NSArray*)arr;
+ (CGFloat)getCellHeightWithArr:(NSArray*)arr;

@end

NS_ASSUME_NONNULL_END
