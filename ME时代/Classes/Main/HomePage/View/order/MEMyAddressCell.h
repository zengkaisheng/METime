//
//  MEMyAddressCell.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEAddressModel;
const static CGFloat kMEMyAddressCellHeight = 100;

@interface MEMyAddressCell : UITableViewCell

@property (nonatomic, copy)kMeBasicBlock editBlock;
- (void)setUIWithModel:(MEAddressModel *)model isSelect:(BOOL)isSelect;

@end
