//
//  MEconfirmPayCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEconfirmPayCell.h"

@interface MEconfirmPayCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLbl;

@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;


@end

@implementation MEconfirmPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
    
    _headerPic.hidden = _titleLbl.hidden = _moneyLbl.hidden = _payMoneyLbl.hidden = _payStatus.hidden = _accountLbl.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setFirstCellUIWithHeaderPic:(NSString *)headerPic title:(NSString *)title {
    _headerPic.hidden = _titleLbl.hidden = NO;
    _moneyLbl.hidden = _payMoneyLbl.hidden = _payStatus.hidden = _accountLbl.hidden = YES;
    
    kSDLoadImg(_headerPic, kMeUnNilStr(headerPic));
    _titleLbl.text = kMeUnNilStr(title);
}

- (void)setSecondCellUIWithMoney:(NSString *)money {
    _headerPic.hidden = _titleLbl.hidden = _payStatus.hidden = _accountLbl.hidden = YES;
    _moneyLbl.hidden = _payMoneyLbl.hidden = NO;
    _moneyLbl.text = [NSString stringWithFormat:@"￥%@",kMeUnNilStr(money)];
}

- (void)setThirdCellUIWithAccount:(NSString *)account {
    _headerPic.hidden = _titleLbl.hidden = _moneyLbl.hidden = _payMoneyLbl.hidden = YES;
    _payStatus.hidden = _accountLbl.hidden = NO;
    _accountLbl.text = [NSString stringWithFormat:@"资金余额：%@元",kMeUnNilStr(account)];
}

@end
