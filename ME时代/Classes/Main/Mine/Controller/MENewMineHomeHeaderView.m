//
//  MENewMineHomeHeaderView.m
//  志愿星
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MENewMineHomeHeaderView.h"
#import "MENewMineHomeVC.h"
#import "MEMidelButton.h"
#import "MEMyOrderVC.h"
#import "MEMineSetVC.h"
#import "MERefundOrderListVC.h"
#import "MEMineHomeMuneModel.h"
#import "MEMyInfoVC.h"

@interface MENewMineHomeHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSetTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBtnW;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@property (weak, nonatomic) IBOutlet UILabel *lblLeve;
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIView *businessView;
@property (weak, nonatomic) IBOutlet UIButton *changeStatusBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeStatusBtnConsWidth;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *needPayBtn;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *finishBtn;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *receiveBtn;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *deliveryBtn;
@property (weak, nonatomic) IBOutlet MEMidelMiddelImageButton *refundBtn;

@property (weak, nonatomic) IBOutlet UIImageView *durationImageV;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UIButton *changeInfoBtn;

@end

@implementation MENewMineHomeHeaderView

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
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-30, 57) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 57);
    maskLayer.path = maskPath.CGPath;
    _businessView.layer.mask = maskLayer;
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
    
    kSDLoadImg(_imgPic, kMeUnNilStr(kCurrentUser.header_pic));
    _durationLbl.text = [NSString stringWithFormat:@"信用时数: %@",kMeUnNilStr(kCurrentUser.duration)];
    _durationImageV.hidden = _durationLbl.hidden = kCurrentUser.is_volunteer==1?NO:YES;
    _changeInfoBtn.hidden = kCurrentUser.is_volunteer==1?NO:YES;
    if (kCurrentUser.is_volunteer == 1) {
        _lblLeve.text = kMeUnNilStr(kCurrentUser.signature);
    }else {
        _lblLeve.text = [NSString stringWithFormat:@"手机:%@",kMeUnNilStr(kCurrentUser.mobile)];
    }
    switch (kCurrentUser.client_type ) {
        case MEClientTypeClerkStyle:{
            _lblTel.text = [NSString stringWithFormat:@"我的等级:店员"];
        }
            break;
        case MEClientBTypeStyle:{
            _lblTel.text = [NSString stringWithFormat:@"我的等级:体验中心"];
        }
            break;
        case MEClientCTypeStyle:{
            _lblTel.text = [NSString stringWithFormat:@"我的等级:会员"];
        }
            break;
        case MEClientOneTypeStyle:{
            _lblTel.text = [NSString stringWithFormat:@"我的等级:售后中心"];
        }
            break;
        case MEClientTwoTypeStyle:{
            _lblTel.text = [NSString stringWithFormat:@"我的等级:营销中心"];
        }
            break;
        default:
            _lblTel.text = @"";
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
    _lblTel.text = @"";
    _lblLeve.text = @"";
    kSDLoadImg(_imgPic, @"");
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
- (IBAction)changeInfoAction:(id)sender {
    MENewMineHomeVC *home = (MENewMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MENewMineHomeVC class] targetResponderView:self];
    MEMyInfoVC *infoVC = [[MEMyInfoVC alloc] init];
    if(home){
        [home.navigationController pushViewController:infoVC animated:YES];
    }
}

@end
