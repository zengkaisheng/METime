//
//  ViewPagerTitleButton.m
//  rbylClient
//
//  Created by Farben on 2018/7/19.
//  Copyright © 2018年 vanke. All rights reserved.
//

#import "ViewPagerTitleButton.h"

@implementation ViewPagerTitleButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:12.0]];
        [self setTitleColor:kME333333 forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#FFA8A8"] forState:UIControlStateSelected];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    if (self.selected) {
        CGFloat lineWidth = 2.5;
        CGColorRef color = [UIColor colorWithHexString:@"#FFA8A8"].CGColor;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextSetLineWidth(ctx, lineWidth);
        CGFloat pointA = self.width != 0 ? (self.frame.size.width - self.width) / 2 : self.frame.size.width / 4;
        CGFloat pointB = self.width != 0 ? pointA + self.width : self.frame.size.width / 4 * 3;
        CGContextMoveToPoint(ctx, pointA, self.frame.size.height-lineWidth);
        CGContextAddLineToPoint(ctx, pointB, self.frame.size.height-lineWidth);
        CGContextStrokePath(ctx);
    }
}

@end
