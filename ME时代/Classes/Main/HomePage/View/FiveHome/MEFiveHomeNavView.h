//
//  MEFiveHomeNavView.h
//  志愿星
//
//  Created by gao lei on 2019/10/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEFiveHomeNavViewHeight (((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 90 : 68))

@interface MEFiveHomeNavView : UIView

- (void)setRead:(BOOL)read;

@property (nonatomic ,copy) kMeBasicBlock searchBlock;

@end

NS_ASSUME_NONNULL_END
