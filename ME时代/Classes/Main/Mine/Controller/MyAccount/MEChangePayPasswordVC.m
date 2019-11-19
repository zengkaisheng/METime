//
//  MEChangePayPasswordVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEChangePayPasswordVC.h"
#import "MEBlockTextField.h"
#import "METickTimerTool.h"

@interface MEChangePayPasswordVC (){
    METickTimerTool *_timer;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTop;
@property (weak, nonatomic) IBOutlet MEBlockTextField *phoneTF;
@property (weak, nonatomic) IBOutlet MEBlockTextField *codeTF;
@property (weak, nonatomic) IBOutlet MEBlockTextField *passwordTF;
@property (weak, nonatomic) IBOutlet MEBlockTextField *rPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation MEChangePayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记支付密码";
    _consTop.constant = kMeNavBarHeight+72;
    _phoneTF.text = kMeUnNilStr(kCurrentUser.mobile);
    _phoneTF.enabled = NO;
    kMeWEAKSELF
    _phoneTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 11) {
            strongSelf->_phoneTF.text = [str substringWithRange:NSMakeRange(0, 11)];
        }
    };
    _codeTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 6) {
            strongSelf->_codeTF.text = [str substringWithRange:NSMakeRange(0, 6)];
        }
    };
    _seeBtn.selected = YES;
    _passwordTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 6) {
            strongSelf->_passwordTF.text = [str substringWithRange:NSMakeRange(0, 6)];
        }
    };
    _rPasswordTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 6) {
            strongSelf->_rPasswordTF.text = [str substringWithRange:NSMakeRange(0, 6)];
        }
    };
}

- (IBAction)getCodeAction:(id)sender {
    //获取验证码
    if(![MECommonTool isValidPhoneNum:kMeUnNilStr(_phoneTF.text)]){
        [MEShowViewTool showMessage:@"手机格式不对" view:self.view];
        _phoneTF.text = @"";
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetNewCodeWithPhone:kMeUnNilStr(_phoneTF.text) type:@"1" successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf timerTick];
    } failure:^(id object) {
        
    }];
}

- (IBAction)seePasswordAction:(id)sender {
    //查看密码
    _seeBtn.selected = !_seeBtn.selected;
    _passwordTF.secureTextEntry = _seeBtn.selected;
}

- (IBAction)submitAction:(id)sender {
    if (![MECommonTool isValidPhoneNum:_phoneTF.text]) {
        [MEShowViewTool showMessage:@"手机格式不对" view:self.view];
        _phoneTF.text = @"";
        return;
    }
    if (_codeTF.text.length <= 0) {
        [MEShowViewTool showMessage:@"请输入验证码" view:self.view];
        return;
    }else if (_codeTF.text.length < 6) {
        [MEShowViewTool showMessage:@"验证码格式不对" view:self.view];
        return;
    }
    
    if (_passwordTF.text.length <= 0) {
        [MEShowViewTool showMessage:@"请输入新密码" view:self.view];
        return;
    }else if (_passwordTF.text.length < 6) {
        [MEShowViewTool showMessage:@"新密码格式不对" view:self.view];
        return;
    }
    if (_rPasswordTF.text.length <= 0) {
        [MEShowViewTool showMessage:@"请输入确认密码" view:self.view];
        return;
    }else if (_rPasswordTF.text.length < 6) {
        [MEShowViewTool showMessage:@"确认密码格式不对" view:self.view];
        return;
    }
    if (![_passwordTF.text isEqualToString:_rPasswordTF.text]) {
        [MEShowViewTool showMessage:@"两次密码输入不正确" view:self.view];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postSetPayPasswordWithPassword:_passwordTF.text rPassword:_rPasswordTF.text type:@"2" phone:_phoneTF.text code:_codeTF.text successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.status_code integerValue] == 200) {
            [MECommonTool showMessage:@"支付密码修改成功" view:kMeCurrentWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(id object) {
        
    }];
}

-(void)timerTick{
    kMeWEAKSELF
    if (!_timer) {
        _timer = [[METickTimerTool alloc] init];
    }
    self.codeBtn.enabled = NO;
    [_timer tickTime:kValidTime tickBlock:^(NSTimeInterval tick) {
        kMeSTRONGSELF
        NSString *title = [NSString stringWithFormat:@"%.0fs",tick];
        [strongSelf.codeBtn setTitle:title forState:strongSelf.codeBtn.state];
    } finishBlock:^{
        kMeSTRONGSELF
        strongSelf.codeBtn.enabled = YES;
        [strongSelf.codeBtn setTitle:@"获取验证码" forState:strongSelf.codeBtn.state];
    }];
}



@end
