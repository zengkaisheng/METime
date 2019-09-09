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

@interface MEAddObjectCell ()<UITextFieldDelegate>

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
    
    _nameTF.returnKeyType = _chargeTF.returnKeyType = UIReturnKeyDone;
    _nameTF.delegate = self;
    _chargeTF.delegate = self;
    _chargeTF.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEProjectSettingListModel *)model {
    _nameTF.text = kMeUnNilStr(model.object_name);
    _chargeTF.text = model.money>0?[NSString stringWithFormat:@"%@",@(model.money)]:@"";
    kMeWEAKSELF
    _nameTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 10) {
            str = [str substringWithRange:NSMakeRange(0, 10)];
            strongSelf->_nameTF.text = str;
            [strongSelf->_nameTF endEditing:YES];
        }
        model.object_name = str;
    };
    
    _chargeTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 6) {
            str = [str substringWithRange:NSMakeRange(0, 6)];
            strongSelf->_chargeTF.text = str;
            [strongSelf->_chargeTF endEditing:YES];
        }
        model.money = [str integerValue];
    };
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

@end

