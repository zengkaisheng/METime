//
//  MEconfirmPayCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEconfirmPayCell : UITableViewCell

- (void)setFirstCellUIWithHeaderPic:(NSString *)headerPic title:(NSString *)title;

- (void)setSecondCellUIWithMoney:(NSString *)money;

- (void)setThirdCellUIWithAccount:(NSString *)account;

@end

NS_ASSUME_NONNULL_END
