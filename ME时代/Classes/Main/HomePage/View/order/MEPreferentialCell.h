//
//  MEPreferentialCell.h
//  志愿星
//
//  Created by gao lei on 2019/6/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEPreferentialCell : UITableViewCell

- (void)setAmount:(NSString *)amount;

- (void)setTitle:(NSString *)title amount:(NSString *)amount;

@end

NS_ASSUME_NONNULL_END
