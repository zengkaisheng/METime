//
//  MECustomerTypeCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MECustomerTypeCell : UITableViewCell

@property (nonatomic, copy) kMeBasicBlock deleteBlock;

- (void)setUIWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
