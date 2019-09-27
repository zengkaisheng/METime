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
#import "MEMineHomeMuneModel.h"

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

@property (weak, nonatomic) IBOutlet UIButton *changeStatusBtn;
//我的订单
@property (weak, nonatomic) IBOutlet UIView *orderView;
//商家
@property (weak, nonatomic) IBOutlet UIView *businessView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeStatusBtnConsWidth;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *needPayBtn;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *deliveryBtn;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *receiveBtn;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *finishBtn;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *refundBtn;


@end

@implementation MENewMineHomeCodeHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_viewLine addBottedlineWidth:2 lineColor:[UIColor whiteColor]];
    CGFloat w = (SCREEN_WIDTH - 60)/4;
    _consBtnW.constant = w;
    _consSetTopMargin.constant = kMeStatusBarHeight+10;
    
    if (IS_iPhone5S) {
//        _changeStatusBtnConsWidth.constant = 79;
//        [_changeStatusBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
//        _changeStatusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
//        _changeStatusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 0);

        [_needPayBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_receiveBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_deliveryBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_refundBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    }else {
//        _changeStatusBtnConsWidth.constant = 109;
//        [_changeStatusBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        _changeStatusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
//        _changeStatusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);

        [_needPayBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_receiveBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_deliveryBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_refundBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
    CGRect bounds = self.invationBGView.layer.bounds;
    CGFloat bgViewWidth = [UIScreen mainScreen].bounds.size.width - 50;
    bounds.size.width = bgViewWidth;
    
    CAGradientLayer *layer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:74/255.0 green:74/255.0 blue:72/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0].CGColor] locations:@[@(0.1f),@(1.0f)] frame:bounds];
    [self.invationBGView.layer insertSublayer:layer atIndex:0];
    
    
    CAGradientLayer *btnLayer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:252/255.0 green:213/255.0 blue:138/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:227/255.0 green:163/255.0 blue:40/255.0 alpha:1.0].CGColor] locations:@[@(0.0),@(1.0)] frame:self.cpBtn.layer.bounds];
    [self.cpBtn.layer insertSublayer:btnLayer atIndex:0];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-30, 37) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 37);
    maskLayer.path = maskPath.CGPath;
    _businessView.layer.mask = maskLayer;
}

- (CAGradientLayer *)getLayerWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors locations:(NSArray *)locations frame:(CGRect)frame {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = startPoint;//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = endPoint;//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = colors;
    layer.locations = locations;//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = frame;
    return layer;
}

- (void)reloadUIWithUserInfo{
    _lblName.text = kMeUnNilStr(kCurrentUser.name);

    NSString *invationStr = [NSString stringWithFormat:@"邀请码：%@",kMeUnNilStr(kCurrentUser.invite_code)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:invationStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:205/255.0 green:177/255.0 blue:126/255.0 alpha:1.0]}];
    self.invationLbl.attributedText = string;
    
    kSDLoadImg(_imgPic, kMeUnNilStr(kCurrentUser.header_pic));
    _LblTel.text = [NSString stringWithFormat:@"手机:%@",kMeUnNilStr(kCurrentUser.mobile)];
    switch (kCurrentUser.client_type ) {
        case MEClientTypeClerkStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"我的等级:店员"];
        }
            break;
        case MEClientBTypeStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"我的等级:体验中心"];
        }
            break;
        case MEClientCTypeStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"我的等级:会员"];
        }
            break;
        case MEClientOneTypeStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"我的等级:售后中心"];
        }
            break;
        case MEClientTwoTypeStyle:{
            _lblLeve.text = [NSString stringWithFormat:@"我的等级:营销中心"];
        }
            break;
        default:
            _lblLeve.text = @"";
            break;
    }
    
//    if (kCurrentUser.user_type == 4) {
//        _changeStatusBtn.hidden = YES;
//    }else {
//        _changeStatusBtn.hidden = NO;
//    }
    NSString *status = [kMeUserDefaults objectForKey:kMENowStatus];
     _businessView.hidden = YES;
    if ([status isEqualToString:@"customer"]) {
       
        _orderView.hidden = NO;
//        [_changeStatusBtn setTitle:@"切换商家版" forState:UIControlStateNormal];
    }else if ([status isEqualToString:@"business"]) {
//        _businessView.hidden = NO;
        _orderView.hidden = NO;
//        [_changeStatusBtn setTitle:@"切换用户版" forState:UIControlStateNormal];
    }
    
    for (id obj in _bottomView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }
    CGFloat btnWidth = (SCREEN_WIDTH-60)/self.orderList.count;
    for (int i = 0; i < self.orderList.count; i++) {
        MEMineHomeMuneChildrenModel *model = self.orderList[i];
        UIButton *btn = [self createBtnWithTitle:kMeUnNilStr(model.name) image:kMeUnNilStr(model.icon) tag:model.path.integerValue frame:CGRectMake(btnWidth*i, 0, btnWidth, 85)];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(model.icon)]]]];
        imgV.frame = CGRectMake((btnWidth*i+btnWidth/2-10), 15, 25, 25);
        [_bottomView addSubview:imgV];
        [_bottomView addSubview:btn];
    }
}

- (void)btnDidClick:(UIButton *)sender {
    kMeCallBlock(self.indexBlock,sender.tag);
}

- (UIButton *)createBtnWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag frame:(CGRect)frame {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kMEblack forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    if (IS_iPhone5S) {
        [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    }
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(15, 0, -15, 0);
    btn.tag = tag;
    btn.frame = frame;
    return btn;
}

- (void)clearUIWithUserInfo{
    _lblName.text = @"";
    _LblTel.text = @"";
    _lblLeve.text = @"";
    kSDLoadImg(_imgPic, @"");
}
- (IBAction)copyBtnAction:(id)sender {
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    
    pastboard.string = kMeUnNilStr(kCurrentUser.invite_code);
    [MECommonTool showMessage:@"复制成功" view:kMeCurrentWindow];
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
- (IBAction)changeStatus:(id)sender {
    kMeCallBlock(_changeStatus);
}

@end
