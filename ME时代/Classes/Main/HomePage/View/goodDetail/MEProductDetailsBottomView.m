//
//  MEProductDetailsBottomView.m
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEProductDetailsBottomView.h"
//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MEHomePageVC.h"
#import "MEStoreHomeVC.h"
#import "MEMidelButton.h"
#import "MEGoodDetailModel.h"
#import "MEGroupProductDetailVC.h"

@interface MEProductDetailsBottomView(){
    NSString *_paoductIdEndoceStr;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consPurchaseWdith;
@property (weak, nonatomic) IBOutlet MEMidelButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;


@end

@implementation MEProductDetailsBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    _consPurchaseWdith.constant = 226 * kMeFrameScaleX();
    _btnShare.hidden = ![WXApi isWXAppInstalled];
}

- (void)setModel:(MEGoodDetailModel *)model {
    _model = model;
//    if (self.model.product_type == 17) {
//        _btnShare.hidden = YES;
//    }else {
//        _btnShare.hidden = ![WXApi isWXAppInstalled];
//    }
    _btnShare.hidden = ![WXApi isWXAppInstalled];
}

- (IBAction)homeAction:(UIButton *)sender {
    if (self.isGroup) {
        MEGroupProductDetailVC *detailVC = (MEGroupProductDetailVC *)[MECommonTool getVCWithClassWtihClassName:[MEGroupProductDetailVC class] targetResponderView:self];
        if(detailVC){
            detailVC.tabBarController.selectedIndex = 0;
            [detailVC.navigationController popToRootViewControllerAnimated:YES];
        }
    }else {
        METhridProductDetailsVC *detailVC = (METhridProductDetailsVC *)[MECommonTool getVCWithClassWtihClassName:[METhridProductDetailsVC class] targetResponderView:self];
        if(detailVC){
            detailVC.tabBarController.selectedIndex = 0;
            [detailVC.navigationController popToRootViewControllerAnimated:YES];
            //        MEHomePageVC *homeVC = (MEHomePageVC *)[MECommonTool getClassWtihClassName:[MEHomePageVC class] targetVC:detailVC];
            //        if(homeVC){
            //            [detailVC.navigationController popToViewController:homeVC animated:YES];
            //        }else{
            //            MEStoreHomeVC *shomeVC = (MEStoreHomeVC *)[MECommonTool getClassWtihClassName:[MEStoreHomeVC class] targetVC:detailVC];
            //            if(shomeVC){
            //                [detailVC.navigationController popToViewController:shomeVC animated:YES];
            //            }
            //        }
        }
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
    NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
    baseUrl = [@"http" stringByAppendingString:baseUrl];
    if (self.isGroup) {
        
        //https://test.meshidai.com/dist/newAuth.html?id=7&uid=xxx
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@collage/newAuth.html?id=%ld&uid=%@&inviteCode=%@",baseUrl,(long)_model.product_id,kMeUnNilStr(kCurrentUser.uid),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = self.model.title;
        shareTool.shareDescriptionBody = self.model.title;
        shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.image_url]]];
        
        [shareTool showShareView:kShareWebPageContentType success:^(id data) {
            [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
            [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
        } failure:^(NSError *error) {
            [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
        }];
    }else {
        if(self.is_clerk_share){
            if(kCurrentUser.client_type == MEClientTypeClerkStyle){
                [self getShareEncode];
            }else{
                //http://test.meshidai.com/productShare/newAuth.html?uid=88034&goodsid=71&inviteCode=22 新
                //https://msd.meshidai.com/meAuth.html?entrance=productShare&uid=%@&goodsid=%@&seckilltime=%@&command=%@
                shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@productShare/newAuth.html?uid=%@&goodsid=%@&seckilltime=%@&command=%@&inviteCode=%@",baseUrl,kMeUnNilStr(kCurrentUser.uid),kMeUnNilStr(_productId),kMeUnNilStr(self.seckilltime),@"",[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
                NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
                
                shareTool.shareTitle = kMeUnNilStr(_model.title); //@"睁着眼洗的洁面慕斯,你见过吗?";
                shareTool.shareDescriptionBody = kMeUnNilStr(_model.desc).length?kMeUnNilStr(_model.desc):kMeUnNilStr(_model.title);//@"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
                shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
                [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                    [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                    [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
                } failure:^(NSError *error) {
                    [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
                }];
            }
        }else{
            
            //https://msd.meshidai.com/meAuth.html?entrance=productShare&uid=%@&goodsid=%@&seckilltime=%@&command=%@
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@productShare/newAuth.html?uid=%@&goodsid=%@&seckilltime=%@&command=%@&inviteCode=%@",baseUrl,kMeUnNilStr(kCurrentUser.uid),kMeUnNilStr(_productId),kMeUnNilStr(self.seckilltime),@"",[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            NSLog(@":%@",shareTool.sharWebpageUrl);
            
            shareTool.shareTitle = kMeUnNilStr(_model.title); //@"睁着眼洗的洁面慕斯,你见过吗?";
            shareTool.shareDescriptionBody = kMeUnNilStr(_model.desc).length?kMeUnNilStr(_model.desc):kMeUnNilStr(_model.title);//@"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
            shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
            } failure:^(NSError *error) {
                [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
            }];
        }
    }
}

- (void)getShareEncode{
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    if(kMeUnNilStr(_paoductIdEndoceStr).length){

        NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
        baseUrl = [@"http" stringByAppendingString:baseUrl];
        
        //https://msd.meshidai.com/meAuth.html?entrance=productShare&uid=%@&goodsid=%@&seckilltime=%@&command=%@
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@productShare/newAuth.html?uid=%@&goodsid=%@&seckilltime=%@&command=%@&inviteCode=%@",baseUrl,kMeUnNilStr(kCurrentUser.uid),kMeUnNilStr(_productId),kMeUnNilStr(self.seckilltime),kMeUnNilStr(_paoductIdEndoceStr),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = kMeUnNilStr(_model.title); //@"睁着眼洗的洁面慕斯,你见过吗?";
        shareTool.shareDescriptionBody = kMeUnNilStr(_model.desc).length?kMeUnNilStr(_model.desc):kMeUnNilStr(_model.title);//@"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
        shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
        [shareTool showShareView:kShareWebPageContentType success:^(id data) {
            [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
            [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
        } failure:^(NSError *error) {
            [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
            
        }];
    }else{
        kMeWEAKSELF
        [MEPublicNetWorkTool postGoodsEncodeWithProductrId:self.productId successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_paoductIdEndoceStr = kMeUnNilStr(responseObject.data[@"share_text"]);

            NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
            baseUrl = [@"http" stringByAppendingString:baseUrl];
            
            //https://msd.meshidai.com/meAuth.html?entrance=productShare&uid=%@&goodsid=%@&seckilltime=%@&command=%@
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@productShare/newAuth.html?uid=%@&goodsid=%@&seckilltime=%@&command=%@&inviteCode=%@",baseUrl,kMeUnNilStr(kCurrentUser.uid),kMeUnNilStr(strongSelf->_productId),kMeUnNilStr(strongSelf.seckilltime),kMeUnNilStr(strongSelf->_paoductIdEndoceStr),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            
            shareTool.shareTitle = kMeUnNilStr(strongSelf->_model.title); //@"睁着眼洗的洁面慕斯,你见过吗?";
            shareTool.shareDescriptionBody = kMeUnNilStr(strongSelf->_model.desc).length?kMeUnNilStr(strongSelf->_model.desc):kMeUnNilStr(strongSelf->_model.title);//@"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
            shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
            } failure:^(NSError *error) {
                [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
                
            }];
        } failure:^(id object) {
            
        }];
    }
}


- (IBAction)shareWxCrial:(UIButton *)sender {
//    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
//    shareTool.sharWebpageUrl = @"http://www.baidu.com";
//    shareTool.shareTitle = @"test";
//    shareTool.shareDescriptionBody = @"test";
//    shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
//
//    [shareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine success:^(id data) {
//        NSLog(@"分享成功%@",data);
//        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
//    } failure:^(NSError *error) {
//        NSLog(@"分享失败%@",error);
//        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
//    }];
}

- (IBAction)addShopcart:(UIButton *)sender {
    kMeCallBlock(self.addShopcartBlock);
}

- (IBAction)buyAction:(UIButton *)sender {
    kMeCallBlock(self.buyBlock);
}

- (IBAction)customAction:(UIButton *)sender {
    kMeCallBlock(self.customBlock);
}

- (IBAction)giftAction:(UIButton *)sender {
    kMeCallBlock(self.buyBlock);
}

- (void)setIsGroup:(BOOL)isGroup {
    _isGroup = isGroup;
    _btnShare.hidden = ![WXApi isWXAppInstalled];
}

@end
