//
//  MECustomerContentCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MECustomerContentCell : UITableViewCell

- (void)setUIWithArray:(NSArray *)array;
+ (CGFloat)getCellHeightWithArray:(NSArray *)array;


@property (nonatomic, copy) kMeBasicBlock tapBlock;

- (void)setUIWithInfo:(NSDictionary *)info isAdd:(BOOL)isAdd isEdit:(BOOL)isEdit;
+ (CGFloat)getCellHeightWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
