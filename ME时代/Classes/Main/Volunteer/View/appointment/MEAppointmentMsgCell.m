//
//  MEAppointmentMsgCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAppointmentMsgCell.h"

@interface MEAppointmentMsgCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *leftLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightLbl;


@end


@implementation MEAppointmentMsgCell

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

-(void)setUIWithTitle:(NSString *)title content:(NSString *)content {
    _leftLbl.text = title;
    if (kMeUnNilStr(content).length > 0) {
        _rightLbl.hidden = NO;
        _rightLbl.text = content;
    }else {
        _rightLbl.hidden = YES;
    }
}

@end
