//
//  MEAppointmentTimeCell.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

# define kMEAppointmentTimeCellWdith ((SCREEN_WIDTH - 30)/5)
# define kMEAppointmentTimeCellHeight (45)

@interface MEAppointmentTimeCell : UICollectionViewCell

- (void)setUIWithModel:(METimeModel *)model isSelect:(BOOL)isSelect;

@end
