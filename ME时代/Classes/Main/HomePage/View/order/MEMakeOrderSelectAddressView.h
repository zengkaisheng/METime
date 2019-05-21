//
//  MEMakeOrderSelectAddressView.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEAddressModel;
const static CGFloat kMEMakeOrderSelectAddressViewHeight = 60;

@interface MEMakeOrderSelectAddressView : UITableViewHeaderFooterView

@property (nonatomic, strong) kMeBasicBlock selectAddressBlock;
- (void)setUIWithModel:(MEAddressModel *)model;
+ (CGFloat)getViewHeightWithModel:(MEAddressModel *)model;

@end
