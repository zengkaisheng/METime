//
//  METextView.h
//  志愿星
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface METextView : UIView
/**  */
@property (nonatomic, strong, nullable) UITextView  *textView;

/** 占位*/
@property (nonatomic, strong, nullable) UITextView  *placeholderTextView;

+ (instancetype )placeholderTextView;
@property (nonatomic, copy) kMeTextBlock contenBlock;
@property (nonatomic, copy) kMeBasicBlock cancelBlock; //取消l输入状态
@property (nonatomic, copy) kMeTextBlock doneBlock;    //完成输入后

@end

NS_ASSUME_NONNULL_END
