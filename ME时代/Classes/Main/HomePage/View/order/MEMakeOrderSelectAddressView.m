//
//  MEMakeOrderSelectAddressView.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMakeOrderSelectAddressView.h"
#import "MEAddressModel.h"

@interface MEMakeOrderSelectAddressView ()

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consAddressHeight;


@end

@implementation MEMakeOrderSelectAddressView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled  = YES;
    _lblPhone.adjustsFontSizeToFitWidth = YES;
    _lblAddress.adjustsFontSizeToFitWidth = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:ges];
}

- (void)tapView:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_selectAddressBlock);
}

- (void)setUIWithModel:(MEAddressModel *)model{
    _lblName.text = kMeUnNilStr(model.truename);
    _lblPhone.text = kMeUnNilStr(model.telphone);
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.detail_address)];
//    _consAddressHeight.constant = [NSAttributedString heightForAtsWithStr:address font:[UIFont systemFontOfSize:12] width:(SCREEN_WIDTH - 40 -54-5-7-15) lineH:0 maxLine:0];
    _lblAddress.text = address;
}

+ (CGFloat)getViewHeightWithModel:(MEAddressModel *)model{
    CGFloat height = kMEMakeOrderSelectAddressViewHeight-15;
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.detail_address)];
    CGFloat addressHeight = [NSAttributedString heightForAtsWithStr:address font:[UIFont systemFontOfSize:12] width:(SCREEN_WIDTH - 40 -54-5-7-15) lineH:0 maxLine:3];
    addressHeight = addressHeight>15?addressHeight:15;
    return height + addressHeight;
}
@end
