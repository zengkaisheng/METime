//
//  NSMutableAttributedString+MESize.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (MESize)

/**
 * 设置行间距
 */
+(NSMutableAttributedString *)atsForStr:(NSString *)str lineHeight:(CGFloat)h;

/**
 * 设置行间距 是否用于计算
 */
+(NSMutableAttributedString *)atsForStr:(NSString *)str lineHeight:(CGFloat)h forCompute:(BOOL)forCompute;

@end
