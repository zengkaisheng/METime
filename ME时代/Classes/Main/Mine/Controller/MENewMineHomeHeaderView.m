//
//  MENewMineHomeHeaderView.m
//  ME时代
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MENewMineHomeHeaderView.h"
#import "MENewMineHomeVC.h"
#import "MEMidelButton.h"
#import "MEMyOrderVC.h"
#import "MEMineSetVC.h"

@interface MENewMineHomeHeaderView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSetTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBtnW;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@property (weak, nonatomic) IBOutlet UILabel *lblLeve;

@end

@implementation MENewMineHomeHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_viewLine addBottedlineWidth:2 lineColor:[UIColor whiteColor]];
    CGFloat w = (SCREEN_WIDTH - 60)/4;
    _consBtnW.constant = w;
    _consSetTopMargin.constant = kMeStatusBarHeight+10;
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
    _lblTel.text = [NSString stringWithFormat:@"手机:%@",kMeUnNilStr(kCurrentUser.mobile)];
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
