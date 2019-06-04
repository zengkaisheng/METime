//
//  MEFillInvationCodeVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFillInvationCodeVC.h"

@interface MEFillInvationCodeVC ()
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *captcha;
@property (weak, nonatomic) IBOutlet UITextField *invationCodeTF;

@end

@implementation MEFillInvationCodeVC

+ (void)presentFillInvationCodeVCWithPhone:(NSString *)phone captcha:(NSString *)captcha Code:(NSString *)codeStr SuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail{
    MEFillInvationCodeVC *codevc = [[MEFillInvationCodeVC alloc]init];
    codevc.blockSuccess = blockSuccess;
    codevc.blockFail = blockFail;
    if ([codeStr length] > 0) {
        codevc.invationCodeTF.text = codeStr;
    }
    codevc.phone = phone;
    codevc.captcha = captcha;
    [MECommonTool presentViewController:codevc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBarHidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction {
    [self.view endEditing:YES];
}

- (IBAction)sureAction:(id)sender {
    if ([self.invationCodeTF.text length] <= 0) {
        [MEShowViewTool showMessage:@"请输入邀请码" view:kMeCurrentWindow];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postaddPhoneWithPhone:kMeUnNilStr(_phone) code:kMeUnNilStr(_captcha) invate:kMeUnNilStr(_invationCodeTF.text) successBlock:^(ZLRequestResponse *responseObject) {
        //绑定手机号成功 保存到本地
        kMeSTRONGSELF
        kCurrentUser.mobile = kMeUnNilStr(strongSelf.phone);
        [kCurrentUser save];
        [MECommonTool dismissViewControllerAnimated:YES completion:^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.blockSuccess,nil);
        }];
    } failure:^(id object) {

    }];
}
- (IBAction)backAction:(id)sender {
//    kMeWEAKSELF
    [MECommonTool dismissViewControllerAnimated:YES completion:^{
//        kMeSTRONGSELF
//        kMeCallBlock(strongSelf.blockFail,nil);
    }];
}

@end
