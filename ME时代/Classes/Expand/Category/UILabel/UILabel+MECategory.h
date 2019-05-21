//
//  UILabel+MECategory.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MECategory)


- (void)setLineStrWithStr:(NSString *)str;
-(void)setAtsWithStr:(NSString *)str lineGap:(CGFloat)lineGap;
@property (nonatomic, assign) IBInspectable NSString *textColorHexString;

@end
