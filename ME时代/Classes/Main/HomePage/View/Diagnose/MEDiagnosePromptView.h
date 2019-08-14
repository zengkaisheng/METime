//
//  MEDiagnosePromptView.h
//  ME时代
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEDiagnosePromptView : UIView

+ (void)showDiagnosePromptViewWithSuccessBlock:(kMeBasicBlock)successBlock superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
