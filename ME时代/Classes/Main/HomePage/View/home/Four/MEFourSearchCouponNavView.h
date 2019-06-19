//
//  MEFourSearchCouponNavView.h
//  ME时代
//
//  Created by gao lei on 2019/6/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MEFourSearchCouponNavView : UIView

@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UITextField *searchTF;
@property (nonatomic ,copy) kMeBasicBlock backBlock;
@property (nonatomic ,copy) kMeTextBlock searchBlock;

@end

NS_ASSUME_NONNULL_END
