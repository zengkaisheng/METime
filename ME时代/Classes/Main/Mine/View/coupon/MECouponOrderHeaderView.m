//
//  MECouponOrderHeaderView.m
//  ME时代
//
//  Created by hank on 2018/12/27.
//  Copyright © 2018 hank. All rights reserved.
//

#import "MECouponOrderHeaderView.h"
#import "MECouponDetailModel.h"

@interface MECouponOrderHeaderView(){
    
}
//可提现
@property (weak, nonatomic) IBOutlet UILabel *lblCanUserCommsion;
//已结算
@property (weak, nonatomic) IBOutlet UILabel *lblUsedCommsion;
//未结算
@property (weak, nonatomic) IBOutlet UILabel *lblNotUseCommsion;
@property (weak, nonatomic) IBOutlet UILabel *lblGetingCommsion;

@end

@implementation MECouponOrderHeaderView

- (void)setUIWithModel:(MECouponDetailModel *)model{
    _lblCanUserCommsion.text = [MECommonTool changeformatterWithFen:@(model.commission_amount)];
    _lblUsedCommsion.text = [MECommonTool changeformatterWithFen:@(model.finish_promotion_amount)];
    _lblNotUseCommsion.text = [MECommonTool changeformatterWithFen:@(model.unfinish_promotion_amount)];
    _lblGetingCommsion.text= [MECommonTool changeformatterWithFen:@(model.withdrawal)];
}

- (void)setLianTongUIWithModdel:(MECouponDetailModel *)model {
    _lblCanUserCommsion.text = [NSString stringWithFormat:@"%@",@(model.commission_amount)];
    _lblUsedCommsion.text = [NSString stringWithFormat:@"%@",@(model.finish_promotion_amount)];
    _lblNotUseCommsion.text = [NSString stringWithFormat:@"%@",@(model.unfinish_promotion_amount)];
    _lblGetingCommsion.text= [NSString stringWithFormat:@"%@",@(model.withdrawal)];
}

- (IBAction)touchAction:(UIButton *)sender {
    kMeCallBlock(_block);
}

@end
