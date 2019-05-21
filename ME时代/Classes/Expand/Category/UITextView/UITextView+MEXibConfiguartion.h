//
//  UITextView+MEXibConfiguartion.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (MEXibConfiguartion)

//默认字体颜色
@property (nonatomic, assign) IBInspectable UIColor *placeholderColor;
//默认String
@property (nonatomic, assign) IBInspectable NSString *placeholderString;

@end
