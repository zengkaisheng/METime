//
//  MEOperationTotalListCell.m
//  志愿星
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOperationTotalListCell.h"
#import "MEOperationTotalListModel.h"

@interface MEOperationTotalListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *jobLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;


@end

@implementation MEOperationTotalListCell

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

- (void)setUIWithTotalModel:(MEOperationTotalListModel *)model {
    _jobLbl.text = @"美容师";
    _nameLbl.text = kMeUnNilStr(model.cosmetologist_name);
    if (model.type == 1) {
        _countLbl.text = @"顾客数量";
        _numberLbl.text = [NSString stringWithFormat:@"%@",@(model.customer_num)];
    }else if (model.type == 2) {
        _countLbl.text = @"手工费";
        _numberLbl.text = [NSString stringWithFormat:@"¥%@",@(model.workmanship_charge)];
    }
}

@end
