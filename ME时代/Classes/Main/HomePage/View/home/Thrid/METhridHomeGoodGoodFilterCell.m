//
//  METhridHomeGoodGoodFilterCell.m
//  ME时代
//
//  Created by hank on 2019/4/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeGoodGoodFilterCell.h"
#import "METhridHomeVC.h"
#import "MECoupleMailVC.h"
#import "MECoupleFilterVC.h"

@interface METhridHomeGoodGoodFilterCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHeight;


@end

@implementation METhridHomeGoodGoodFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    CGFloat w = (SCREEN_WIDTH - 25)/2;
    CGFloat h = ((w * 86)/175);
    _consHeight.constant = h;
    [self layoutIfNeeded];
    // Initialization code
}

//排行
- (IBAction)phaction:(UIButton *)sender {
    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchGoodGoodsType];
        vc.titleStr = @"排行榜";
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//超值
- (IBAction)czaction:(UIButton *)sender {
    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTeHuiType];
        vc.titleStr = @"超值特惠专场";
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//时尚
- (IBAction)ssaction:(UIButton *)sender {
    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchShiShangType];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//99
- (IBAction)niceaction:(UIButton *)sender {
    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearch99BuyType];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//今日热卖
- (IBAction)todayaction:(UIButton *)sender {
    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTopBuyType];
        vc.titleStr = @"今日热卖专场";
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

//好卷分类
- (IBAction)sortaction:(UIButton *)sender {
    METhridHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleFilterVC *vc = [[MECoupleFilterVC alloc]init];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}

+ (CGFloat)getCellHeight{
    CGFloat w = (SCREEN_WIDTH - 25)/2;
    CGFloat h = ((w * 86)/175);
    CGFloat height = (h * 3)+8;
    return height;
}



@end
