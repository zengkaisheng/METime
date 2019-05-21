//
//  MEAddTelView.m
//  ME时代
//
//  Created by hank on 2018/9/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAddTelView.h"
#import "METickTimerTool.h"
#import "MEModelView.h"

#define kMEAddTelViewHeight (288*kMeFrameScaleY())
#define kMEAddTelViewWidth (250*kMeFrameScaleX())
#define kBtnBottomMargin (35*kMeFrameScaleY())

@interface MEAddTelView ()<UITextFieldDelegate>{
    METickTimerTool *_timer;
    NSString *_strCaptcha;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBtnBottomMargin;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *tfNnumber;
@property (weak, nonatomic) IBOutlet UITextField *tfCaptcha;
@property (weak, nonatomic) IBOutlet UIButton *btnCaptcha;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *viewPhone;
//@property (weak, nonatomic) IBOutlet UITextField *tfInviate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewX;


@end

@implementation MEAddTelView

- (void)awakeFromNib{
    [super awakeFromNib];
    _consViewHeight.constant =kMEAddTelViewHeight;
    _consViewWidth.constant =kMEAddTelViewWidth;
    _consBtnBottomMargin.constant = kMeFrameScaleY()<1?10:kBtnBottomMargin;
    _consViewX.constant =kMeFrameScaleY()<1?-40:0;
    [self layoutIfNeeded];
    [self initSomeThing];
}

- (void)initSomeThing{
//    _bgView.backgroundColor = [UIColor blackColor];
//    _bgView.alpha = 0.5;
    [_btnCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_tfCaptcha addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tfCaptcha addTarget:self action:@selector(tfVerficationTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    _tfCaptcha.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_bgView addGestureRecognizer:tap];
    [self addGestureRecognizer:tap];
}

#pragma mark - UITextField Action

- (void)tfCodeTextDidChange:(UITextField *)textField{
    if(textField.text.length> kLimitVerficationNum){
        _btnAdd.enabled = YES;
        textField.text = [textField.text substringWithRange:NSMakeRange(0,kLimitVerficationNum + 1)];
    }else{
        _btnAdd.enabled = NO;
    }
    _strCaptcha = textField.text;
}

- (void)tfVerficationTextDidChange:(UITextField *)textField{
    if(textField.text.length > kLimitVerficationNum){
        [_btnAdd setBackgroundColor:kMEPink];
        _btnAdd.enabled = YES;
    }else{
        [_btnAdd setBackgroundColor:[UIColor colorWithHexString:@"bbbbbb"]];
        _btnAdd.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

- (IBAction)addTelAction:(UIButton *)sender {
    kMeWEAKSELF
    [MEPublicNetWorkTool postaddPhoneWithPhone:kMeUnNilStr(_tfNnumber.text) code:kMeUnNilStr(_tfCaptcha.text) invate:@"" successBlock:^(ZLRequestResponse *responseObject) {
        //绑定手机号成功 保存到本地
        kMeSTRONGSELF
        kCurrentUser.mobile = kMeUnNilStr(strongSelf->_tfNnumber.text);
        [kCurrentUser save];
        [self hideWithBlock:self.finishBlock isSucess:true];
    } failure:^(id object) {
        
    }];
}

- (IBAction)captchaAction:(UIButton *)sender {
    if(![MECommonTool isValidPhoneNum:kMeUnNilStr(_tfNnumber.text)]){
        [MEShowViewTool showMessage:@"手机格式不对" view:self];
        _tfNnumber.text = @"";
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCodeWithrPhone:kMeUnNilStr(_tfNnumber.text) type:@"2" successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf timerTick];
    } failure:^(id object) {
        
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self endEditing:YES];
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
- (IBAction)closeAction:(UIButton *)sender {
    [self hideWithBlock:self.finishBlock isSucess:false];
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

- (void)hideWithBlock:(kMeBOOLBlock)block isSucess:(BOOL)isSucess{
    [self removeFromSuperview];
    kMeCallBlock(block,isSucess);
}

@end
