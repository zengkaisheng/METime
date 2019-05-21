//
//  UIImage+MEScale.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MEScale)

/**
 截取部分图像
 */
- (UIImage *)getSubImage:(CGRect)rect;

/**
 等比例缩放
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 *  非等比例压缩
 */
-(UIImage *)unProportionScaleToSize:(CGSize)size;

/**
 缩放到合适比例
 */
- (UIImage *)scaleToFit;

/**
 调整比例
 */
- (UIImage *)resizedInRect:(CGRect)thumbRect;


@end
