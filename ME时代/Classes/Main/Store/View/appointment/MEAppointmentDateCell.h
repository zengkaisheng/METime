//
//  MEAppointmentDateCell.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEAppointmentDateCellHeight = 50;
const static CGFloat kMEAppointmentDateCellWidth = 67;

@interface MEAppointmentDateCell : UICollectionViewCell

- (void)setUIWithModel:(METimeModel *)model isSelect:(BOOL)isSelect;

@end
