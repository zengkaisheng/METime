//
//  MEWithdrawalView.m
//  ME时代
//
//  Created by hank on 2018/12/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEWithdrawalView.h"
#import "MEWithdrawalTextField.h"
#import "MEWithdrawalParamModel.h"

@interface MEWithdrawalView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBtnTopMargin;
@property (nonatomic, strong) MEWithdrawalParamModel *parModel;

@property (weak, nonatomic) IBOutlet MEWithdrawalTextField *tfName;
@property (weak, nonatomic) IBOutlet MEWithdrawalTextField *tfBankName;
@property (weak, nonatomic) IBOutlet MEWithdrawalTextField *tfBnkNo;
@property (weak, nonatomic) IBOutlet MEWithdrawalTextField *tfBankBelong;

@end

@implementation MEWithdrawalView

- (void)awakeFromNib{
    [super awakeFromNib];
    _consBtnTopMargin.constant = 125 * kMeFrameScaleX();
    kMeWEAKSELF
    _tfName.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.parModel.true_name = str;
    };
    _tfBankName.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.parModel.bank = str;
    };
    _tfBnkNo.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.parModel.account = str;
    };
    _tfBankBelong.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.parModel.branch = str;
    };
}


- (IBAction)applyAction:(UIButton *)sender {
    if(!kMeUnNilStr(self.parModel.true_name).length){
        [MEShowViewTool showMessage:@"名字不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.bank).length){
        [MEShowViewTool showMessage:@"银行名称不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.account).length){
        [MEShowViewTool showMessage:@"银行卡号不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.branch).length){
        [MEShowViewTool showMessage:@"银行支行不能为空" view:kMeCurrentWindow];
        return;
    }
    [self endEditing:YES];
    if(_isCouponMoney){
        self.parModel.order_type = @"1";
    }else{
        self.parModel.order_type = @"";
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postDestoonFinanceCashWithAttrModel:self.parModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf->_applyFinishBlock);
    } failure:^(id object) {
        
    }];
}


+ (CGFloat)getViewHeight{
    CGFloat height = 586 - 125;
    height +=(125 * kMeFrameScaleX());
    return height;
}

- (MEWithdrawalParamModel*)parModel{
    if(!_parModel){
        _parModel = [MEWithdrawalParamModel new];
        _parModel.token = kMeUnNilStr(kCurrentUser.token);
    }
    return _parModel;
}

@end
