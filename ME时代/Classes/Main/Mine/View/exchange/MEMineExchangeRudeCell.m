//
//  MEMineExchangeRudeCell.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineExchangeRudeCell.h"

#define kFontOfTitle [UIFont systemFontOfSize:12]
#define kMEMineExchangeRudeCellRLMargin (15)
#define kMEMineExchangeRudeCellTBMargin (20)
#define kWidthOflblContent (SCREEN_WIDTH - (kMEMineExchangeRudeCellRLMargin*2))


@interface MEMineExchangeRudeCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation MEMineExchangeRudeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setUIWithModel:(id)model{
    _lblTitle.text = model;
    _consTitleHeight.constant = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(model) font:kFontOfTitle width:kWidthOflblContent lineH:1 maxLine:0];
    [_lblTitle setAtsWithStr:kMeUnNilStr(model) lineGap:0];
}

+ (CGFloat)getCellHeight:(NSString *)title{
    CGFloat height = kMEMineExchangeRudeCellTBMargin;
    height += [NSAttributedString heightForAtsWithStr:kMeUnNilStr(title) font:kFontOfTitle width:kWidthOflblContent lineH:1 maxLine:0];
    return height;
}

@end
