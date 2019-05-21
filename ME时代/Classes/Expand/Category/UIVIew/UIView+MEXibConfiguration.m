//
//  UIView+MEXibConfiguration.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "UIView+MEXibConfiguration.h"
#import "UIColor+MEHexString.h"
#import <objc/runtime.h>

@implementation UIView (MEXibConfiguration)

#pragma mark - IBInspectable

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    if (cornerRadius > 0) {
        self.layer.masksToBounds = YES;
    }
}

- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

static char bgColorHexStringKey;

-(void)setBgColorHexString:(NSString *)bgColorHexString{
    self.backgroundColor = [UIColor colorWithHexString:bgColorHexString];
    objc_setAssociatedObject(self, &bgColorHexStringKey, bgColorHexString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)bgColorHexString{
    return objc_getAssociatedObject(self, &bgColorHexStringKey);
}

static char borderColorHexStringKey;

-(void)setBorderColorHexString:(NSString *)borderColorHexString{
    self.layer.borderColor = [UIColor colorWithHexString:borderColorHexString].CGColor;
    objc_setAssociatedObject(self, &borderColorHexStringKey, borderColorHexString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)borderColorHexString{
    return objc_getAssociatedObject(self, &borderColorHexStringKey);
}


@end
