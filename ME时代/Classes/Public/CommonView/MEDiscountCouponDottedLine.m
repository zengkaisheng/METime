//
//  MEDiscountCouponDottedLine.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEDiscountCouponDottedLine.h"

@implementation MEDiscountCouponDottedLine

#pragma mark - Initial Methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.whiteColor;
        [self drawDottedLine];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = UIColor.whiteColor;
        [self drawDottedLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawDottedLine];
}

#pragma mark - Private

-(void)drawDottedLine{
    
    CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
    //设置虚线颜色为blackColor
    [dotteShapeLayer setStrokeColor:kMEHexColor(@"e3e3e3").CGColor];
    //设置虚线宽度
    dotteShapeLayer.lineWidth = 1.0f ;
    //10=线的宽度 5=每条线的间距
    NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:4],[NSNumber numberWithInt:2], nil];
    [dotteShapeLayer setLineDashPattern:dotteShapeArr];
    CGPathMoveToPoint(dotteShapePath, NULL, 0 ,0);
    CGPathAddLineToPoint(dotteShapePath, NULL, self.width, 0);
    [dotteShapeLayer setPath:dotteShapePath];
    CGPathRelease(dotteShapePath);
    //把绘制好的虚线添加上来
//    [self.layer removeAllSublayers];
    [self.layer addSublayer:dotteShapeLayer];
}


@end

