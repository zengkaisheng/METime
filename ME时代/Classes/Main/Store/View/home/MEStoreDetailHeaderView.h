//
//  MEStoreDetailHeaderView.h
//  ME时代
//
//  Created by hank on 2018/10/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEStoreDetailModel;
#define kMEStoreDetailHeaderViewHeight  (147 + (220 * kMeFrameScaleX()))

@interface MEStoreDetailHeaderView : UIView

- (void)setUIWithModel:(MEStoreDetailModel *)model;
+ (CGFloat)getViewHeight:(MEStoreDetailModel *)model;
@end
