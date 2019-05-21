//
//  MEBaseButton.m
//  ME时代
//
//  Created by hank on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation MEBaseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setNormalBgColor:(UIColor *)normal selectBgColor:(UIColor *)select{
    self.backgroundColor = normal;
    color_normal = normal;
    color_select = select;
}

-(void)setNormalBorderColor:(UIColor *)normal selectBorderColor:(UIColor *)select{
    border_color_normal = normal;
    border_color_select = select;
    self.layer.borderColor = [border_color_normal CGColor];
    self.layer.borderWidth = 1;
}

-(void)setNormalBgColor:(UIColor *)normal hightlightBgColor:(UIColor *)highlighted{
    self.backgroundColor = normal;
    bgcolor_normal = normal;
    bgcolor_highlighted = highlighted;
}

-(void)setNormalBgColor:(UIColor *)normal selectBgColor:(UIColor *)select hightlightBgColor:(UIColor *)highlighted{
    self.backgroundColor = normal;
    bgcolor_normal = normal;
    bgcolor_highlighted = highlighted;
    color_select = select;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (color_normal && !selected) {
        [self setBackgroundColor:color_normal];
    }
    if (color_select && selected) {
        [self setBackgroundColor:color_select];
    }
    if (border_color_normal && !selected) {
        self.layer.borderColor = [border_color_normal CGColor];
        self.layer.borderWidth = 1;
    }
    if (border_color_select && selected) {
        self.layer.borderColor = [border_color_select CGColor];
        self.layer.borderWidth = 1;
    }
    
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];

    if (bgcolor_normal && !highlighted && self.state == UIControlStateNormal) {
        [self setBackgroundColor:bgcolor_normal];
    }
    
    if (bgcolor_highlighted && highlighted) {
        [self setBackgroundColor:bgcolor_highlighted];
    }
}

-(void)setBtnBorder:(int)orientation Thickness:(CGFloat)lineThickness color:(UIColor *)lineColor
{
    //orientation依次为上，右，下，左
    CGRect rect;
    switch (orientation) {
        case 0:
            rect.size.width = self.size.width;
            rect.size.height = lineThickness;
            rect.origin.x = 0;
            rect.origin.y = 0;
            break;
        case 1:
            rect.size.width = lineThickness;
            rect.size.height = self.size.height;
            rect.origin.x = self.size.width;
            rect.origin.y = 0;
            break;
        case 2:
            rect.size.width = self.size.width;
            rect.size.height = lineThickness;
            rect.origin.x = 0;
            rect.origin.y = self.size.height;
            break;
        case 3:
            rect.size.width = lineThickness;
            rect.size.height = self.size.height;
            rect.origin.x = 0;
            rect.origin.y = 0;
            break;
        default:{
            
        }
            break;
    }
    UIView *line = [[UIView alloc] initWithFrame:rect];
    line.backgroundColor = lineColor;
    [self addSubview:line];
}

#pragma mark -


+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img{
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setImage:img forState:UIControlStateNormal];
    return btn;
}

+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title line:(NSInteger)ln{
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    if(img) [btn setBackgroundImage:img forState:UIControlStateNormal];
    btn.titleLabel.numberOfLines = ln;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:(19-title.length)];
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}


+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title{
    return [self btnWithFrame:rect Img:img title:title line:1];
}

+(MEBaseButton *)btnWithFrame:(CGRect)rect Img:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act{
    MEBaseButton *btn = [self btnWithFrame:rect Img:img title:title];
    [btn addTarget:target action:act forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(MEBaseButton *)greenBtnWithFrame:(CGRect)rect title:(NSString *)title target:(id)target Action:(SEL)act{
    MEBaseButton *btn = [self btnWithFrame:rect Img:nil title:title target:target Action:act];
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    return btn;
}

+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act{
    return [self btnWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) Img:img title:title target:target Action:act];
}

+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act center:(CGPoint)ct{
    MEBaseButton *btn = [self btnWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) Img:img title:title target:target Action:act];
    btn.center = ct;
    return btn;
}

+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act titleColor:(UIColor *)color{
    MEBaseButton *btn = [self btnWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) Img:img title:title target:target Action:act];
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}

+(MEBaseButton *)btnWithImg:(UIImage *)img title:(NSString *)title target:(id)target Action:(SEL)act center:(CGPoint)ct titleColor:(UIColor *)color{
    MEBaseButton *btn = [self btnWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) Img:img title:title target:target Action:act];
    btn.center = ct;
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}

+(MEBaseButton *)btnWithFrame:(CGRect)rect Title:(NSString *)title titleFont:(UIFont *)ft aboveImg:(UIImage *)img imgCenter:(CGPoint)ct_img target:(id)target Action:(SEL)act{
    MEBaseButton *btn = [self btnWithFrame:rect Img:nil title:title target:target Action:act];
    btn.titleLabel.font = ft;
    UIImageView *imgv = [[UIImageView alloc]initWithImage:img];
    [btn addSubview:imgv];
    imgv.center = ct_img;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, img.size.width, 0, 0)];//2+10
    return btn;
}

+(MEBaseButton *)btnWithTitle:(NSString *)title titleFont:(UIFont *)ft aboveImg:(UIImage *)img target:(id)target Action:(SEL)act{
    MEBaseButton *btn = [self btnWithFrame:CGRectMake(0, 0, img.size.width+[title sizeWithFont:ft].width+20, img.size.height) Title:title titleFont:ft aboveImg:img imgCenter:CGPointMake(img.size.width/2, img.size.height/2) target:target Action:act];
    return btn;

}

+(MEBaseButton *)btnWithTitle:(NSString *)title aboveImg:(UIImage *)img target:(id)target Action:(SEL)act{
    
    return [self btnWithTitle:title titleFont:[UIFont boldSystemFontOfSize:18] aboveImg:img target:target Action:act];
}

@end
