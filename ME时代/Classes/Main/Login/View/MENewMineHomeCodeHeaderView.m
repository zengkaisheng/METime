//
//  MENewMineHomeCodeHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/6/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewMineHomeCodeHeaderView.h"
#import "MENewMineHomeVC.h"
#import "MEMidelButton.h"
#import "MEMyOrderVC.h"
#import "MEMineSetVC.h"
#import "MERefundOrderListVC.h"

@interface MENewMineHomeCodeHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSetTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBtnW;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@property (weak, nonatomic) IBOutlet UILabel *lblLeve;
@property (weak, nonatomic) IBOutlet UIView *invationBGView;
@property (weak, nonatomic) IBOutlet UILabel *invationLbl;
@property (weak, nonatomic) IBOutlet UIButton *cpBtn;


@end

@implementation MENewMineHomeCodeHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_viewLine addBottedlineWidth:2 lineColor:[UIColor whiteColor]];
    CGFloat w = (SCREEN_WIDTH - 60)/4;
    _consBtnW.constant = w;
    _consSetTopMargin.constant = kMeStatusBarHeight+10;
    
    
    self.invationBGView.backgroundColor = [UIColor colorWithRed:236/255.0 green:198/255.0 blue:125/255.0 alpha:1.0];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(25,132,325*kMeFrameScaleX(),48);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:74/255.0 green:74/255.0 blue:72/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.1f),@(1.0f)];
    [self.invationBGView.layer addSublayer:gl];
    self.invationBGView.layer.cornerRadius = 8;
    
    
    
    self.cpBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    CAGradientLayer *gl1 = [CAGradientLayer layer];
    gl1.frame = CGRectMake(246*kMeFrameScaleX(),10,68,24);
    gl1.startPoint = CGPointMake(0, 0);
    gl1.endPoint = CGPointMake(1, 1);
    gl1.colors = @[(__bridge id)[UIColor colorWithRed:252/255.0 green:213/255.0 blue:138/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:227/255.0 green:163/255.0 blue:40/255.0 alpha:1.0].CGColor];
    gl1.locations = @[@(0.0),@(1.0)];
    [self.cpBtn.layer addSublayer:gl1];
    self.cpBtn.layer.cornerRadius = 12;
}

- (void)reloadUIWithUserInfo{
    _lblName.text = kMeUnNilStr(kCurrentUser.name);
    
    //    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:kMeUnNilStr(kCurrentUser.name)];
    //
    //    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    //    // 表情图片
    //    attchImage.image = [UIImage imageNamed:@"icon_chengzhangzhi"];
    //    // 设置图片大小
    //    attchImage.bounds = CGRectMake(0, 0, 15, 15);
    //    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    //    [attriStr insertAttributedString:stringImage atIndex:0];
    //
    //    _lblName.attributedText = attriStr;

    NSString *invationStr = @"邀请ID：GZ6MPZ";
//    [NSString stringWithFormat:@"邀请ID：%@",kMeUnNilStr(kCurrentUser.invite_code)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:invationStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:205/255.0 green:177/255.0 blue:126/255.0 alpha:1.0]}];
    self.invationLbl.attributedText = string;
    
    kSDLoadImg(_imgPic, kMeUnNilStr(kCurrentUser.header_pic));
    _LblTel.text = [NSString stringWithFormat:@"手机:%@",kMeUnNilStr(kCurrentUser.mobile)];
    switch (kCurrentUser.client_type ) {
        case MEClientTypeClerkStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"当前等级:店员"];
        }
            break;
        case MEClientBTypeStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"当前等级:体验中心"];
        }
            break;
        case MEClientCTypeStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"当前等级:会员"];
        }
            break;
        case MEClientOneTypeStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"当前等级:售后中心"];
        }
            break;
        case MEClientTwoTypeStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"当前等级:营销中心"];
        }
            break;
        default:
            _lblLeve.text = @"";
            break;
    }
}

- (void)clearUIWithUserInfo{
    _lblName.text = @"";
    _LblTel.text = @"";
    _lblLeve.text = @"";
    kSDLoadImg(_imgPic, @"");
}
- (IBAction)copyBtnAction:(id)sender {
}

- (IBAction)allOrderAction:(UIButton *)sender {
    MENewMineHomeVC *home = (MENewMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}

- (IBAction)needPayAction:(MEMidelMiddelImageButton *)sender {
    MENewMineHomeVC *home = (MENewMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllNeedPayOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}

- (IBAction)diveryAction:(MEMidelMiddelImageButton *)sender {
    MENewMineHomeVC *home = (MENewMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllNeedDeliveryOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}
- (IBAction)reviceAction:(MEMidelMiddelImageButton *)sender {
    MENewMineHomeVC *home = (MENewMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllNeedReceivedOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}
- (IBAction)finishAction:(MEMidelMiddelImageButton *)sender {
    MENewMineHomeVC *home = (MENewMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllFinishOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}
- (IBAction)returnAction:(id)sender {
    MENewMineHomeVC *home = (MENewMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    MERefundOrderListVC *refundOrderVC = [[MERefundOrderListVC alloc] init];
    if(home){
        [home.navigationController pushViewController:refundOrderVC animated:YES];
    }
}

- (IBAction)setAction:(UIButton *)sender {
    MENewMineHomeVC *home = (MENewMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    MEMineSetVC *setVC = [[MEMineSetVC alloc]init];
    setVC.exitBlock = ^{
        home.tabBarController.selectedIndex = 0;
    };
    if(home){
        [home.navigationController pushViewController:setVC animated:YES];
    }
}

@end
