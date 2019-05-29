//
//  MEMyOrderDetailCell.m
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyOrderDetailCell.h"

@interface MEMyOrderDetailCell (){
    NSArray *_arrTitle;
    NSArray *_arrAppointTitle;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFristBuy;

@end

@implementation MEMyOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _arrTitle = MEOrderSettlmentStyleTitle;
    _arrAppointTitle = MEAppointmentSettlmentStyleTitle;
    // Initialization code
}

- (void)setUIWithModel:(NSString *)title Type:(MEOrderSettlmentStyle)type orderType:(MEOrderStyle)orderType{
    _lblFristBuy.hidden = YES;
    _lblTitle.text = _arrTitle[type];
    if(orderType == MEAllNeedPayOrder && type == MESettlmemtRealPay){
        _lblTitle.text = @"应付金额";
    }
    _lblSubTitle.text = title;
}

- (void)setAppointUIWithModel:(id)title appointType:(MEAppointmentSettlmentStyle)type orderType:(MEAppointmenyStyle)orderType;{
    if(type == MEAppointmentSettlmentFristBuy){
        _lblFristBuy.hidden = NO;
        _lblTitle.hidden = YES;
        _lblSubTitle.hidden = YES;
        _lblFristBuy.text = _arrAppointTitle[type];
    }else{
        _lblFristBuy.hidden = YES;
        _lblTitle.hidden = NO;
        _lblSubTitle.hidden = NO;
        _lblTitle.text = _arrAppointTitle[type];
        _lblSubTitle.text = title;
    }
}

- (void)setUIWithAmount:(NSString *)amount {
    _lblTitle.hidden = YES;
    _lblSubTitle.hidden = YES;
    NSString *fstr = [NSString stringWithFormat:@"退款金额     ¥ %@",kMeUnNilStr(amount)];
    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
    
    _lblFristBuy.textColor = [UIColor colorWithHexString:@"#CA0D0D"];
    _lblFristBuy.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    NSUInteger firstLoc = 0;
    NSUInteger secondLoc = [[faString string] rangeOfString:@"¥"].location;
    
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    [faString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:range];
    _lblFristBuy.attributedText = faString;
}

- (void)setUIWithRefundDetail:(NSString *)desc {
    _lblTitle.hidden = YES;
    _lblSubTitle.hidden = YES;
    _lblFristBuy.text = desc;
    
    _lblFristBuy.textColor = kME999999;
    _lblFristBuy.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
}

@end
