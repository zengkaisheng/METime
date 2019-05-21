//
//  UIImage+MECompress.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MECompress)

/**
 * @description 按分辨率和质量压缩图片
 */
- (NSData *)dataByCompressToSize:(CGSize)size toQuality:(CGFloat)quality;

/**
 * @description 按分辨率和质量压缩图片
 */
- (UIImage *)imageByCompressToSize:(CGSize)size toQuality:(CGFloat)quality;

/**
 * @description 按分辨率比例和质量压缩图片
 */
- (NSData *)dataByCompressToScale:(CGFloat)scale toQuality:(CGFloat)quality;

/**
 * @description 按分辨率比例和质量压缩图片
 */
- (UIImage *)imageByCompressToScale:(CGFloat)scale toQuality:(CGFloat)quality;

/**
 *  修正照片位置
 */
- (UIImage *)fixOrientation:(UIImage *)aImage;


@end
