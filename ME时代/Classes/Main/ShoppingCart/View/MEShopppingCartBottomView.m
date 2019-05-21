//
//  MEShopppingCartBottomView.m
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShopppingCartBottomView.h"

@interface MEShopppingCartBottomView(){
    
}

@end

@implementation MEShopppingCartBottomView
- (IBAction)delClickBtn:(UIButton *)sender {
    kMeCallBlock(self.DelBlock);
}

- (IBAction)allClickBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"inc-gg"] forState:(UIControlStateNormal)];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_xuanzhe01"] forState:(UIControlStateNormal)];
    }
    kMeCallBlock(self.AllClickBlock,sender.selected);
}

- (IBAction)accountBtn:(UIButton *)sender {
    kMeCallBlock(self.AccountBlock);
}

- (void)setIsClick:(BOOL)isClick {
    _isClick = isClick;
    self.clickBtn.selected = isClick;
    if (isClick) {
        [self.clickBtn setImage:[UIImage imageNamed:@"inc-gg"] forState:(UIControlStateNormal)];
    } else {
        [self.clickBtn setImage:[UIImage imageNamed:@"icon_xuanzhe01"] forState:(UIControlStateNormal)];
    }
}

- (void)clearData{
    self.clickBtn.selected = NO;
    [self setIsClick:NO];
    self.allPriceLabel.text = @"合计¥0.00";
}

@end
