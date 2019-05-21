//
//  MEGetCaseContentCell.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGetCaseContentCell.h"
#import "MEGetCaseModel.h"

@interface MEGetCaseContentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblSku;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblDataDealMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consErrorHeight;

@end

@implementation MEGetCaseContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblMoney.adjustsFontSizeToFitWidth = YES;
    _lblDataDealMoney.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWIthModel:(MEGetCaseContentModel *)model{
    _lblDataDealMoney.hidden = YES;
    kSDLoadImg(_imgHeader, kMeUnNilStr(model.product_image));
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSku.text = [NSString stringWithFormat:@"规格:%@ 数量%@",kMeUnNilStr(model.order_spec_name),kMeUnNilStr(model.product_number)];
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.all_amount)];
    _lblMoney.text =  [NSString stringWithFormat:@"获得的佣金:%@",kMeUnNilStr(model.money)];
    //1申请提现 2申请通过 3申请不通过 4已提现
    if(model.status == 3){
        _lblStatus.text = @"审核失败";
        NSString *erroeStr = [NSString stringWithFormat:@"失败原因:%@",kMeUnNilStr(model.check_remark)];
        _lblError.hidden = NO;
        CGFloat strHeight = [NSAttributedString heightForAtsWithStr:erroeStr font:kMeFont(12) width:(SCREEN_WIDTH-48- 61) lineH:0 maxLine:0];
        _consErrorHeight.constant = (strHeight<15?15:strHeight);
        [_lblError setAtsWithStr:erroeStr lineGap:0];
    }else{

        _consErrorHeight.constant = 15;
        if(model.status == 1){
            _lblStatus.text = @"审核中";
        }else if (model.status == 2){
            _lblStatus.text = @"审核通过";
        }else if (model.status == 4){
            _lblStatus.text = @"已打款";
        }else{
            _lblStatus.text = @"";
        }
        _lblError.hidden = YES;
        _lblError.text = @"";
    }
}

- (void)setUIDataDealWIthModel:(MEGetCaseContentModel *)model{
    _lblPrice.hidden = YES;
    _lblMoney.hidden = YES;
    _lblStatus.hidden = YES;
    _lblError.hidden = YES;
    kSDLoadImg(_imgHeader, model.product_image);
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSku.text  = [NSString stringWithFormat:@"规格:%@ 数量%@",kMeUnNilStr(model.order_spec_name),kMeUnNilStr(model.product_number)];
    _lblDataDealMoney.text =  [NSString stringWithFormat:@"获得的佣金:%@",kMeUnNilStr(kMeUnNilStr(model.money))];
}

+ (CGFloat)getCellHeightWithModel:(MEGetCaseContentModel *)model{
    CGFloat height = kMEGetCaseContentCellHeight+11+15;
    if(model.status != 3){
        return height;
    }else{
        height-=15;
        NSString *erroeStr = [NSString stringWithFormat:@"失败原因:%@",kMeUnNilStr(model.check_remark)];
        CGFloat strHeight =  [NSAttributedString heightForAtsWithStr:erroeStr font:kMeFont(12) width:(SCREEN_WIDTH-48- 61) lineH:0 maxLine:0];
        height += (strHeight<15?15:strHeight);
        return height;
    }
    return height;
}


@end
