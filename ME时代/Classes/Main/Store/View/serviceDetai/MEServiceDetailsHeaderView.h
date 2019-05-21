//
//  MEServiceDetailsHeaderView.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodDetailModel;
@interface MEServiceDetailsHeaderView : UIView

- (void)setUIWithModel:(MEGoodDetailModel *)model;
+(CGFloat)getViewHeight;

@end
