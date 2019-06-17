//
//  MEFourHomeGoodGoodFilterHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourHomeGoodGoodFilterHeaderView.h"
//#import "METhridHomeVC.h"
#import "MEFourHomeVC.h"
#import "MECoupleMailVC.h"
#import "MECoupleFilterVC.h"
#import "MEChartsVC.h"

@interface MEFourHomeGoodGoodFilterHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHeight;


@end

@implementation MEFourHomeGoodGoodFilterHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat w = (SCREEN_WIDTH - 25)/2;
    CGFloat h = ((w * 86)/175);
    _consHeight.constant = h;
    [self layoutIfNeeded];
}

//排行
- (IBAction)phaction:(UIButton *)sender {
//    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
    if(homevc){
//        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchGoodGoodsType];
        MEChartsVC *vc = [[MEChartsVC alloc] init];
//        vc.titleStr = @"排行榜";
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//超值
- (IBAction)czaction:(UIButton *)sender {
//    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTeHuiType];
        vc.titleStr = @"超值特惠专场";
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//时尚
- (IBAction)ssaction:(UIButton *)sender {
//    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchShiShangType];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//99
- (IBAction)niceaction:(UIButton *)sender {
//    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearch99BuyType];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//今日热卖
- (IBAction)todayaction:(UIButton *)sender {
//    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
    if(homevc){
//        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTopBuyType];
        MEChartsVC *vc = [[MEChartsVC alloc] init];
        vc.isHot = YES;
//        vc.titleStr = @"今日热卖专场";
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//好卷分类
- (IBAction)sortaction:(UIButton *)sender {
//    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    MEFourHomeVC *homevc = (MEFourHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFourHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleFilterVC *vc = [[MECoupleFilterVC alloc]init];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

+ (CGFloat)getCellHeight{
    CGFloat w = (SCREEN_WIDTH - 25)/2;
    CGFloat h = ((w * 86)/175);
    CGFloat height = (h * 3)+8 + 42;
    return height;
}

@end
