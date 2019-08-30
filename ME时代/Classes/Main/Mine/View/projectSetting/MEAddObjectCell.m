//
//  MEAddObjectCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddObjectCell.h"
#import "MEBlockTextField.h"
#import "MEProjectSettingListModel.h"

@interface MEAddObjectCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet MEBlockTextField *nameTF;
@property (weak, nonatomic) IBOutlet MEBlockTextField *chargeTF;

@end


@implementation MEAddObjectCell

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

- (void)setUIWithModel:(MEProjectSettingListModel *)model {
    _nameTF.text = kMeUnNilStr(model.object_name);
    _chargeTF.text = model.money>0?[NSString stringWithFormat:@"%@",@(model.money)]:@"";
    
    _nameTF.contentBlock = ^(NSString *str) {
        model.object_name = str;
    };
    _chargeTF.contentBlock = ^(NSString *str) {
        model.money = [str integerValue];
    };
}

@end

