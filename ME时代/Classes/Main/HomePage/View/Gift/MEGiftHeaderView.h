//
//  MEGiftHeaderView.h
//  志愿星
//
//  Created by hank on 2018/12/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMEGiftHeaderViewHeight (307 )

@interface MEGiftHeaderView : UITableViewHeaderFooterView

+ (CGFloat)getViewHeight;
- (void)setUiWithModel:(NSArray*)model;

@end
