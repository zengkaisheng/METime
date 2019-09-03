//
//  MEWxLoginVC.m
//  ME时代
//
//  Created by hank on 2018/10/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEWxLoginVC.h"
#import "MEAddTelView.h"
#import "MEWxAuthModel.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
#import "MECompandNoticeVC.h"

#import "MEFillInvationCodeVC.h"
#import "MEChooseStatusVC.h"
#import "MENewStoreApplyVC.h"

@interface MEWxLoginVC (){
    BOOL _isNewUser;
}

@property (assign, nonatomic) BOOL isModelPush;
@property (assign, nonatomic) BOOL isShowCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnWxLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@property (strong, nonatomic) MEAddTelView *addTelVIew;

@end

@implementation MEWxLoginVC

#pragma mark - LifeCycle

+ (void)presentLoginVCWithIsShowCancel:(BOOL)isShowCancel SuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail{
    if([WXApi isWXAppInstalled]){
        MEWxLoginVC *loginvc = [[MEWxLoginVC alloc]init];
        loginvc.blockSuccess = blockSuccess;
        loginvc.blockFail = blockFail;
        loginvc.isModelPush = YES;
        loginvc.isShowCancel = isShowCancel;
        [MECommonTool presentViewController:loginvc animated:YES completion:nil];
    }else{
        [MELoginVC presentLoginVCWithIsShowCancel:isShowCancel SuccessHandler:blockSuccess failHandler:blockFail];
    }
}

+ (void)presentLoginVCWithSuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail{
    if([WXApi isWXAppInstalled]){
        MEWxLoginVC *loginvc = [[MEWxLoginVC alloc]init];
        loginvc.blockSuccess = blockSuccess;
        loginvc.blockFail = blockFail;
        loginvc.isModelPush = YES;
        loginvc.isShowCancel = YES;
        [MECommonTool presentViewController:loginvc animated:YES completion:nil];
    }else{
        [MELoginVC presentLoginVCWithSuccessHandler:blockSuccess failHandler:blockFail];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    _isNewUser = YES;
    _btnWxLogin.hidden = _btnWxLogin.hidden = ![WXApi isWXAppInstalled];
    self.btnReturn.hidden = !self.isShowCancel;
}

#pragma mark - Private

-(void)loginSuccess{
    [self loginIm];
    [MECommonTool postAuthRegId];
    [MEPublicNetWorkTool getUserCheckFirstBuyWithSuccessBlock:nil failure:nil];
    [MEPublicNetWorkTool getUserInvitationCodeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kCurrentUser.invite_code = kMeUnNilStr(responseObject.data);
    } failure:^(id object) {
    }];
    //设置alias
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setAlias:kMeUnNilStr(kCurrentUser.uid) completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"iAlias=%@",iAlias);
        } seq:0];
        [JPUSHService setTags:[NSSet setWithObject:kMeUnNilStr(kCurrentUser.tag)] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"iTags=%@",iTags);
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
    
    if (kCurrentUser.user_type == 4) {
        [kMeUserDefaults setObject:@"customer" forKey:kMENowStatus];
    }else {
        [kMeUserDefaults setObject:@"business" forKey:kMENowStatus];
    }
    [kMeUserDefaults synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate reloadTabBar];
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
            
            //            NSLog(@"%@", [model mj_keyValues]);
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
        [self showInvitationCodeView:kCurrentUser.is_invitation == 1?NO:YES];
    }else{
        [self.addTelVIew show];
    }
}

- (void)showInvitationCodeView:(BOOL)needShow {
    if (needShow) {
        kMeWEAKSELF
        [MEFillInvationCodeVC presentFillInvationCodeVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [MEChooseStatusVC presentChooseStatusVCWithIndexBlock:^(NSInteger index) {
                if (index == 1) {
                    MENewStoreApplyVC *appleVC = [[MENewStoreApplyVC alloc] init];
                    [strongSelf.navigationController pushViewController:appleVC animated:YES];
                }
                [strongSelf loginSuccess];
            }];
        } failHandler:^(id object) {
             [MEUserInfoModel logout];
        }];
    }else {
        [self loginSuccess];
    }
}

- (IBAction)protocolsAction:(UIButton *)sender {
    MECompandNoticeVC *vc = [[MECompandNoticeVC alloc]init];
    vc.isProctol = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    [kMeApplication registerForRemoteNotifications];
}

- (MEAddTelView *)addTelVIew{
    if(!_addTelVIew){
        _addTelVIew = [[[NSBundle mainBundle]loadNibNamed:@"MEAddTelView" owner:nil options:nil] lastObject];
        _addTelVIew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        kMeWEAKSELF
        _addTelVIew.finishBlock = ^(BOOL sucess) {
            kMeSTRONGSELF
            if(sucess){//确认无误
                [strongSelf showInvitationCodeView:YES];
            }else{//信息错误
                [MEUserInfoModel logout];
//           [kCurrentUser removeFromLocalData];
//           [strongSelf loginFail];
            }
        };
    }
    return _addTelVIew;
}


- (IBAction)otherLoginAction:(UIButton *)sender {
    kMeWEAKSELF
    [MELoginVC presentLoginVCWithIsShowCancel:self.isShowCancel SuccessHandler:^(id object) {
        [MECommonTool dismissViewControllerAnimated:YES completion:^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.blockSuccess,nil);
        }];
    } failHandler:^(id object) {
        
    }];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self loginFail];
}

#pragma mark - Setter

@end
