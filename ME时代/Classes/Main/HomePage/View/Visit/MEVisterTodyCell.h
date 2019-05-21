//
//  MEVisterTodyCell.h
//  ME时代
//
//  Created by hank on 2018/11/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEVisterTodyCellwHeight = 214;


@interface MEVisterTodyCell : UITableViewCell
- (void)setUiWithModel:(NSNumber *)model posterCount:(NSNumber*)posterCount;
@end
