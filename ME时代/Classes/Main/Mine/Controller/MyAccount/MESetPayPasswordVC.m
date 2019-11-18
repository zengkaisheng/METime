//
//  MESetPayPasswordVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESetPayPasswordVC.h"

@interface MESetPayPasswordVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTop;

@property (nonatomic, strong) UITextField *passTF;

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
    
    self.passTF = [[UITextField alloc] init];
    self.passTF.frame = CGRectMake(0, 0, 0, 0);
    self.passTF.delegate = self;
    self.passTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.passTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.passTF];
    
    self.tf1.keyboardType = self.tf2.keyboardType = self.tf3.keyboardType = self.tf4.keyboardType = self.tf5.keyboardType = self.tf6.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.passTF becomeFirstResponder];
}

#pragma mark - 文本框内容发生改变
- (void)textFieldDidChange:(UITextField*) sender {
    UITextField *_field = sender;
    switch (_field.text.length) {
        case 0:
            self.tf1.text = self.tf2.text = self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
            break;
        case 1:
            self.tf1.text = [_field.text substringWithRange:NSMakeRange(0, 1)];
            self.tf2.text = self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
            break;
        case 2:
            self.tf2.text = [_field.text substringWithRange:NSMakeRange(1, 1)];
            self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
            break;
        case 3:
            self.tf3.text = [_field.text substringWithRange:NSMakeRange(2, 1)];
            self.tf4.text = self.tf5.text = self.tf6.text = @"";
            break;
        case 4:
            self.tf4.text = [_field.text substringWithRange:NSMakeRange(3, 1)];
            self.tf5.text = self.tf6.text = @"";
            break;
        case 5:
            self.tf5.text = [_field.text substringWithRange:NSMakeRange(4, 1)];
            self.tf6.text = @"";
            break;
        case 6:
            self.tf6.text = [_field.text substringWithRange:NSMakeRange(5, 1)];
            [self.view endEditing:YES];
            break;
        default:
            break;
    }
}

#pragma mark -- Networking
//设置支付密码
- (void)setPayPasswordWithNetWork {
    NSString *password = [NSString stringWithFormat:@"%@",kMeUnNilStr(self.passTF.text)];
    if (password.length < 6 ) {
        [MECommonTool showMessage:@"您的密码格式不正确" view:kMeCurrentWindow];
        self.tf1.text = self.tf2.text = self.tf3.text = self.tf4.text = self.tf5.text = self.tf6.text = @"";
        self.passTF.text = @"";
        [self.passTF becomeFirstResponder];
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
