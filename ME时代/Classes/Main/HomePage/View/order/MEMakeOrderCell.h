//
//  MEMakeOrderCell.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEMakeOrderCellHeight = 64;

@interface MEMakeOrderCell : UITableViewCell

@property (nonatomic, copy) kMeTextBlock messageBlock;
@property (nonatomic , copy)kMeBasicBlock returnBlock;

- (void)setUIWithType:(MEMakrOrderCellStyle)type model:(NSString *)model;


@end
