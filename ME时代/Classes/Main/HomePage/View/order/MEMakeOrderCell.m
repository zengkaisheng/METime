//
//  MEMakeOrderCell.m
//  ME时代
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

- (void)setUIWithType:(MEMakrOrderCellStyle)type model:(NSString *)model{
    _txMessage.hidden = type!=MEMakrOrderCellMessage;
    _lblSubTitle.hidden = type==MEMakrOrderCellMessage;
    _consTitleWdith.constant = type == MEMakrOrderCellMessage?kTitleWdith:(SCREEN_WIDTH - (kSubTitleWdith+(kMEMakeOrderCellMagin * 3)));
    _lblTitle.text = _arrType[type];
    if(type == MEMakrOrderCellMessage){
        kMeWEAKSELF
        _txMessage.text = model;
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

@end
