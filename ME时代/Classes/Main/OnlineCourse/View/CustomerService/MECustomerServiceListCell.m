//
//  MECustomerServiceListCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerServiceListCell.h"
#import "MECustomerFileListModel.h"

@interface MECustomerServiceListCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

@end


@implementation MECustomerServiceListCell

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

- (void)setUIWithModel:(MECustomerFileListModel *)model {
    _nameLbl.text = kMeUnNilStr(model.name);
    _phoneLbl.text = kMeUnNilStr(model.phone);
}

- (IBAction)checkFileAction:(id)sender {
    kMeCallBlock(self.tapBlock,1);
}
- (IBAction)deleteFileAction:(id)sender {
    kMeCallBlock(self.tapBlock,0);
}

@end
