//
//  MEExchangDetailsBottomView.m
//  ME时代
//
//  Created by hank on 2018/10/22.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEExchangDetailsBottomView.h"
#import "MEMidelButton.h"
#import "MEMemberHomeVC.h"
#import "MEMineExchangeDetailVC.h"

@interface MEExchangDetailsBottomView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consPurchaseWdith;
@property (weak, nonatomic) IBOutlet MEMidelButton *btnShare;

@end

@implementation MEExchangDetailsBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    _consPurchaseWdith.constant = 226 * kMeFrameScaleX();
    _btnShare.hidden = ![WXApi isWXAppInstalled];
}

- (IBAction)homeAction:(UIButton *)sender {
    MEMineExchangeDetailVC *detailVC = (MEMineExchangeDetailVC *)[MECommonTool getVCWithClassWtihClassName:[MEMineExchangeDetailVC class] targetResponderView:self];
    if(detailVC){
        detailVC.tabBarController.selectedIndex = 0;
        [detailVC.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)shareWxFriendAction:(UIButton *)sender {
    if([MEUserInfoModel isLogin]){
        [self sharAction];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf sharAction];
        } failHandler:nil];
    }
}

- (void)sharAction{
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    shareTool.sharWebpageUrl = MEIPShare;
    shareTool.shareTitle = @"睁着眼洗的洁面慕斯,你见过吗?";
    shareTool.shareDescriptionBody = @"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
    shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
    
    [shareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession success:^(id data) {
        NSLog(@"分享成功%@",data);
        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
    } failure:^(NSError *error) {
        NSLog(@"分享失败%@",error);
        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
    }];
}

- (IBAction)appointAction:(UIButton *)sender {
    kMeCallBlock(_exchangeBlock);
}

- (IBAction)customAction:(UIButton *)sender {
    kMeCallBlock(self.customBlock);
}


@end
