//
//  UIView+MECommon.m
//  ME时代
//
//  Created by Hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "UIView+MECommon.h"

@implementation UIView (MECommon)

-(void)addBottedlineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor{
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, self.width , self.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
    borderLayer.lineWidth = lineWidth;
    //虚线边框
    borderLayer.lineDashPattern = @[@8, @8];
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    [self.layer addSublayer:borderLayer];
}

-(void)addRecBottedlineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor{
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, self.width , self.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
       CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
    CGPathAddLineToPoint(path, NULL, 0, 0);
    borderLayer.path =  path;
//    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
    borderLayer.lineWidth = lineWidth;
    //虚线边框
    borderLayer.lineDashPattern = @[@1, @1];
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    [self.layer addSublayer:borderLayer];
}


@end
