//
//  MEMakeOrderCell.m
//  志愿星
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMakeOrderCell.h"
#import "MEMessageTextField.h"

const static CGFloat kMEMakeOrderCellMagin = 15;
const static CGFloat kSubTitleWdith = 87;
const static CGFloat kTitleWdith = 92;

@interface MEMakeOrderCell (){
    NSArray *_arrType;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet MEMessageTextField *txMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleWdith;

@end

@implementation MEMakeOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _arrType = MEMakrOrderCellStyleTitle;
    self.selectionStyle = 0;
    // Initialization code
}

//女神卡
- (void)setGirlNumberUIWithTitle:(NSString *)title {
    _txMessage.hidden = NO;
    _lblSubTitle.hidden = YES;
    _consTitleWdith.constant = kTitleWdith;
    _lblTitle.text = title;
    _txMessage.placeholder = @"请填写女神卡号码";
    _txMessage.keyboardType = UIKeyboardTypeNumberPad;
    kMeWEAKSELF
    _txMessage.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 11) {
            str = [str substringWithRange:NSMakeRange(0, 11)];
            strongSelf->_txMessage.text = str;
            if (![MECommonTool isValidPhoneNum:str]) {
                [MECommonTool showMessage:@"女神卡号格式错误" view:kMeCurrentWindow];
            }
            [strongSelf endEditing:YES];
        }
        kMeCallBlock(strongSelf.messageBlock,str);
    };
    _txMessage.returnBlock = ^{
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.returnBlock);
    };
}

- (void)setUIWithType:(MEMakrOrderCellStyle)type model:(NSString *)model{
    _txMessage.hidden = type!=MEMakrOrderCellMessage;
    _lblSubTitle.hidden = type==MEMakrOrderCellMessage;
    _consTitleWdith.constant = type == MEMakrOrderCellMessage?kTitleWdith:(SCREEN_WIDTH - (kSubTitleWdith+(kMEMakeOrderCellMagin * 3)));
    _lblTitle.text = _arrType[type];
    if(type == MEMakrOrderCellMessage){
        kMeWEAKSELF
        _txMessage.text = model;
        if (model.length > 30) {
            _txMessage.font = [UIFont systemFontOfSize:11];
        }else {
            _txMessage.font = [UIFont systemFontOfSize:14];
        }
        _txMessage.contentBlock = ^(NSString *str) {
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.messageBlock,str);
        };
        _txMessage.returnBlock = ^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.returnBlock);
        };
    }else{
        _lblSubTitle.text = model;
    }
}

- (void)setUI {
    _lblSubTitle.hidden = YES;
    _lblTitle.text = @"退款原因：";
    _lblTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    
    _txMessage.placeholder = @"请填写";
    _txMessage.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    kMeWEAKSELF
//    _txMessage.text = model;
    _txMessage.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.messageBlock,str);
    };
    _txMessage.returnBlock = ^{
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.returnBlock);
    };
}

@end
