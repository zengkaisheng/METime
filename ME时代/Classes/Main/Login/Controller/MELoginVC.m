//
//  MELoginVC.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MELoginVC.h"
#import "METickTimerTool.h"
#import "MEUserInfoModel.h"
#import "MEAddTelView.h"
#import "MEWxAuthModel.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
#import "MECompandNoticeVC.h"

#define kImgTopMargin (54.0 * kMeFrameScaleY())


@interface MELoginVC ()<UITextFieldDelegate>{
    METickTimerTool *_timer;
    NSString *_strCaptcha;
    BOOL _isNewUser;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleTopMargin;

@property (weak, nonatomic) IBOutlet UITextField *tfNnumber;
@property (weak, nonatomic) IBOutlet UITextField *tfCaptcha;

@property (weak, nonatomic) IBOutlet UIButton *btnCaptcha;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBtnTopMargin;
@property (assign, nonatomic) BOOL isModelPush;
@property (strong, nonatomic) MEAddTelView *addTelVIew;
@property (weak, nonatomic) IBOutlet UIButton *btnWxLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (assign, nonatomic) BOOL isShowCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnBreturn;

@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@end

@implementation MELoginVC

+ (void)presentLoginVCWithIsShowCancel:(BOOL)isShowCancel SuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail{
    MELoginVC *loginvc = [[MELoginVC alloc]init];
    loginvc.blockSuccess = blockSuccess;
    loginvc.blockFail = blockFail;
    loginvc.isModelPush = YES;
    loginvc.isShowCancel = isShowCancel;
    [MECommonTool presentViewController:loginvc animated:YES completion:nil];
}

+ (void)presentLoginVCWithSuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail{
    MELoginVC *loginvc = [[MELoginVC alloc]init];
    loginvc.blockSuccess = blockSuccess;
    loginvc.blockFail = blockFail;
    loginvc.isModelPush = YES;
    loginvc.isShowCancel = YES;
    [MECommonTool presentViewController:loginvc animated:YES completion:nil];
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSomeThing];
    _isNewUser = YES;
    _lblLogin.hidden = _btnWxLogin.hidden = ![WXApi isWXAppInstalled];
    self.btnReturn.hidden = !self.isShowCancel;
    self.btnBreturn.hidden = !self.isShowCancel;
    // Do any additional setup after loading the view from its nib.
}


- (void)initSomeThing{
    [self setLayout];
    self.navBarHidden = YES;
    [_btnCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_tfCaptcha addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tfCaptcha addTarget:self action:@selector(tfVerficationTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    _tfCaptcha.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)setLayout{
    _consTitleTopMargin.constant = kMeStatusBarHeight + (8*kMeFrameScaleY());
    _consImgTopMargin.constant = kImgTopMargin;
    _consImgBottomMargin.constant = 44 * kMeFrameScaleY();
    _consBtnTopMargin.constant =42 * kMeFrameScaleY();
    if(kMeFrameScaleY()<1){
        _consImgTopMargin.constant = 64;
    }
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginSuccess{
    [self loginIm];
    [MEPublicNetWorkTool getUserCheckFirstBuyWithSuccessBlock:nil failure:nil];
    //设置alias
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setAlias:kMeUnNilStr(kCurrentUser.uid) completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"iAlias=%@",iAlias);
        } seq:0];
    });
    kNoticeUserLogin
    if(self.isModelPush){
        kMeWEAKSELF
        [MECommonTool dismissViewControllerAnimated:YES completion:^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.blockSuccess,nil);
        }];
    }else{
        kMeCallBlock(self.blockSuccess,nil);
    }
}

-(void)loginFail{
    if(self.isModelPush){
        kMeWEAKSELF
        [MECommonTool dismissViewControllerAnimated:YES completion:^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.blockFail,nil);
        }];
    }else{
        kMeCallBlock(self.blockFail,nil);
    }
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

- (IBAction)loginAction:(UIButton *)sender {
    kMeWEAKSELF
    [MEPublicNetWorkTool postloginByPhoneWithPhone:kMeUnNilStr(_tfNnumber.text) code:kMeUnNilStr(_tfCaptcha.text) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf dealWithUserInfoWithrespon:responseObject];
    } failure:^(id object) {
        //        kMeSTRONGSELF
        //        [strongSelf loginFail];
    }];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self loginFail];
}

- (void)dealWithUserInfoWithrespon:(ZLRequestResponse *)responseObject{
    if(![responseObject.data isKindOfClass:[NSDictionary class]]){
        [MEShowViewTool showMessage:@"数据错误" view:self.view];
    }
    [kCurrentUser setterWithDict:responseObject.data];
    [kCurrentUser save];
    NSString *strPhone = responseObject.data[@"mobile"];
    [self inJuicAddPhone:kMeUnNilStr(strPhone).length];
}

- (IBAction)captchaAction:(UIButton *)sender {
    if(![MECommonTool isValidPhoneNum:kMeUnNilStr(_tfNnumber.text)]){
        [MEShowViewTool showMessage:@"手机格式不对" view:self.view];
        _tfNnumber.text = @"";
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCodeWithrPhone:kMeUnNilStr(_tfNnumber.text) type:@"1" successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf timerTick];
    } failure:^(id object) {
        
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

- (IBAction)wxlogin:(UIButton *)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [MEShowViewTool showMessage:@"授权失败" view:kMeCurrentWindow];
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            
            MEWxAuthModel *model = [[MEWxAuthModel alloc]init];
            model.union_id = kMeUnNilStr(resp.unionId);
            model.app_openid = kMeUnNilStr(resp.openid);
            
            model.nick_name = kMeUnNilStr(resp.name);
            model.header_pic = kMeUnNilStr(resp.iconurl);
            NSString *str = @"3";
            if(kMeUnNilStr(resp.unionGender).length){
                str = [resp.unionGender isEqualToString:@"男"]?@"1":@"2";
            }
            model.gender = str;
            [MEPublicNetWorkTool postWxAuthLoginWithAttrModel:model successBlock:^(ZLRequestResponse *responseObject) {
                
                [kCurrentUser setterWithDict:responseObject.data];
                [kCurrentUser save];
                NSString *strPhone = responseObject.data[@"mobile"];
                [self inJuicAddPhone:kMeUnNilStr(strPhone).length];
            } failure:^(id object) {
                [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
            }];
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

//判断是否已经绑定手机号
- (void)inJuicAddPhone:(BOOL)isAadd{
    if(isAadd){
        [self loginSuccess];
    }else{
        [self.addTelVIew show];
    }
}

//登录融云
- (void)loginIm{
    if([MEUserInfoModel isLogin] && kMeUnNilStr(kCurrentUser.tls_data.tls_id).length && kMeUnNilStr(kCurrentUser.tls_data.user_tls_key).length){
        [[TUIKit sharedInstance] loginKit:kMeUnNilStr(kCurrentUser.tls_data.tls_id) userSig:kMeUnNilStr(kCurrentUser.tls_data.user_tls_key) succ:^{
            NSLog(@"sucess");
        } fail:^(int code, NSString *msg) {
            NSLog(@"fial");
        }];
    }

    //
    [kMeApplication registerForRemoteNotifications];
    //    [MEPublicNetWorkTool postRongyunTokenWithSuccessBlock:^(ZLRequestResponse *responseObject) {
    //        NSString *nameStr = kMeUnNilStr(kCurrentUser.name).length > 0  ? kCurrentUser.name : kMeUnNilStr(kCurrentUser.uid);
    //        [[RCIM sharedRCIM] connectWithToken:kCurrentUser.rongcloud_token success:^(NSString *userId) {
    //            RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:kMeUnNilStr(kCurrentUser.uid) name:nameStr portrait:kMeUnNilStr(kCurrentUser.header_pic)];
    ////            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
    //            [RCIM sharedRCIM].currentUserInfo = user;
    //            [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                AppDelegate *delegate = (AppDelegate *)kMeAppDelegateInstance;
    //                [[RCIM sharedRCIM] setUserInfoDataSource:delegate];
    //            });
    //            kNoticeReloadkUnMessage
    //        }error:^(RCConnectErrorCode status) {
    //            NSLog(@"失败");
    //        }tokenIncorrect:^() {
    //            NSLog(@"失效");
    //        }];
    //    } failure:^(id object) {
    //
    //    }];
}

- (IBAction)protocolsAction:(UIButton *)sender {
    MECompandNoticeVC *vc = [[MECompandNoticeVC alloc]init];
    vc.isProctol = YES;
    [self.navigationController pushViewController:vc animated:YES];
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

- (MEAddTelView *)addTelVIew{
    if(!_addTelVIew){
        _addTelVIew = [[[NSBundle mainBundle]loadNibNamed:@"MEAddTelView" owner:nil options:nil] lastObject];
        _addTelVIew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        kMeWEAKSELF
        _addTelVIew.finishBlock = ^(BOOL sucess) {
            kMeSTRONGSELF
            if(sucess){
                [strongSelf loginSuccess];
            }else{
                [kCurrentUser removeFromLocalData];
                [strongSelf loginFail];
            }
        };
    }
    return _addTelVIew;
}


@end
