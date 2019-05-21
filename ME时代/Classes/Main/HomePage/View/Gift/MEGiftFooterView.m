//
//  MEGiftFooterView.m
//  ME时代
//
//  Created by hank on 2018/12/19.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGiftFooterView.h"
#import "MEBlockTextField.h"

@interface MEGiftFooterView(){
    kMeTextBlock _contentBlock;
}

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfSay;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnGift;

@end

@implementation MEGiftFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_btnGift addTarget:self action:@selector(toa:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUIWithModel:(NSString *)allPrice say:(NSString*)say contentBlock:(kMeTextBlock)contentBlock{
    _contentBlock = contentBlock;
    _tfSay.text = kMeUnNilStr(say);
    kMeWEAKSELF
    _tfSay.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf->_contentBlock,str);
    };
    _lblPrice.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(allPrice)];
}

- (void)toa:(UIButton *)btn{
    kMeCallBlock(_toAcount);
}

@end
