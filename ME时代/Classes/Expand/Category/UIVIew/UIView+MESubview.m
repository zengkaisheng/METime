//
//  UIView+MESubview.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "UIView+MESubview.h"

@implementation UIView (MESubview)

-(UIView *)subViewOfClass:(Class)aClass{
    UIView *aView = nil;
    NSMutableArray *views = [self.subviews mutableCopy];
    while (!aView && views.count>0) {
        UIView *temp = [views firstObject];
        if ([temp isKindOfClass:aClass]) {
            aView = temp;
        }else{
            [views addObjectsFromArray:temp.subviews];
            [views removeObject:temp];
        }
    }
    return aView;
}

-(UIView *)subViewOfContainDescription:(NSString *)aString{
    if(![aString isKindOfClass:[NSString class]]){
        NSLog(@"%s,%d,aString is Not String", __PRETTY_FUNCTION__, __LINE__);
        return nil;
    }
    UIView *aView = nil;
    NSMutableArray *views = [self.subviews mutableCopy];
    while (!aView && views.count>0) {
        UIView *temp = [views firstObject];
        if ([temp.description rangeOfString:aString].length>0) {
            aView = temp;
        }else{
            [views addObjectsFromArray:temp.subviews];
            [views removeObject:temp];
        }
    }
    return aView;
}


@end
