//
//  MEFlowLabelView.h
//  ME时代
//
//  Created by hank on 2019/1/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEFlowLabelView : UIView

+ (CGFloat)getMEFlowLabelViewHeightWithArr:(NSArray *)arr;
- (void)reloaWithArr:(NSArray *)arr;

//宽度
@property (nonatomic, assign) CGFloat flowLabelViewWdith;
//高度
@property (nonatomic, assign) CGFloat  flowLabelViewLabelHeight ;
//@property (nonatomic, assign) CGFloat  flowLabelViewLabelMargin ;
//@property (nonatomic, assign) CGFloat  flowLabelViewLabelPadding ;

+ (CGFloat)getCustomMEFlowLabelViewHeightWithArr:(NSArray *)arr wdith:(CGFloat)wdith LabelViewLabelHeight:(CGFloat)LabelViewLabelHeight font:(UIFont *)font;
- (void)reloaCustomWithArr:(NSArray *)arr font:(UIFont *)font textColor:(UIColor *)textColor backGroundColor:(UIColor *)backGroundColor;

@end

NS_ASSUME_NONNULL_END
