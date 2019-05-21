//
//  UIView+MEXibConfiguration.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MEXibConfiguration)

/**
 *  圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 *  描边宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 *  描边颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/**
 *  背景颜色
 */
@property (nonatomic, assign) IBInspectable NSString *bgColorHexString;
/**
 *  描边颜色-16进制
 */
@property (nonatomic, assign) IBInspectable NSString *borderColorHexString;

@end
