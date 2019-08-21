//
//  MECustomerTypeCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerTypeCell.h"

@interface MECustomerTypeCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end

@implementation MECustomerTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 1);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 2;
    _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 2;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithTitle:(NSString *)title {
    _titleLbl.text = title;
}

- (IBAction)deleteAction:(id)sender {
    kMeCallBlock(_deleteBlock);
}

@end
