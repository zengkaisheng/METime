//
//  MEAppointmentStoreCell.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEStoreModel;
const static CGFloat kMEAppointmentStoreCellHeight = 61;

@interface MEAppointmentStoreCell : UITableViewCell

- (void)setUIWIthModel:(MEStoreModel *)model isSelect:(BOOL)isSelect;



@end
