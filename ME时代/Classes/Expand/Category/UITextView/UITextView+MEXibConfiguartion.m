//
//  UITextView+MEXibConfiguartion.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "UITextView+MEXibConfiguartion.h"

@implementation UITextView (MEXibConfiguartion)

static char placeholderStringKey;


- (void)setPlaceholderString:(NSString *)placeholderString{
    objc_setAssociatedObject(self, &placeholderStringKey, placeholderString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)placeholderString{
    return objc_getAssociatedObject(self, &placeholderStringKey);
}

static char placeholderColorKey;

- (void)setPlaceholderColor:(UIColor *)placeholderString{
    objc_setAssociatedObject(self, &placeholderColorKey, placeholderString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, &placeholderColorKey);
}





@end
