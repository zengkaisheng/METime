//
//  MEShowGroupUserListView.h
//  志愿星
//
//  Created by gao lei on 2019/7/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEShowGroupUserListView : UIView

+ (void)showGroupUserListViewWithArray:(NSArray *)array selectedBlock:(kMeIndexBlock)selectedBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
