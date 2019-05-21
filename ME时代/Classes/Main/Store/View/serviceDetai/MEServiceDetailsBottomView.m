//
//  MEServiceDetailsBottomView.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEServiceDetailsBottomView.h"
#import "MEServiceDetailsVC.h"
#import "MEStoreHomeVC.h"
#import "MEHomePageVC.h"
#import "MEMidelButton.h"

@interface MEServiceDetailsBottomView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consPurchaseWdith;
@property (weak, nonatomic) IBOutlet MEMidelButton *btnShare;

@end

@implementation MEServiceDetailsBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    _consPurchaseWdith.constant = 226 * kMeFrameScaleX();
    _btnShare.hidden = ![WXApi isWXAppInstalled];
}

- (IBAction)homeAction:(UIButton *)sender {
    MEServiceDetailsVC *detailVC = (MEServiceDetailsVC *)[MECommonTool getVCWithClassWtihClassName:[MEServiceDetailsVC class] targetResponderView:self];
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

//- (IBAction)shareWxFriendAction:(UIButton *)sender {
//
//}
//
//- (IBAction)shareWxCrial:(UIButton *)sender {
//
//}

- (IBAction)appointAction:(UIButton *)sender {
    kMeCallBlock(_appointMentBlock);
}

- (IBAction)customAction:(UIButton *)sender {
    kMeCallBlock(self.customBlock);
}

@end
