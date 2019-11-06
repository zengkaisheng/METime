//
//  MEEyesightStoreCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEGoodDetailModel;
@class MEAppointDetailModel;

@interface MEEyesightStoreCell : UITableViewCell

@property (nonatomic, copy) kMeBasicBlock pilotBlock;
- (void)setUIWithModel:(MEGoodDetailModel *)model;

- (void)setAppointmentInfoUIWithModel:(MEAppointDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
