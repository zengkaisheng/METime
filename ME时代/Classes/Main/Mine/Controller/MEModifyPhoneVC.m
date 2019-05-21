//
//  MEModifyPhoneVC.m
//  ME时代
//
//  Created by hank on 2018/9/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEModifyPhoneVC.h"
#import "METickTimerTool.h"

@interface MEModifyPhoneVC ()<UITextFieldDelegate>{
    METickTimerTool *_timer;
    NSString *_strCaptcha;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMarhin;

@property (weak, nonatomic) IBOutlet UILabel *llbPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfNnumber;
@property (weak, nonatomic) IBOutlet UITextField *tfCaptcha;
@property (weak, nonatomic) IBOutlet UIButton *btnCaptcha;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@end

@implementation MEModifyPhoneVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更改手机号";
    self.view.backgroundColor =kMEHexColor(@"eeeeee");
    _consTopMarhin.constant = kMeNavBarHeight+10;
    _llbPhone.text = [NSString stringWithFormat:@"当前绑定手机号:%@",kCurrentUser.mobile];
    [_btnCaptcha setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_tfCaptcha addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tfCaptcha addTarget:self action:@selector(tfVerficationTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    _tfCaptcha.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark - UITextField Action

- (void)tfCodeTextDidChange:(UITextField *)textField{
    if(textField.text.length> kLimitVerficationNum){
        _btnLogin.enabled = YES;
        textField.text = [textField.text substringWithRange:NSMakeRange(0,kLimitVerficationNum + 1)];
    }else{
        _btnLogin.enabled = NO;
    }
    _strCaptcha = textField.text;
}

- (void)tfVerficationTextDidChange:(UITextField *)textField{
    if(textField.text.length > kLimitVerficationNum){
        [_btnLogin setBackgroundColor:kMEPink];
        _btnLogin.enabled = YES;
    }else{
        [_btnLogin setBackgroundColor:[UIColor colorWithHexString:@"bbbbbb"]];
        _btnLogin.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
 
#pragma mark - Public
 
- (IBAction)comFirmAction:(UIButton *)sender {
    [self.view endEditing:YES];
    kMeWEAKSELF
    [MEPublicNetWorkTool posteditPhoneWithPhone:kMeUnNilStr(kCurrentUser.mobile) code:kMeUnNilStr(_tfCaptcha.text) new_phone:kMeUnNilStr(_tfNnumber.text) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        kCurrentUser.mobile = kMeUnNilStr(strongSelf->_tfNnumber.text);
        [kCurrentUser save];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id object) {
    }];
}

- (IBAction)captchaAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if(![MECommonTool isValidPhoneNum:kMeUnNilStr(_tfNnumber.text)]){
        [MEShowViewTool showMessage:@"手机格式不对" view:self.view];
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
#pragma mark - Private

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

#pragma mark - Getter
 
#pragma mark - Setter

@end
