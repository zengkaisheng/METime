//
//  UIView+MESubview.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MESubview)

/**
 *  根据class获取view的subview
 */
-(UIView *)subViewOfClass:(Class)aClass;

/**
 *  根据类名获取view的subview
 */
-(UIView *)subViewOfContainDescription:(NSString *)aString;

@end
