//
//  MEClerkCouponMangerVC.m
//  ME时代
//
//  Created by hank on 2019/5/9.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEClerkCouponMangerVC.h"
#import "MEBlockTextField.h"
#import "MEClerkCouponMangerModel.h"

@interface MEClerkCouponMangerVC (){
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfRate;
@property (weak, nonatomic) IBOutlet UISwitch *sw;
@property (weak, nonatomic) IBOutlet UITextField *tfSetRate;
@property (strong, nonatomic) MEClerkCouponMangerModel *model;
@end

@implementation MEClerkCouponMangerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店员优惠券分佣";
    _consTopMargin.constant = kMeNavBarHeight + 15;
    _model = [MEClerkCouponMangerModel new];
    kMeWEAKSELF
    [MEPublicNetWorkTool postClerkCommissionPercentrWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_model = [MEClerkCouponMangerModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf initSomeThing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)initSomeThing{
    _sw.on = _model.isset_clerk_commission_ratio;
    _tfRate.text = [NSString stringWithFormat:@"%@",@(kMeUnNilStr(_model.clerk_commission_ratio).floatValue)];
    _tfSetRate.text = [NSString stringWithFormat:@"0~%@",@(kMeUnNilStr(_model.system_clerk_percent).floatValue)];
    kMeWEAKSELF
    _tfRate.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf->_model.clerk_commission_ratio = [NSString stringWithFormat:@"%@",@(kMeUnNilStr(str).floatValue)];;
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)onCounponAction:(UISwitch *)sender {
    _model.isset_clerk_commission_ratio = sender.isOn;
}


- (IBAction)subMitAction:(UIButton *)sender {
    [self.view endEditing:YES];
//    if(kMeUnNilStr(_tfRate.text).length == 0 || [kMeUnNilStr(_tfRate.text) isEqualToString:@"0"]){
//        
//    }
    [MEPublicNetWorkTool postClerkCommissionPercentWithissetClerk:_model.isset_clerk_commission_ratio ratio:_model.clerk_commission_ratio successBlock:^(ZLRequestResponse *responseObject) {
        
    } failure:^(id object) {
    }];
}



@end
