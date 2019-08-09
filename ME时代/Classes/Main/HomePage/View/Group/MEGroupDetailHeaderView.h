//
//  MEGroupDetailHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/7/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEGoodDetailModel;

@interface MEGroupDetailHeaderView : UIView

- (void)setUIWithModel:(MEGoodDetailModel *)model;
+ (CGFloat)getHeightWithModel:(MEGoodDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
