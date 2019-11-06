//
//  MEAppointmentStatusCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAppointmentStatusCell.h"
#import "MEAppointDetailModel.h"

@interface MEAppointmentStatusCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *reserveNumLbl;


@end

@implementation MEAppointmentStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEAppointDetailModel *)model {
    switch (model.is_use) {//0已预约 1已使用 2未使用
        case 0:
            _statusLbl.text = @"订单已预约";
            break;
        case 1:
            _statusLbl.text = @"订单已使用";
            break;
        case 2:
            _statusLbl.text = @"订单未使用";
            break;
        default:
            break;
    }
    _reserveNumLbl.text = [NSString stringWithFormat:@"订单号码:%@",kMeUnNilStr(model.reserve_sn)];
}

@end
