//
//  MEMineCustomerPhone.m
//  ME时代
//
//  Created by hank on 2018/10/9.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineCustomerPhone.h"
#import "MEStoreModel.h"

#define kMeWorkPhone @"18102678630"
#define kMeOffWorkPhone @"13580363686"

@interface MEMineCustomerPhone (){
    MEStoreModel *_stroeModel;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (weak, nonatomic) IBOutlet UILabel *lblTel;
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;

@end

@implementation MEMineCustomerPhone

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    _consTopMargin.constant = kMeStatusBarHeight+k15Margin;
//    kMeWEAKSELF
//    MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
//    [MEPublicNetWorkTool postGetappHomePageDataWithSuccessBlock:^(ZLRequestResponse *responseObject) {
//        kMeSTRONGSELF
//        [HUD hideAnimated:YES];
//        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
//            strongSelf->_stroeModel = [MEStoreModel mj_objectWithKeyValues:responseObject.data];
//            strongSelf->_lblTel.text = kMeUnNilStr(strongSelf->_stroeModel.cellphone);
//           strongSelf->_lblMobile.text = kMeUnNilStr(strongSelf->_stroeModel.cellphone);
//        }else{
//            strongSelf->_stroeModel = nil;
//            strongSelf->_lblTel.text = kMeWorkPhone;
//            strongSelf->_lblMobile.text = kMeOffWorkPhone;
//        }
//    } failure:^(id object) {
//        kMeSTRONGSELF
//        [HUD hideAnimated:YES];
//        strongSelf->_stroeModel = nil;
        _lblTel.text = kMeWorkPhone;
        _lblMobile.text = kMeOffWorkPhone;
//    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - Private

- (IBAction)workCallPhoneAction:(UIButton *)sender {
    [MECommonTool showWithTellPhone:kMeUnNilStr(_lblTel.text) inView:self.view];
}

- (IBAction)offWorkCallPhoneAction:(UIButton *)sender {
    [MECommonTool showWithTellPhone:kMeUnNilStr(_lblMobile.text) inView:self.view];
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
