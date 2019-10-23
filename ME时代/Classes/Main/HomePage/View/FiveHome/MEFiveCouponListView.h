//
//  MEFiveCouponListView.h
//  ME时代
//
//  Created by gao lei on 2019/10/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEFiveCouponListView : UIView

@property (nonatomic, copy) kMeBasicBlock scrollBlock;

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type materialArray:(NSArray *)materialArray;

- (void)viewHideFooterView:(BOOL)isHide;

@end

NS_ASSUME_NONNULL_END
