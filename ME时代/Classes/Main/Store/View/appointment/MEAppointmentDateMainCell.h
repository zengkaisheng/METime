//
//  MEAppointmentDateMainCell.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEAppointmentDateMainCellHeight = 125;

@interface MEAppointmentDateMainCell : UITableViewCell

@property (copy, nonatomic) kMeIndexBlock selectBlock;
- (void)setUIWithArr:(NSArray *)arr currentIndex:(NSInteger)index;

@end
