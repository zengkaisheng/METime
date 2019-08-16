//
//  MEQuestionHeaderCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEQuestionHeaderCell.h"
#import "MEDiagnoseQuestionModel.h"

@interface MEQuestionHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MEQuestionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 1);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = false;
}

- (void)setUIWithDiagnosisModel:(MEDiagnosisSubModel *)model {
    _titleLbl.text = kMeUnNilStr(model.classify_name);
    _titleLbl.font = [UIFont systemFontOfSize:18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}
- (IBAction)downBtnAction:(id)sender {
}

@end
