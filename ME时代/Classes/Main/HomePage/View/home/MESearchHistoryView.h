//
//  MESearchHistoryView.h
//  ME时代
//
//  Created by hank on 2018/10/31.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MESearchHistoryView : UIView

+ (BOOL)hasHIstory;
- (void)reloadData;
+ (CGFloat)getViewHeight;
@property (nonatomic, copy) kMeTextBlock selectBlock;
@property (nonatomic, copy) kMeBasicBlock delBlock;

+ (BOOL)hasHStoreIstory;
- (void)reloaStoredData;
+ (CGFloat)getStoreViewHeight;

@end
