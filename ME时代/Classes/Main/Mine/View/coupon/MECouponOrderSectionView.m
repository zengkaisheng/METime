//
//  MECouponOrderSectionView.m
//  ME时代
//
//  Created by hank on 2019/2/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MECouponOrderSectionView.h"


@interface MECouponOrderSectionView ()
{
}
@property (weak, nonatomic) IBOutlet UIView *viewForLine;
@property (weak, nonatomic) IBOutlet UIView *viewForPddLine;
@property (weak, nonatomic) IBOutlet UIView *viewForJdLine;



@property (weak, nonatomic) IBOutlet UIButton *btnPinduoduo;
@property (weak, nonatomic) IBOutlet UIButton *btnJd;
@property (weak, nonatomic) IBOutlet UIButton *btnTb;



@end

@implementation MECouponOrderSectionView
- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)pinduoduoAction:(UIButton *)sender {
    if(sender.selected == YES){
        return;
    }
    [self reloadUIWIthType:MECouponOrderSectionViewPinduoduoType];
    kMeCallBlock(_selectBlock,MECouponOrderSectionViewPinduoduoType);
}

- (IBAction)jdAction:(UIButton *)sender {
    if(sender.selected == YES){
        return;
    }
    [self reloadUIWIthType:MECouponOrderSectionViewJDType];
    kMeCallBlock(_selectBlock,MECouponOrderSectionViewJDType);
}

- (IBAction)tbAction:(UIButton *)sender {
    if(sender.selected == YES){
        return;
    }
    [self reloadUIWIthType:MECouponOrderSectionViewTBType];
    kMeCallBlock(_selectBlock,MECouponOrderSectionViewTBType);
}


- (void)setType:(MECouponOrderSectionViewType)type{
    _type = type;
    [self reloadUIWIthType:type];
}

- (void)reloadUIWIthType:(MECouponOrderSectionViewType)type{
    if(type==MECouponOrderSectionViewPinduoduoType){
        _btnPinduoduo.selected = YES;
        _viewForPddLine.hidden = NO;
        
        
        _viewForJdLine.hidden = YES;
        _viewForLine.hidden = YES;
        _btnTb.selected = NO;
        _btnJd.selected = NO;
    }else if(type==MECouponOrderSectionViewJDType){
        _btnJd.selected = YES;
        _viewForJdLine.hidden = NO;
        
        _viewForPddLine.hidden = YES;
        _viewForLine.hidden = YES;
        _btnTb.selected = NO;
        _btnPinduoduo.selected = NO;
    }else{
        _btnTb.selected = YES;
        _viewForLine.hidden = NO;
        
        _viewForPddLine.hidden = YES;
        _viewForJdLine.hidden = YES;
        _btnJd.selected = NO;
        _btnPinduoduo.selected = NO;
    }
}


@end
