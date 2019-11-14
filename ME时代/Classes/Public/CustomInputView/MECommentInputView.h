//
//  MECommentInputView.h
//  ME时代
//
//  Created by gao lei on 2019/11/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECommentInputView : UIView

@property (nonatomic, strong) METextView *textView;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;  //取消了输入
@property (nonatomic, copy) kMeTextBlock contentBlock;

@end

NS_ASSUME_NONNULL_END
