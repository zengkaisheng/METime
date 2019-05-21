//
//  MEMineExchangeRudeCell.h
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEMineExchangeRudeCell : UITableViewCell

- (void)setUIWithModel:(id)model;
+ (CGFloat)getCellHeight:(NSString *)title;

@end
