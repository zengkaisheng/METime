//
//  MEShareTool.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShareTool.h"
#import <UShareUI/UShareUI.h>
/*
 MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self]
 shareTool.shareImage =  [UIImage imageNamed:@"home_s"];
 kMeWEAKSELF
 [shareTool showShareView:kShareImageContentType success:^(id data) {
 NSLog(@"分享成功%@",data);
 kMeSTRONGSELF
 [MEShowViewTool showMessage:@"分享成功" view:strongSelf.view];
 } failure:^(NSError *error) {
 NSLog(@"分享失败");
 }];
 
 [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
 if (error) {
 
 } else {
 UMSocialUserInfoResponse *resp = result;
 
 // 授权信息
 NSLog(@"Wechat uid: %@", resp.uid);
 NSLog(@"Wechat openid: %@", resp.openid);
 NSLog(@"Wechat unionid: %@", resp.unionId);
 NSLog(@"Wechat accessToken: %@", resp.accessToken);
 NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
 NSLog(@"Wechat expiration: %@", resp.expiration);
 
 // 用户信息
 NSLog(@"Wechat name: %@", resp.name);
 NSLog(@"Wechat iconurl: %@", resp.iconurl);
 NSLog(@"Wechat gender: %@", resp.unionGender);
 
 // 第三方平台SDK源数据
 NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
 }
 }];
 
 */
@implementation MEShareTool

- (void)showShareView:(kShareContentType)type success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    //显示分享面板
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                [weakSelf shareWithPlatformType:platformType shareTypeIndex:type success:success failure:failure];
    }];
    
}

- (void)showShareView:(kShareContentType)type  platformsTypeBlock:(kMeIndexBlock)platformsTypeBlock success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    //显示分享面板
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [weakSelf shareWithPlatformType:platformType shareTypeIndex:type success:success failure:failure];
    }];
    
}

//分享不同的内容到平台platformType
- (void)shareWithPlatformType:(UMSocialPlatformType)platformType shareTypeIndex:(kShareContentType)type success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    switch (type) {
        case kShareWebPageContentType:
        {
            [self shareWebPageToPlatformType:platformType success:success failure:failure];
        }
        break;
        case kShareTextContentType:
        {
            [self shareTextToPlatformType:platformType success:success failure:failure];
        }
        break;
        case kShareImageContentType:
        {
            [self shareImageToPlatformType:platformType success:success failure:failure];
        }
        break;
        case kShareImageAndTextContentType:
        {
            [self shareImageAndTextToPlatformType:platformType success:success failure:failure];
        }
        break;
        default:
        break;
    }
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
//    if(kMeUnNilStr(self.posterId).length){
//        [MEPublicNetWorkTool postSharePosterWithId:kMeUnNilStr(self.posterId) SuccessBlock:^(ZLRequestResponse *responseObject) {
//            
//        } failure:^(id object) {
//            
//        }];
//    }
    if(kMeUnNilStr(self.articelId).length){
        [MEPublicNetWorkTool postShareArticelWithId:kMeUnNilStr(self.articelId) SuccessBlock:^(ZLRequestResponse *responseObject) {
            kNoticeUnNoticeMessage
        } failure:^(id object) {
            
        }];
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (self.shareTitle) {
        
    }else{
        self.shareTitle = @"ME时代优选";
    }
    if (self.shareDescriptionBody) {
        
    }else{
        self.shareDescriptionBody = @"ME时代优选";
    }
    id image;
    if (self.shareImage) {
        image = self.shareImage;
    }else{
        if(self.shareImgUrl){
            image = self.shareImgUrl;
        }else{
            //self.shareImage = [UIImage imageNamed:@"icon-wgvilogo"];
            image = [UIImage imageNamed:@"icon-wgvilogo"];
        }
    }
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDescriptionBody thumImage:image];
    //设置网页地址
    shareObject.webpageUrl = self.sharWebpageUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            
        }else{
            if (success) {
                success(data);
            }
        }
        //[self alertWithError:error];
    }];
}

//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = self.shareTitle;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            
        }else{
            if (success) {
                success(data);
            }
        }
        //[self alertWithError:error];
    }];
    
}

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if(kMeUnNilStr(self.posterId).length){
        [MEPublicNetWorkTool postSharePosterWithId:kMeUnNilStr(self.posterId) SuccessBlock:^(ZLRequestResponse *responseObject) {
            kNoticeUnNoticeMessage
        } failure:^(id object) {
            
        }];
    }
//    if(kMeUnNilStr(self.articelId).length){
//        [MEPublicNetWorkTool postShareArticelWithId:kMeUnNilStr(self.articelId) SuccessBlock:^(ZLRequestResponse *responseObject) {
//
//        } failure:^(id object) {
//
//        }];
//    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = self.shareImage;
    [shareObject setShareImage:self.shareImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            
        }else{
            if (success) {
                success(data);
            }
        }
    }];
}

//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = self.shareTitle;
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = self.shareImage;
    shareObject.shareImage = self.shareImage;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            
        }else{
            if (success) {
                success(data);
            }
        }
    }];
}
    
@end
