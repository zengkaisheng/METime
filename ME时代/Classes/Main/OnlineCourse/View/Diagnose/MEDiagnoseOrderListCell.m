//
//  MEDiagnoseOrderListCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseOrderListCell.h"
#import "MEDiagnoseOrderListModel.h"

@interface MEDiagnoseOrderListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *buyTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *effectiveTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *remarkLbl;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConsHeight;

@end


@implementation MEDiagnoseOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bottomView.hidden = YES;
    _bgView.layer.shadowOffset = CGSizeMake(0, 1);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEDiagnoseOrderListModel *)model {
    _nameLbl.text = kMeUnNilStr(model.product_name);
    _buyTimeLbl.text = [NSString stringWithFormat:@"购买时长：%@",kMeUnNilStr(model.buy_time)];
    _effectiveTimeLbl.text = [NSString stringWithFormat:@"有效时间：%@",kMeUnNilStr(model.effective_time)];
    _payTimeLbl.text = [NSString stringWithFormat:@"支付时间：%@",kMeUnNilStr(model.pay_time)];
    _phoneLbl.text = [NSString stringWithFormat:@"用户电话：%@",kMeUnNilStr(model.phone)];
    _remarkLbl.text = [NSString stringWithFormat:@"用户备注：%@",kMeUnNilStr(model.remark)];
    _amountLbl.text = [NSString stringWithFormat:@"共计：￥%@",kMeUnNilStr(model.price)];
    
    if (model.isSpread) {
        _bottomView.hidden = NO;
        _bottomViewConsHeight.constant = model.contentHeight;
        _contentLbl.text = kMeUnNilStr(model.desc);
        [_changeBtn setImage:[UIImage imageNamed:@"icon_triangle_up"] forState:UIControlStateNormal];
    }else {
        _bottomView.hidden = YES;
        _bottomViewConsHeight.constant = 0;
        [_changeBtn setImage:[UIImage imageNamed:@"icon_triangle_down"] forState:UIControlStateNormal];
    }
}
- (IBAction)changeBtnDidClick:(id)sender {
    kMeCallBlock(_tapBlock);
}

@end
