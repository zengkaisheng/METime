//
//  MEHomePageHeaderView.h
//  ME时代
//
//  Created by hank on 2018/9/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEHomeHeaderMenuView.h"
#import "MEHomeSearchView.h"

#define kMEHomePageHeaderViewHeight (255*kMeFrameScaleY() + 48 + kMEHomeHeaderMenuViewHeight + kMEHomeSearchViewHeight)

@interface MEHomePageHeaderView : UIView

- (void)setArrModel:(NSArray *)arrModel;
@property (nonatomic, copy) kMeBasicBlock searchBlock;
@property (nonatomic, copy) kMeBasicBlock filetBlock;

@end
