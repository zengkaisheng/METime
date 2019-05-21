//
//  UILabel+MECategory.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "UILabel+MECategory.h"
#import <objc/runtime.h>
#import "UIView+MEFrame.h"
#import "UIColor+MEHexString.h"

@implementation UILabel (MECategory)

- (void)setAtsWithStr:(NSString *)str lineGap:(CGFloat)lineGap{
    if (![str isKindOfClass:[NSString class]] || str.length < 1) {
        return ;
    }
    CGFloat h = (self.height<self.font.pointSize*2+lineGap)?0:lineGap;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [paragraphStyle setLineSpacing:h];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    self.attributedText = attributedString;
}


- (void)setLineStrWithStr:(NSString *)str{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
    // 赋值
    self.attributedText = attribtStr;
}


static char textColorHexStringKey;

-(void)setTextColorHexString:(NSString *)textColorHexString{
    self.textColor = [UIColor colorWithHexString:textColorHexString];
    objc_setAssociatedObject(self, &textColorHexStringKey, textColorHexString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)textColorHexString{
    return objc_getAssociatedObject(self, &textColorHexStringKey);
}


@end
