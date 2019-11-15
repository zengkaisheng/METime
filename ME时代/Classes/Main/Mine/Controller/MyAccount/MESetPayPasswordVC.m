//
//  MESetPayPasswordVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESetPayPasswordVC.h"

@interface MESetPayPasswordVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTop;

@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UITextField *tf4;
@property (weak, nonatomic) IBOutlet UITextField *tf5;
@property (weak, nonatomic) IBOutlet UITextField *tf6;

@end

@implementation MESetPayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置支付密码";
    [self.tf1 addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf2 addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf3 addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf4 addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf5 addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf6 addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tf1.keyboardType = self.tf2.keyboardType = self.tf3.keyboardType = self.tf4.keyboardType = self.tf5.keyboardType = self.tf6.keyboardType = UIKeyboardTypeNumberPad;
    [self.tf1 becomeFirstResponder];
}

- (void)tfCodeTextDidChange:(UITextField *)textField {
    if (textField.text.length >= 1) {
        if ([textField isEqual:self.tf1]) {
            [self.tf2 becomeFirstResponder];
        }else if ([textField isEqual:self.tf2]) {
            [self.tf3 becomeFirstResponder];
        }else if ([textField isEqual:self.tf3]) {
            [self.tf4 becomeFirstResponder];
        }else if ([textField isEqual:self.tf4]) {
            [self.tf5 becomeFirstResponder];
        }else if ([textField isEqual:self.tf5]) {
            [self.tf6 becomeFirstResponder];
        }else if ([textField isEqual:self.tf6]) {
            self.tf6.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
            [self.view endEditing:YES];
//            [self checkSignInCodeWithNetWork];
        }
    }else {
        if ([textField isEqual:self.tf6]) {
            [self.tf5 becomeFirstResponder];
        }else if ([textField isEqual:self.tf5]) {
            [self.tf4 becomeFirstResponder];
        }else if ([textField isEqual:self.tf4]) {
            [self.tf3 becomeFirstResponder];
        }else if ([textField isEqual:self.tf3]) {
            [self.tf2 becomeFirstResponder];
        }else if ([textField isEqual:self.tf2]) {
            [self.tf1 becomeFirstResponder];
        }
    }
}

#pragma mark -- Networking
//设置支付密码
- (void)setPayPasswordWithNetWork {
    NSString *password = [NSString stringWithFormat:@"%@%@%@%@%@%@",kMeUnNilStr(self.tf1.text),kMeUnNilStr(self.tf2.text),kMeUnNilStr(self.tf3.text),kMeUnNilStr(self.tf4.text),kMeUnNilStr(self.tf5.text),kMeUnNilStr(self.tf6.text)];
    if (self.tf1.text <= 0 || self.tf2.text <= 0 || self.tf3.text <= 0 || self.tf4.text <= 0 || self.tf5.text <= 0 || self.tf6.text <= 0) {
        [MECommonTool showMessage:@"您的密码格式不正确" view:kMeCurrentWindow];
        self.tf1.text = self.tf2.text = self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
        [self.tf1 becomeFirstResponder];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postSetPayPasswordWithPassword:password rPassword:password type:@"1" phone:@"" code:@"" successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.status_code integerValue] == 200) {
            [MECommonTool showMessage:@"支付密码设置成功" view:kMeCurrentWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *vcs = strongSelf.navigationController.viewControllers;
                UIViewController *vc = [vcs objectAtIndex:vcs.count-3];
                [strongSelf.navigationController popToViewController:vc animated:YES];
            });
        }
    } failure:^(id object) {
        
    }];
}

- (IBAction)finishBtnAction:(id)sender {
    [self setPayPasswordWithNetWork];
}


@end
