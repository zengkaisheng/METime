//
//  UIImage+MEExtension.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MEExtension)

/**
 截屏
 */
+ (instancetype)captureWithView:(UIView *)view;

/**
 返回Assets一张可以随意拉伸不变形的图片 0.5 0.5
 */
+ (UIImage *)resizableImage:(NSString *)name;

/**
 返回Assets一张可以随意拉伸不变形的图片 left top
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
//截屏
+ (UIImage *)imageWithView:(UIView *)view frame:(CGRect)frame;
//url转二维码
+(UIImage *)getCodeWithUrl:(NSString *)url;
//根据url拿到data
+(UIImage *)getDataWithUrl:(NSString *)url;
@end
