//
//  METhridProductDetailsTipCell.m
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridProductDetailsTipCell.h"

@interface METhridProductDetailsTipCell ()


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleHeight;


@end

@implementation METhridProductDetailsTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUiWithStr:(NSString *)str{
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(str) font:[UIFont systemFontOfSize:13] width:(SCREEN_WIDTH - 58) lineH:0 maxLine:0];
    _consTitleHeight.constant = titleHeight>16?titleHeight:16;
    [_lblTitle setAtsWithStr:kMeUnNilStr(str) lineGap:0];
    _consTitleHeight.constant = titleHeight;
}

+ (CGFloat)getCellHeightWithStr:(NSString *)str{
    CGFloat height = 44-16;
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(str) font:[UIFont systemFontOfSize:13] width:(SCREEN_WIDTH - 58) lineH:0 maxLine:0];
    height += titleHeight>16?titleHeight:16;
    return height;
}

@end
