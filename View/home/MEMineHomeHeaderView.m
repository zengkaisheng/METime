//
//  MEMineHomeHeaderView.m
//  ME时代
//
//  Created by Hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineHomeHeaderView.h"
#import "MEMyOrderVC.h"
#import "MEMidelButton.h"
#import "MEMineHomeVC.h"
#import "MEMineSetVC.h"


@interface MEMineHomeHeaderView()

@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblNamWdith;
@property (weak, nonatomic) IBOutlet UIButton *btnSet;
@property (weak, nonatomic) IBOutlet UIButton *btnAllOrder;


@end

@implementation MEMineHomeHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_viewLine addBottedlineWidth:1 lineColor:[UIColor whiteColor]];
//    _lblLevel.hidden = YES;
//    _btnAddPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    _btnAddPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)reloadUIWithUserInfo{
    [_btnSet setContentMode:UIViewContentModeRight];
    [_btnAllOrder setContentMode:UIViewContentModeRight];
    _lblName.text = kMeUnNilStr(kCurrentUser.name);
    kSDLoadImg(_imgPic, kMeUnNilStr(kCurrentUser.header_pic));
    if(kMeUnNilStr(kCurrentUser.mobile).length){
        _btnAddPhone.hidden = YES;
        _lblNamWdith.constant = SCREEN_WIDTH - (26 + 90 + 26 +15);
        _lblLevel.text = [NSString stringWithFormat:@"手机:%@",kMeUnNilStr(kCurrentUser.mobile)];
//        switch (kCurrentUser.user_type) {
//            case 1:{
//                //C
//                _lblLevel.text =@"售后中心";
//            }
//                break;
//            case 2:{
//                //C
//                _lblLevel.text =@"营销中心";
//            }
//                break;
//            case 4:{
//                //C
//                _lblLevel.text =@"普通会员";
//            }
//                break;
//            case 3:{
//                //B
//                _lblLevel.text =@"体验店";
//            }
//                break;
//            case 5:{
//                //clerk
//                _lblLevel.text =@"店员";
//            }
//                break;
//            default:{
//                _lblLevel.text =@"未知身份";
//            }
//                break;
//        }
    }else{
        _btnAddPhone.hidden = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [kMeUnNilStr(kCurrentUser.name) boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        _lblNamWdith.constant = size.width >63?65:(size.width + 5);
    }
}

- (void)clearUIWithUserInfo{
    _lblName.text = @"";
    _lblLevel.text = @"";
    kSDLoadImg(_imgPic, @"");
    _btnAddPhone.hidden = YES;
}

- (IBAction)allOrderAction:(UIButton *)sender {
    MEMineHomeVC *home = (MEMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}

- (IBAction)needPayAction:(MEMidelBigImageButton *)sender {
    MEMineHomeVC *home = (MEMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllNeedPayOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}

- (IBAction)diveryAction:(MEMidelBigImageButton *)sender {
    MEMineHomeVC *home = (MEMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllNeedDeliveryOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}
- (IBAction)reviceAction:(MEMidelBigImageButton *)sender {
    MEMineHomeVC *home = (MEMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllNeedReceivedOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}
- (IBAction)finishAction:(MEMidelBigImageButton *)sender {
    MEMineHomeVC *home = (MEMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEMineHomeVC class] targetResponderView:self];
    MEMyOrderVC *orderVC = [[MEMyOrderVC alloc]initWithType:MEAllFinishOrder];
    if(home){
        [home.navigationController pushViewController:orderVC animated:YES];
    }
}

- (IBAction)setAction:(UIButton *)sender {
    MEMineHomeVC *home = (MEMineHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEMineHomeVC class] targetResponderView:self];
    MEMineSetVC *setVC = [[MEMineSetVC alloc]init];
    setVC.exitBlock = ^{
        home.tabBarController.selectedIndex = 0;
    };
    if(home){
        [home.navigationController pushViewController:setVC animated:YES];
    }
}

- (IBAction)addPhoneAction:(UIButton *)sender {
    kMeCallBlock(_addPhoneBlock);
}


@end
