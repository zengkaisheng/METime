//
//  MEGetCaseMainCell.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGetCaseMainCell.h"
#import "MEGetCaseMainModel.h"

@interface MEGetCaseMainCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBankNo;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lnlFee;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consErrorHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;


@end

@implementation MEGetCaseMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblStatus.adjustsFontSizeToFitWidth = YES;
    _lblError.numberOfLines = 0;
}

- (void)setUIWithModel:(MEGetCaseMainModel *)model{
    _lblOrderNo.text = [NSString stringWithFormat:@"提现单号:%@",kMeUnNilStr(model.order_sn)];
    _lblName.text = [NSString stringWithFormat:@"真实姓名:%@",kMeUnNilStr(model.true_name)];
    _lblBankNo.text = [NSString stringWithFormat:@"银行卡号:%@",kMeUnNilStr(model.account)];
    _lblMoney.text = [NSString stringWithFormat:@"提现金额:%@",kMeUnNilStr(model.all_money)];
    _lnlFee.text = [NSString stringWithFormat:@"手续费:%@",kMeUnNilStr(model.service_money)];
    _lblTime.text = [NSString stringWithFormat:@"申请时间:%@",kMeUnNilStr(model.created_at)];
   
    if(model.state == -1){
        _lblStatus.text = @"审核失败";
        NSString *erroeStr = [NSString stringWithFormat:@"失败原因:%@",kMeUnNilStr(model.error_desc)];
        _lblError.hidden = NO;
        CGFloat strHeight = [NSAttributedString heightForAtsWithStr:erroeStr font:kMeFont(13) width:(SCREEN_WIDTH- 48) lineH:0 maxLine:0];
        _consErrorHeight.constant = (strHeight<16?16:strHeight);
        [_lblError setAtsWithStr:erroeStr lineGap:0];
    }else{
//        -1失败1申请2通过 3打款成功
        if(model.state == 1){
            _lblStatus.text = @"审核中";
        }else if (model.state == 2){
            _lblStatus.text = @"审核通过";
        }else if (model.state == 3){
            _lblStatus.text = @"已打款";
        }else{
            _lblStatus.text = @"";
        }
        _lblError.hidden = YES;
        _lblError.text = @"";
    }
}

+(CGFloat)getCellHeightWithModel:(MEGetCaseMainModel *)model{
    CGFloat height = kMEGetCaseMainCellHeight;
    if(model.state != -1){
        return height;
    }else{
        height+=15;
        NSString *erroeStr = [NSString stringWithFormat:@"失败原因:%@",kMeUnNilStr(model.error_desc)];
        CGFloat strHeight = [NSAttributedString heightForAtsWithStr:erroeStr font:kMeFont(13) width:(SCREEN_WIDTH- 48) lineH:0 maxLine:0];
        height += (strHeight<16?16:strHeight);
        return height;
    }
}


@end
