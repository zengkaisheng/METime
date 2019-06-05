//
//  MENewAddTelView.m
//  ME时代
//
//  Created by gao lei on 2019/6/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewAddTelView.h"
#import "METickTimerTool.h"
#import "MEFillInvationCodeVC.h"

#define kMENewAddTelViewHeight (294*kMeFrameScaleY())
#define kMENewAddTelViewWidth (275*kMeFrameScaleX())

@interface MENewAddTelView ()<UITextFieldDelegate>{
    METickTimerTool *_timer;
    NSString *_strCaptcha;
}

@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *headerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *invationLbl;
@property (weak, nonatomic) IBOutlet UITextField *tfNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfCaptcha;
@property (weak, nonatomic) IBOutlet UIButton *btnCaptcha;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *viewPhone;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewX;


@end

@implementation MENewAddTelView

- (void)awakeFromNib {
    [super awakeFromNib];
    _consViewHeight.constant = kMENewAddTelViewHeight;
    _consViewWidth.constant = kMENewAddTelViewWidth;
    _consViewX.constant = kMeFrameScaleY()<1?-40:0;
    [self layoutIfNeeded];
    [self initSomeThing];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.bgView addGestureRecognizer:tap];
}

- (void)initSomeThing{
    [_btnCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_tfCaptcha addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tfCaptcha addTarget:self action:@selector(tfVerficationTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    _tfNumber.delegate = self;
    _tfCaptcha.delegate = self;
    [self.headerNameLbl setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:15]];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//    [_bgView addGestureRecognizer:tap];
//    [self addGestureRecognizer:tap];
    if (kMeUnObjectIsEmpty(kCurrentUser.parent_header)) {
        _headerImgV.image = [UIImage imageNamed:@"icon-wgvilogo"];
        self.headerNameLbl.text = @"ME时代优选";
        self.invationLbl.hidden = YES;
    }else {
        kSDLoadImg(_headerImgV, kMeUnNilStr(kCurrentUser.parent_header.parent_header_pic));
        self.headerNameLbl.text = kMeUnNilStr(kCurrentUser.parent_header.parent_name);
        self.invationLbl.hidden = NO;
    }
}

- (void)tapAction {
    [self endEditing:YES];
}

#pragma mark - UITextField Action
- (void)tfCodeTextDidChange:(UITextField *)textField{
    if(textField.text.length > kLimitVerficationNum){
        textField.text = [textField.text substringWithRange:NSMakeRange(0,kLimitVerficationNum + 1)];
    }
    _strCaptcha = textField.text;
}

- (void)tfVerficationTextDidChange:(UITextField *)textField{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger strLength = textField.text.length - range.length + string.length;
    if (textField == self.tfNumber) {
        return (strLength <= 11);
    }
    return (strLength <= 6);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

-(void)timerTick{
    kMeWEAKSELF
    if (!_timer) {
        _timer = [[METickTimerTool alloc] init];
    }
    self.btnCaptcha.enabled = NO;
    [_timer tickTime:kValidTime tickBlock:^(NSTimeInterval tick) {
        kMeSTRONGSELF
        NSString *title = [NSString stringWithFormat:@"%.0fs",tick];
        [strongSelf.btnCaptcha setTitle:title forState:strongSelf.btnCaptcha.state];
    } finishBlock:^{
        kMeSTRONGSELF
        strongSelf.btnCaptcha.enabled = YES;
        [strongSelf.btnCaptcha setTitle:@"获取验证码" forState:strongSelf.btnCaptcha.state];
    }];
}

- (void)show{
    [kMeCurrentWindow addSubview:self];
    _viewPhone.alpha = 0.5;
    kMeWEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        kMeSTRONGSELF
        strongSelf->_viewPhone.alpha = 1;
    }];
}

- (void)hide {
    [self hideWithBlock:nil isSucess:true];
}

- (void)hideWithBlock:(kMeBOOLBlock)block isSucess:(BOOL)isSucess{
    [self removeFromSuperview];
    kMeCallBlock(block,isSucess);
}
- (IBAction)btnCaptchaAction:(id)sender {
    if(![MECommonTool isValidPhoneNum:kMeUnNilStr(_tfNumber.text)]){
        [MEShowViewTool showMessage:@"手机格式不对" view:self];
        _tfNumber.text = @"";
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCodeWithrPhone:kMeUnNilStr(_tfNumber.text) type:@"2" successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf timerTick];
    } failure:^(id object) {

    }];
}

- (IBAction)messageErrorAction:(id)sender {
    [MEFillInvationCodeVC presentFillInvationCodeVCWithPhone:kMeUnNilStr(_tfNumber.text) captcha:kMeUnNilStr(_tfCaptcha.text) Code:@"" SuccessHandler:^(id object) {
        [self hideWithBlock:self.finishBlock isSucess:true];
    } failHandler:^(id object) {
        
    }];
}
- (IBAction)messageRightAction:(id)sender {
    kMeWEAKSELF
    [MEPublicNetWorkTool postaddPhoneWithPhone:kMeUnNilStr(_tfNumber.text) code:kMeUnNilStr(_tfCaptcha.text) invate:@"" successBlock:^(ZLRequestResponse *responseObject) {
        //绑定手机号成功 保存到本地
        kMeSTRONGSELF
        kCurrentUser.mobile = kMeUnNilStr(strongSelf->_tfNumber.text);
        [kCurrentUser save];
        [self hideWithBlock:self.finishBlock isSucess:true];
    } failure:^(id object) {
        
    }];
}

@end
