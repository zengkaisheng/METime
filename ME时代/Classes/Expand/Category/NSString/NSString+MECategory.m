//
//  NSString+MECategory.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "NSString+MECategory.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@implementation NSString (MECategory)

+ (CGFloat)advisorCreditsWithName:(NSString *)credits{
    if([credits integerValue] <= 499){
        return 0;
        
    }else if(([credits integerValue] > 499) && ([credits integerValue]<= 2999)){
        
        return 1;
        
    }else if(([credits integerValue] > 2999) && ([credits integerValue] <= 9999)){
        
        return 2;
        
    }else if(([credits integerValue] > 9999) && ([credits integerValue] <= 29999)){
        
        return 3;
        
    }else if(([credits integerValue] > 29999) && ([credits integerValue] <= 99999)){
        
        return 4;
        
    }else{
        return 5;
    }
}

+ (CGFloat)userCreditsWithName:(NSString *)credits{
    if([credits integerValue] <= 199){
        return 1;
        
    }else if(([credits integerValue] > 199) && ([credits integerValue] <= 499)){
        
        return 2;
        
    }else if(([credits integerValue] > 499) && ([credits integerValue] <= 999)){
        
        return 3;
        
    }else if(([credits integerValue] > 999) && ([credits integerValue] <= 1999)){
        
        return 4;
        
    }else if(([credits integerValue] > 1999) && ([credits integerValue] <= 4999)){
        
        return 5;
        
    }else if(([credits integerValue] > 4999) && ([credits integerValue] <= 9999)){
        
        return 6;
        
    }else if(([credits integerValue] > 9999) && ([credits integerValue] <= 19999)){
        
        return 7;
        
    }else if(([credits integerValue] > 19999) && ([credits integerValue] <= 49999)){
        
        return 8;
        
    }else if(([credits integerValue] > 49999) && ([credits integerValue] <= 99999)){
        
        return 9;
        
    }else if(([credits integerValue] > 99999) && ([credits integerValue] <= 199999)){
        
        return 10;
        
    }else if(([credits integerValue] > 199999) && ([credits integerValue] <= 499999)){
        
        return 11;
        
    }else if(([credits integerValue] > 499999) && ([credits integerValue] <= 999999)){
        
        return 12;
        
    }else{
        
        return 13;
    }
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (NSMutableAttributedString *)attributeWithRangeOfString:(NSString *)aString color:(UIColor *)color{
    NSRange range = [self rangeOfString:aString options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self];
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attribute;
}

- (NSString *)trimSpace{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}

@end
