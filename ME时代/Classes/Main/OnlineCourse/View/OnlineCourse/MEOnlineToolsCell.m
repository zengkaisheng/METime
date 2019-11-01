//
//  MEOnlineToolsCell.m
//  志愿星
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineToolsCell.h"

@interface MEOnlineToolsCell ()

@property (weak, nonatomic) IBOutlet UIButton *runDataButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *runDataBtnConsHeight;

@end


@implementation MEOnlineToolsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithHiddenRunData:(BOOL)hidenRunData{
    _runDataButton.layer.shadowOffset = CGSizeMake(0, 1);
    _runDataButton.layer.shadowOpacity = 1;
    _runDataButton.layer.shadowRadius = 3;
    _runDataButton.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _runDataButton.layer.masksToBounds = false;
    _runDataButton.layer.cornerRadius = 5;
    _runDataButton.clipsToBounds = false;
    
    if (hidenRunData) {
        _runDataButton.hidden = YES;
        _runDataBtnConsHeight.constant = 0.0;
    }else {
        _runDataButton.hidden = NO;
        _runDataBtnConsHeight.constant = 78.0;
    }
}

- (IBAction)runDataAction:(id)sender {
    kMeCallBlock(_selectedBlock,1);
}
- (IBAction)messageManageAction:(id)sender {
    kMeCallBlock(_selectedBlock,2);
}
- (IBAction)salesMessageAction:(id)sender {
    kMeCallBlock(_selectedBlock,3);
}
- (IBAction)customerAppointmentAction:(id)sender {
    kMeCallBlock(_selectedBlock,4);
}
- (IBAction)customerConsumeAction:(id)sender {
    kMeCallBlock(_selectedBlock,5);
}

@end
