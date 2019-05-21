//
//  MEEnlargeTouchButton.m
//  ME时代
//
//  Created by hank on 2018/10/22.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEEnlargeTouchButton.h"

@implementation MEEnlargeTouchButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = 44.0 - bounds.size.width;
    CGFloat heightDelta = 44.0 - bounds.size.height;
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
