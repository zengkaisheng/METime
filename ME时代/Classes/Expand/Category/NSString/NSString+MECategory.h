//
//  NSString+MECategory.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MECategory)

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
+ (CGFloat)advisorCreditsWithName:(NSString *)credits;
+ (CGFloat)userCreditsWithName:(NSString *)credits;


- (NSMutableAttributedString *)attributeWithRangeOfString:(NSString *)aString color:(UIColor *)color;

- (NSString *)trimSpace;

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font;
@end
