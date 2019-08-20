//
//  MEExportDiagnoseRemarkCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEExportDiagnoseRemarkCell.h"
#import "MEBlockTextField.h"
#import "MEBlockTextView.h"

@interface MEExportDiagnoseRemarkCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet MEBlockTextField *phoneTF;
@property (weak, nonatomic) IBOutlet MEBlockTextView *remarkTV;


@end

@implementation MEExportDiagnoseRemarkCell

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
    
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _remarkTV.returnKeyType = UIReturnKeyDone;
    kMeWEAKSELF
    _phoneTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf->_phoneBlock,str);
    };
    
    _remarkTV.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf->_remarkBlock,str);
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
