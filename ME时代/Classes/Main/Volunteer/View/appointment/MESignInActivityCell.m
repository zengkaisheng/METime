//
//  MESignInActivityCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESignInActivityCell.h"
#import "MESignInActivityModel.h"

@interface MESignInActivityCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *signInTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *signOutTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;


@end

@implementation MESignInActivityCell

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

- (void)setUIWithModel:(MESignInActivityModel *)model {
    _titleLbl.text = kMeUnNilStr(model.title);
    _activityTimeLbl.text = [NSString stringWithFormat:@"活动时间：%@",kMeUnNilStr(model.activity_start_time)];
    _signInTimeLbl.text = [NSString stringWithFormat:@"签到时间 %@",kMeUnNilStr(model.start_time)];
    _signOutTimeLbl.text = [NSString stringWithFormat:@"签退时间 %@",kMeUnNilStr(model.start_time).length>0?kMeUnNilStr(model.start_time):@"无"];
    _statusLbl.text = kMeUnNilStr(model.status_name);
    if (model.status == 1) {
        _statusLbl.backgroundColor = [UIColor colorWithHexString:@"#38CFB0"];
    }else {
        _statusLbl.backgroundColor = [UIColor colorWithHexString:@"#B7B7B7"];
    }
}

@end
