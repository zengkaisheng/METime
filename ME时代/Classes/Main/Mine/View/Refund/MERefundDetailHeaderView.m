//
//  MERefundDetailHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/5/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERefundDetailHeaderView.h"
#import "MERefundDetailModel.h"

@interface MERefundDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *refundStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *refundTypeLbl;    //返回哪里
@property (weak, nonatomic) IBOutlet UILabel *refundAmountLbl;

@end

@implementation MERefundDetailHeaderView

- (void)setUIWithModel:(MERefundDetailModel *)model {
    switch (model.refund_status) {//1、退款中 2、退款成功 3、退款失败
        case 1:
        {
            self.refundStatusLbl.text = @"申请退款中";
            self.refundTypeLbl.hidden = YES;
            self.refundAmountLbl.hidden = YES;
            self.amountTitleLbl.text = @"你的服务单已申请成功，等待审核中";
            self.amountLbl.hidden = YES;
        }
            break;
        case 2:
        {
            self.refundStatusLbl.text = @"退款成功";
            self.refundTypeLbl.hidden = NO;
            self.refundAmountLbl.hidden = NO;
            self.amountTitleLbl.text = @"退款总金额";
            self.amountLbl.hidden = NO;
        }
            break;
        case 3:
        {
            self.refundStatusLbl.text = @"退款失败";
            self.refundTypeLbl.hidden = YES;
            self.refundAmountLbl.hidden = YES;
            self.amountTitleLbl.text = model.error_desc;
            self.amountLbl.hidden = YES;
        }
            break;
        default:
            break;
    }
    self.timeLbl.text = model.updated_at;
    
    NSString *fstr = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.refund_money).floatValue)];
    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
    NSUInteger secondLoc = [[faString string] rangeOfString:@"."].location;
    
    NSRange range1 = NSMakeRange(secondLoc, fstr.length - secondLoc);
    [faString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:12] range:range1];
    self.amountLbl.attributedText = faString;
    
    NSMutableAttributedString *faStr = [[NSMutableAttributedString alloc]initWithString:fstr];
    NSUInteger secLoc = [[faStr string] rangeOfString:@"."].location;
    
    NSRange range2 = NSMakeRange(secLoc, fstr.length - secondLoc);
    [faStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:12] range:range2];
    self.refundAmountLbl.attributedText = faStr;
    
}

@end
