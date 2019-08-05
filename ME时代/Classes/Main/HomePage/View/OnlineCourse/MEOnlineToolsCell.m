//
//  MEOnlineToolsCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineToolsCell.h"

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
- (IBAction)messageManageAction:(id)sender {
    kMeCallBlock(_selectedBlock,1);
}
- (IBAction)salesMessageAction:(id)sender {
    kMeCallBlock(_selectedBlock,2);
}
- (IBAction)customerAppointmentAction:(id)sender {
    kMeCallBlock(_selectedBlock,3);
}
- (IBAction)customerConsumeAction:(id)sender {
    kMeCallBlock(_selectedBlock,4);
}

@end
