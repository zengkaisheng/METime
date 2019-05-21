//
//  MEBankTransferAccountsCell.m
//  ME时代
//
//  Created by hank on 2018/10/9.
//  Copyright © 2018年 hank. All rights reserved.
//

#define kFontOfTitle [UIFont systemFontOfSize:12]
const static CGFloat kMargin = 14.0f;
#define kWidthOflblContent (SCREEN_WIDTH - (kMargin*2))

#import "MEBankTransferAccountsCell.h"

@interface MEBankTransferAccountsCell (){
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consOneHeightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTwoHeightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consThreeHeightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consFourHeightMargin;
@property (weak, nonatomic) IBOutlet UIButton *btnCount;

@property (weak, nonatomic) IBOutlet UIView *viewForBank;
@property (weak, nonatomic) IBOutlet UIView *viewForCN;
@property (weak, nonatomic) IBOutlet UIView *viewForBC;

@property (weak, nonatomic) IBOutlet UILabel *lblBank;
@property (weak, nonatomic) IBOutlet UILabel *lblCN;
@property (weak, nonatomic) IBOutlet UILabel *lblBC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBgHeightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;

@end

@implementation MEBankTransferAccountsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _lblBank.adjustsFontSizeToFitWidth = YES;
    _lblCN.adjustsFontSizeToFitWidth = YES;
    _lblBC.adjustsFontSizeToFitWidth = YES;
    
    [self setCornerRadiusWithView:_viewForBank];
    [self setCornerRadiusWithView:_viewForCN];
    [self setCornerRadiusWithView:_viewForBC];
    _btnCount.layer.cornerRadius=8;
    _btnCount.layer.masksToBounds = YES;
    
    CGFloat one =  [NSAttributedString heightForAtsWithStr:@"1.转账时请备注姓名、手机号信息、以便核账" font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
    _consOneHeightMargin.constant = one>21?one:21;
    CGFloat two =  [NSAttributedString heightForAtsWithStr:@"2.转账后，请点击下方“我已转账”按钮，提交核账申请" font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
    _consTwoHeightMargin.constant=two>21?two:21;
    
    CGFloat three =  [NSAttributedString heightForAtsWithStr:@"3.平台客服在收到核账申请后核对转账款项，可能会与你电话确认，请保持电话畅通" font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
    _consThreeHeightMargin.constant=three>21?three:21;
    
    CGFloat four =  [NSAttributedString heightForAtsWithStr:@"4.核账确认后，将发送短信告知你,并且在我的订单中,改为待发货状态" font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
    _consFourHeightMargin.constant=four>21?four:21;
    _consBgHeightMargin.constant = (SCREEN_WIDTH * 270)/371;
    _consTopMargin.constant = kMeFrameScaleY()<1?7:28;
    [self layoutIfNeeded];
    // Initialization code
}

- (void)setCornerRadiusWithView:(UIView*)view{
    view.layer.cornerRadius = 20;
    view.layer.masksToBounds = YES;
}

- (IBAction)copyBankNameAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"平安银行深圳高新技术区支行  ";
    MBProgressHUD *hub =  [MBProgressHUD showHUDAddedTo:self animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.detailsLabel.text = @"已复制开户行";
    [hub hideAnimated:YES afterDelay:0.3];
    
}

- (IBAction)copyCompanyNameAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"深圳蜜时代网络科技有限公司";
    MBProgressHUD *hub =  [MBProgressHUD showHUDAddedTo:self animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.detailsLabel.text = @"已复制开户名";
    [hub hideAnimated:YES afterDelay:0.3];
}

- (IBAction)copyBankCountAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"15000094714578";
    MBProgressHUD *hub =  [MBProgressHUD showHUDAddedTo:self animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.detailsLabel.text = @"已复制银行卡号";
    [hub hideAnimated:YES afterDelay:0.3];
}

- (IBAction)transferAccountsAction:(UIButton *)sender {
    kMeCallBlock(_tfAcoountBlock);
}

+ (CGFloat)getCellHeigh{
    CGFloat height = kZLBankTransferAccountsCellHeight - 258.5;
    height+=(SCREEN_WIDTH * 270)/371;
    height -= (21*4);
    CGFloat one =  [NSAttributedString heightForAtsWithStr:@"1.转账时请备注姓名、手机号信息、以便核账" font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
    height +=one>21?one:21;
    
    CGFloat two =  [NSAttributedString heightForAtsWithStr:@"2.转账后，请点击下方“我已转账”按钮，提交核账申请" font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
    height +=two>21?two:21;
    
    CGFloat three =  [NSAttributedString heightForAtsWithStr:@"3.平台客服在收到核账申请后核对转账款项，可能会与你电话确认，请保持电话畅通" font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
    height +=three>21?three:21;
    
    CGFloat four =  [NSAttributedString heightForAtsWithStr:@"4.核账确认后，将发送短信告知你,并且在我的订单中,改为待发货状态" font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
    height +=four>21?four:21;
    
    return height;
}

@end
