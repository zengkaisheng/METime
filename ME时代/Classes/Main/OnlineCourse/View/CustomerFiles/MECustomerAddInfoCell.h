//
//  MECustomerAddInfoCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEAddCustomerInfoModel;

@interface MECustomerAddInfoCell : UITableViewCell

@property (nonatomic, copy) kMeTextBlock textBlock;
- (void)setUIWithCustomerModel:(MEAddCustomerInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
