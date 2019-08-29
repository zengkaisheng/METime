//
//  MEDiagnoseListCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseListCell.h"
#import "MEDiagnoseConsultModel.h"
#import "MEDiagnoseReportModel.h"

@interface MEDiagnoseListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *reportLbl;

@end


@implementation MEDiagnoseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 1);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 5;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithConsultModel:(MEDiagnoseConsultModel *)model {
    _timeLbl.text = [NSString stringWithFormat:@"回复时间：%@",kMeUnNilStr(model.reply_time)];
    _typeLbl.hidden = NO;
    _typeLbl.text = kMeUnNilStr(model.user_type_name);
    _reportLbl.text = kMeUnNilStr(model.answer);
    
}

- (void)setUIWithReportModel:(MEDiagnoseReportModel *)model {
    _timeLbl.text = [NSString stringWithFormat:@"诊断时间：%@",kMeUnNilStr(model.reply_time)];
    _typeLbl.hidden = YES;
    _reportLbl.text = @"诊断反馈";
}

- (void)setUIWithNoReplyModel:(MEDiagnoseConsultModel *)model {
    _timeLbl.text = [NSString stringWithFormat:@"回复时间：%@",kMeUnNilStr(model.reply_time)];
    _typeLbl.hidden = YES;
    _reportLbl.text = kMeUnNilStr(model.problem);
}


@end
