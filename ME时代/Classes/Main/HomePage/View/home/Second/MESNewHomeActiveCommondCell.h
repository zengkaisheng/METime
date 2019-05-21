//
//  MESNewHomeActiveCommondCell.h
//  ME时代
//
//  Created by hank on 2018/12/3.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MESNewHomeActiveCommondCell : UITableViewCell

+ (CGFloat)getCellHeightWithModel:(NSArray *)arr;
- (void)setUiWithModel:(NSArray *)arr;

@end
