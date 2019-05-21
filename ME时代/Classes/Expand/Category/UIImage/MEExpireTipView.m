//
//  MEExpireTipView.m
//  ME时代
//
//  Created by hank on 2018/10/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEExpireTipView.h"

@interface MEExpireTipView ()

@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UIView *viewTip;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation MEExpireTipView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSomeThing];
}

- (void)initSomeThing{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_bgView addGestureRecognizer:tap];
}

- (void)setUIWithModel:(id)model{
    _lblTip.text = @"您的小程序还有7天到期";
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self endEditing:YES];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self hide];
}

- (void)show{
    [kMeCurrentWindow addSubview:self];
    _viewTip.alpha = 0.5;
    kMeWEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        kMeSTRONGSELF
        strongSelf->_viewTip.alpha = 1;
    }];
}

- (void)hide{
    [self removeFromSuperview];
}



@end
