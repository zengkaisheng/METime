//
//  MEMyAccountRecordCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyAccountRecordCell.h"
#import "MEMyAccountRecordModel.h"

@interface MEMyAccountRecordCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;

@end

@implementation MEMyAccountRecordCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEMyAccountRecordModel *)model {
    _titleLbl.text = kMeUnNilStr(model.type_name);
    _timeLbl.text = kMeUnNilStr(model.created_at);
    _moneyLbl.text = [NSString stringWithFormat:@"%@%@",kMeUnNilStr(model.symbol),kMeUnNilStr(model.money)];
}

@end
