//
//  MEPublicNetWorkTool.m
//  ME时代
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEPublicNetWorkTool.h"
#import <Qiniu/QiniuSDK.h>
//相关参数model
#import "MEShoppingCartAttrModel.h"
#import "MEAddAddressAttrModel.h"
#import "MEMakeOrderAttrModel.h"
#import "MEShoppingCartMakeOrderAttrModel.h"
#import "MEWxAuthModel.h"
#import "MEAppointAttrModel.h"
#import "MEWithdrawalParamModel.h"
#import "MEBStoreMannagerEditModel.h"
#import "MEStoreApplyParModel.h"
#import "MEDynamicGoodApplyModel.h"
#import "MEAddGoodModel.h"
#import "MEAiCustomerDataModel.h"

@implementation MEPublicNetWorkTool

/*********************************************/
#pragma makr - ai
//设置用户标签
+ (void)postgetCustomerGetLabelWithLabel:(NSString*)label uid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonaisetMemberLabel);
    MBProgressHUD *HUD = [self commitWithHUD:@"保存中"];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(uid),@"label":kMeUnNilStr(label)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//获取标签列表
+ (void)postgetCustomerGetLabelWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonaigetLabel);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

//实际跟进阶段   更新
+ (void)postgetCustomerupdateFollowWithUid:(NSString*)uid follow_up:(NSString*)follow_up SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonaiupdateFollow);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(uid),@"follow_up":kMeUnNilStr(follow_up)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//修改客户资料
+ (void)postgetCustomerDetailWithModel:(MEAiCustomerDataModel*)model SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonaiupdateDetail);
    NSDictionary *dic = [model mj_keyValues];
    MBProgressHUD *HUD = [self commitWithHUD:@"修改客户资料"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//客户详情(雷达)
+ (void)postgetCustomerDetailWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonaigetCustomerDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取客户资料"];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(uid)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

//客户详情(雷达)
+ (void)postgetMemberBehaviorWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonaigetMemberDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(uid)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postgetIPcommonclerknotFollowUpMemberWithUid:(NSString*)uid type:(NSInteger)type SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonaifollowUpMember);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(uid),@"type":@(type)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

//雷达--行为
+ (void)postgetMemberBehaviorWithtype:(NSString*)type SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonaigetMemberBehavior);
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(kCurrentUser.uid),@"day_type":kMeUnNilStr(type)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

/*********************************************/
#pragma makr - GoodMannger
//
+ (void)postgetStorePowerWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonggetStorePower);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

+ (void)postgetStoreGoodsDetailWithProduct_id:(NSString*)pid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonStoreGoodsDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中"];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"id":kMeUnNilStr(pid)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

+ (void)postgetDelStoreGoodsWithProduct_id:(NSString*)pid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonDelStoreGoods);
    MBProgressHUD *HUD = [self commitWithHUD:@"删除中"];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"product_id":kMeUnNilStr(pid)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

+ (void)postgetGoodSpecNameWithSuccessBlock:(RequestResponse)successBlock  failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonggetSpecName);
        MBProgressHUD *HUD = [self commitWithHUD:@"获取规格"];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

+ (void)postcommonAddOrEditGoodsWithParModel:(MEAddGoodModel *)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(model.token),
                          @"list_order":kMeUnNilStr(model.list_order),
                          @"title":kMeUnNilStr(model.title),
                          @"desc":kMeUnNilStr(model.desc),
                          @"market_price":kMeUnNilStr(model.market_price),
                          @"money":kMeUnNilStr(model.money),
                          @"postage":kMeUnNilStr(model.postage),
                          
                          @"store_product_type":@(model.store_product_type),
                          @"ratio_after_sales":@(model.ratio_after_sales),
                          @"ratio_marketing":@(model.ratio_marketing),
                          @"ratio_store":@(model.ratio_store),
                          @"images":kMeUnNilStr(model.images),
                          @"images_hot":kMeUnNilStr(model.images_hot),
                          @"image_rec":kMeUnNilStr(model.image_rec),
                          
                          @"group_num":kMeUnNilStr(model.group_num),
                          @"over_time":kMeUnNilStr(model.over_time),
                          @"red_packet":kMeUnNilStr(model.red_packet),
                          @"start_time":kMeUnNilStr(model.start_time),
                          @"end_time":kMeUnNilStr(model.end_time),
                          
                          @"keywords":kMeUnNilStr(model.keywords),
                          @"state":@(model.state),
                          @"tool":@(model.tool),
                          @"is_new":@(model.is_new),
                          @"is_hot":@(model.is_hot),
                          @"is_recommend":@(model.is_recommend),
                          @"is_clerk_share":@(model.is_clerk_share),
                          
                          @"restrict_num":kMeUnNilStr(model.restrict_num),
                          @"category_id":kMeUnNilStr(model.category_id),
                          @"content":kMeUnNilStr(model.content),
                          @"product_id":kMeUnNilStr(model.product_id),
                          @"spec_json":kMeUnNilStr(model.spec_json),
                          @"spec_name":kMeUnNilStr(model.spec_name),
                          @"warehouse":@"1"
                          };
    NSLog(@"%@",model.spec_json);
    NSLog(@"%@",model.spec_name);
    
    NSLog(@"%@",dic);
    NSString *url = kGetApiWithUrl(MEIPcommonAddOrEditGoods);
    MBProgressHUD *HUD = [self commitWithHUD:@"提交中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

/*********************************************/
#pragma makr - xunweishi
+ (void)postXunweishiApplyWithParModel:(MEDynamicGoodApplyModel *)model images:(NSString*)images successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"true_name":kMeUnNilStr(model.true_name),
                          @"phone":kMeUnNilStr(model.phone),
                          @"goods_name":kMeUnNilStr(model.goods_name),
                          @"goods_detail":kMeUnNilStr(model.goods_detail),
                          @"price":kMeUnNilStr(model.price),
                          @"images":images,
                          @"token":kMeUnNilStr(model.token),
                          };
    NSLog(@"%@",dic);
    NSString *url = kGetApiWithUrl(MEIPcommongXunweishiApply);
    MBProgressHUD *HUD = [self commitWithHUD:@"提交中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

/*********************************************/

/*********************************************/
#pragma makr - BRAND
//能力排行
+ (void)postgetAbilityRankWithStoreId:(NSString*)storeId SuccessBlock:(RequestResponse)successBlock  failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommongAbilityRank);
    //    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"store_id":kMeUnNilStr(storeId)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        //        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        //        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}
//数据分析
+ (void)postgetStoreDatAnalysisWithDate:(NSString *)date storeId:(NSString*)storeId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommongStoreDatAnalysis);
    //    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"date":kMeUnNilStr(date),@"store_id":kMeUnNilStr(storeId)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        //        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        //        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}
//总览
+ (void)postgetStoreOverviewWithDate:(NSString *)date SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommongStoreOverview);
//    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"date":kMeUnNilStr(date)} strUrl:url success:^(ZLRequestResponse *responseObject) {
//        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
//        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

/*********************************************/
#pragma makr - 公共
//获取七牛云TOKEN
+ (void)postgetQiuNiuTokkenWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPgetQiniuToken);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:@{} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
        kMeCallBlock(failure,error);
    }];
}

//上传图片
+ (void)postQiNiuUpFileWithToken:(NSString *)token filePath:(NSString *)filePath successBlock:(kMeObjBlock)successBlock failure:(kMeObjBlock)failure{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
//    NSData *imageData = UIImagePNGRepresentation(image);
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if(info.ok){
            kMeCallBlock(successBlock,resp);
        }
        else{
            kMeCallBlock(failure,resp);
        }
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
    }
                option:uploadOption];
//    [upManager putData:imageData key:nil token:token
//              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        if(info.ok){
//            kMeCallBlock(successBlock,resp);
//        }
//        else{
//            kMeCallBlock(failure,resp);
//        }
//        NSLog(@"info ===== %@", info);
//        NSLog(@"resp ===== %@", resp);
//    } option:uploadOption];
}


/*********************************************/
#pragma makr - IM
+ (void)postUserInfoByTlsWithTls_id:(NSString *)tls_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"tls_id":kMeUnNilStr(tls_id),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommongUserInfoByTls);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        [HUD hideAnimated:YES];
    }];
}

/*********************************************/

/*********************************************/
#pragma makr - 动态

//上传图片
+ (void)posUploadImagesWithFile:(UIImage *)image successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonUploadImages);
    NSData *imageData = UIImagePNGRepresentation(image);
    [THTTPManager postWithUrlStr:url parameter:@{@"token":kMeUnNilStr(kCurrentUser.token)} data:imageData showProgressView:nil success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id object) {
        kMeCallBlock(failure,object);
    }];
}

//B Clerk s发表评论
+ (void)postdynamicVotingCommentWithConten:(NSString *)content images:(NSString*)images successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"content":kMeUnNilStr(content),@"token":kMeUnNilStr(kCurrentUser.token),@"images":images};
    NSString *url = kGetApiWithUrl(MEIPcommongetGetVotingComment);
    MBProgressHUD *HUD = [self commitWithHUD:@"发表中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//删除
+ (void)postdynamicDelDynamicWithdynamicId:(NSString *)dynamic_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"id":kMeUnNilStr(dynamic_id),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommongetDynamiDelDynamic);
    MBProgressHUD *HUD = [self commitWithHUD:@"删除中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//点赞
+ (void)postdynamicPraiselWithdynamicId:(NSString *)dynamic_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"dynamic_id":kMeUnNilStr(dynamic_id),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommongetDynamicpraise);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//评论
+ (void)postdynamicCommentdynamicId:(NSString *)dynamic_id content:(NSString*)content successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"dynamic_id":kMeUnNilStr(dynamic_id),@"token":kMeUnNilStr(kCurrentUser.token),@"content":kMeUnNilStr(content)};
    NSString *url = kGetApiWithUrl(MEIPcommongetDynamiccommentt);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

/*********************************************/
#pragma makr - JD
+ (void)postJDPromotionUrlGenerateWithUid:(NSString *)uid materialUrl:(NSString*)materialUrl couponUrl:(NSString*)couponUrl successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"materialUrl":kMeUnNilStr(materialUrl),@"link":kMeUnNilStr(couponUrl)};
    if(kMeUnNilStr(uid).length){
        dic = @{@"materialUrl":kMeUnNilStr(materialUrl),@"link":kMeUnNilStr(couponUrl),@"member_id":kMeUnNilStr(uid)};
    }
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    NSString *url = kGetApiWithUrl(MEIPcommondJDgoodsPromotionUrlGenerate);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

/*********************************************/
#pragma makr - pinduoduo

+ (void)postGetPinduoduoCommondPoductWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"sort_type":@"20",@"pageSize":@"10"};
    NSString *url = kGetApiWithUrl(MEIPcommonduoduokeGetgetGoodsList);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

//佣金祥情
+ (void)postGetPinduoduoBrokerageDetailBaseWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonduoduokeGetBrokerageDetailBase);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

+ (void)postPinDuoduoGoodsDetailWithGoodsId:(NSString *)goodsId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"goods_id_list":[NSString stringWithFormat:@"[%@]",kMeUnNilStr(goodsId)],
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonduoduokeGetgetGoodsInfo);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//多多进宝推广链接生成
+ (void)postPromotionUrlGenerateWithUid:(NSString *)uid goods_id_list:(NSString*)goods_id_list SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"goods_id_list":kMeUnNilStr(goods_id_list)};
    if(kMeUnNilStr(uid).length){
        dic = @{@"member_id":kMeUnNilStr(uid),
                @"goods_id_list":kMeUnNilStr(goods_id_list)
                };
    }
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    NSString *url = kGetApiWithUrl(MEIPcommonduoduokegoodsPromotionUrlGenerate);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
/*********************************************/

/*********************************************/

#pragma makr - taobao

//查找用户渠道
+ (void)postShareTaobaokeGetMemberRelationWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *urlApi = kGetApiWithUrl(MEIPcommonTaobaokecheckMemberRelation);
    [THTTPManager postWithParameter:dic strUrl:urlApi success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}
//获取淘宝渠道备案URL
+ (void)postShareTaobaokeGetInviterUrlWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *urlApi = kGetApiWithUrl(MEIPcommonTaobaokecheckgetInviterUrl);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:urlApi success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


//获取淘宝客Banner
+ (void)postAgetTbkBannerWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"tool":@"1",
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonTaobaokeGetgetTbkBanner);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

//推广券信息查询
+ (void)postCoupleTbkCouponGetWithActivity_id:(NSString *)activity_id item_id:(NSString*)item_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"activity_id":kMeUnNilStr(activity_id),@"item_id":kMeUnNilStr(item_id)};
    NSString *url = kGetApiWithUrl(MEIPcommonTaobaokeGetTbkCouponGet);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

//通用物料搜索API
+ (void)postCoupledgMaterialOptionalWithType:(MECouponSearchType)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"type":@(type),@"page":@"1",@"pageSize":@"6"};
    NSString *url = kGetApiWithUrl(MEIPcommonTaobaokeGetDgMaterialOptional);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

+ (void)postShareTaobaokeGetTpwdWithTitle:(NSString *)title url:(NSString*)url logo:(NSString*)logo successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"tool":@"ios",@"text":kMeUnNilStr(title),@"logo":kMeUnNilStr(logo),@"url":kMeUnNilStr(url),@"uid":kMeUnNilStr(kCurrentUser.uid)};
    NSString *urlApi = kGetApiWithUrl(MEIPcommonTaobaokeGetGetTpwd);
    MBProgressHUD *HUD = [self commitWithHUD:@"生成口令中"];
    [THTTPManager postWithParameter:dic strUrl:urlApi success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//淘口令
+ (void)postTaobaokeGetTpwdWithTitle:(NSString *)title url:(NSString*)url logo:(NSString*)logo successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"tool":@"ios",@"text":kMeUnNilStr(title),@"logo":kMeUnNilStr(logo),@"url":kMeUnNilStr(url)};
    NSString *urlApi = kGetApiWithUrl(MEIPcommonTaobaokeGetGetTpwd);
    MBProgressHUD *HUD = [self commitWithHUD:@"生成口令中"];
    [THTTPManager postWithParameter:dic strUrl:urlApi success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//卷详情
+ (void)postCoupleDetailWithProductrId:(NSString *)productrId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    //    NSString *url = [NSString stringWithFormat:@"http://api.dataoke.com/index.php?r=port/index&appkey=58de5a1fe2&v=2&id=%@",kMeUnNilStr(productrId)];
    //    MBProgressHUD *HUD = [self commitWithHUD:@""];
    //    [THTTPManager orgialGetWithUrlStr:url parameter:@{} success:^(NSDictionary *dic) {
    //        [HUD hideAnimated:YES];
    //        kMeCallBlock(successBlock,dic);
    //    } failure:^(id object) {
    //        [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
    //        kMeCallBlock(failure,object);
    //    }];
    NSDictionary *dic = @{@"tool":@"ios",@"num_iids":kMeUnNilStr(productrId)};
    NSString *url = kGetApiWithUrl(MEIPcommonTaobaokeGetGoodsInfo);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}
+ (void)postAddressTaobaokeGetCategoryWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonTaobaokeGetCategory);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
/*********************************************/


/*********************************************/
#pragma makr - gift
+ (void)postAgetGiftBannerWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"tool":@"1",
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGetGiftBanner);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}


/*********************************************/
#pragma makr - couple

/*********************************************/

/*********************************************/
#pragma makr - B&Clerk share
+ (void)postGoodsEncodeWithProductrId:(NSString *)productrId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),@"product_id":kMeUnNilStr(productrId)};
    NSString *url = kGetApiWithUrl(MEIPcommonGoodsEncode);
    MBProgressHUD *HUD = [self commitWithHUD:@"生成分享口令中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGoodsEncodeWithStr:(NSString *)str successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"share_text":kMeUnNilStr(str)};
    NSString *url = kGetApiWithUrl(MEIPcommonGoodsDecode);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            //            ZLRequestResponse *res = (ZLRequestResponse*)error;
            //            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            //            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

/*********************************************/



/*********************************************/
#pragma makr - B deal
+ (void)postGetBstatisticsWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonstatistics);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//我的佣金
+ (void)postMyBrokerageWithType:(MEClientTypeStyle)type memberId:(NSString *)memberId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = kMeUnNilStr(kCurrentUser.token);
    if(type == MEClientBTypeStyle){
        dic[@"memberId"] = kMeUnNilStr(memberId);
    }
    NSString *url = kGetApiWithUrl(MEIPcommonMyBrokerage);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


/*********************************************/

/*********************************************/
#pragma makr - Withdrawal

+ (void)postDestoonFinanceCashWithAttrModel:(MEWithdrawalParamModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSMutableDictionary *dic = [attrModel mj_keyValues];
    NSLog(@"%@",dic);
    NSString *url = kGetApiWithUrl(MEIPcommondestoonFinanceCash);
    MBProgressHUD *HUD = [self commitWithHUD:@"申请提现中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"申请成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
/***************************************/


/***************************************/
#pragma mark - clerk

//设置门店店员分佣比例
+ (void)postClerkCommissionPercentWithissetClerk:(BOOL)isset ratio:(NSString*)ratio successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),@"isset_clerk_commission_ratio":@(isset),@"clerk_commission_ratio":kMeUnNilStr(ratio)};
    NSString *url = kGetApiWithUrl(MEIPcommonsetClerkCommissionPercent);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"设置成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//获取店员系统设置分佣比例、及本店的设置
+ (void)postClerkCommissionPercentrWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommongetClerkCommissionPercent);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//删除店员
+ (void)postClerkToMemberWithmemberId:(NSString *)memberId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),@"memberId":kMeUnNilStr(memberId)};
    NSString *url = kGetApiWithUrl(MEIPcommonClerkToMember);
    MBProgressHUD *HUD = [self commitWithHUD:@"删除中"];
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)posMemberToClerkWithmemberId:(NSString *)memberId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),@"memberId":kMeUnNilStr(memberId)};
    NSString *url = kGetApiWithUrl(MEIPcommonMemberToClerk);
    MBProgressHUD *HUD = [self commitWithHUD:@"升级中"];
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


/***************************************/

/***************************************/
#pragma mark - Article
//访问用户详情
+ (void)postVistorUserInfoWithuserId:(NSString *)userId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(userId)};
    NSString *url = kGetApiWithUrl(MEIPcommonVistorUserInfo);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取用户详情"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//访问统计
+ (void)postGetAccessWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonGetAccess);
    MBProgressHUD *HUD = [self commitWithHUD:@"刷新中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postSetIntentioUserId:(NSString *)userId intentio:(NSString *)intentio SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),@"id":kMeUnNilStr(userId),@"intentio":kMeUnNilStr(intentio)};
    NSString *url = kGetApiWithUrl(MEIPcommonSetIntentioUser);
    MBProgressHUD *HUD = [self commitWithHUD:@"设置中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGetAccessUserWithIntention:(NSInteger)intention successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    switch (intention) {
        case 0:{
            dic = @{@"token":kMeUnNilStr(kCurrentUser.token),@"page":@"1"};
        }
            break;
        case 1:{
            dic = @{@"token":kMeUnNilStr(kCurrentUser.token),@"is_intention":@"2",@"page":@"1"};
        }
            break;
        case 2:{
            dic =  @{@"token":kMeUnNilStr(kCurrentUser.token),@"is_intention":@"1",@"page":@"1"};
        }
            break;
        default:
            dic = @{};
            break;
    }
    NSString *url = kGetApiWithUrl(MEIPcommonGetAccess);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//MEIPcommonGetAccessUser

//获取文章分类
+ (void)postArticleClassWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonGetArticleClass);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postArticleClassWithId:(NSString *)aid successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"article_id":kMeUnNilStr(aid),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonFindArticle);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postShareArticelWithId:(NSString *)aid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"article_id":aid,@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonShareAricel);
    //    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        //        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postCountArticleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonCountArticlel);
    //    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        //        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}


/***************************************/

/***************************************/

#pragma mark - Poster
//获取海报分类
+ (void)postPostersClassWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonGetPostersClass);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postSharePosterWithId:(NSString *)posters_id SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"posters_id":posters_id,@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonSharePoster);
    //    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        //        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postDelSharePosterWithId:(NSString *)shareId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"id":shareId,@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonDelSharePosters);
    MBProgressHUD *HUD = [self commitWithHUD:@"删除中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


/***************************************/

#pragma mark - Custom

+ (void)postGetCustomIdWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPAppUserGetCustomer);
    MBProgressHUD *HUD = [self commitWithHUD:@"请稍后,正在为您分配客服"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGetCustomerGetUserInfoWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"customer_id":kMeUnNilStr(uid),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPCustomerGetUserInfo);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGetUserGetUserInfoWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"uid":kMeUnNilStr(uid),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPUserGetUserInfo);
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

#pragma mark - HomePage

//审核状态
+ (void)postcommonredeemgetStatusWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonredeemgetStatus);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取审核状态"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//兑换信息
+ (void)postGetredeemcodeInfoWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"id":@"1",@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonredeemcodeinfo);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
        [HUD hideAnimated:YES];
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//添加兑换
+ (void)postGetredeemcodeaddCodeWithImage:(NSString*)image SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"image":kMeUnNilStr(image),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonredeemcodeaddCode);
    MBProgressHUD *HUD = [self commitWithHUD:@"上传中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"上传成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//获取APP首页标题
+ (void)postGetappThridHomeGetAppHomeTitleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonGetAppHomeTitle);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

//app第三版商业热门产品
+ (void)postGetappThridHomePagHotGoodWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonappYThirdHomeHotGood);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}


//app获取店铺信息
+ (void)postGetappHomePageDataWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPcommonappHomePageData);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

//获取秒杀商品
+ (void)postThridHomegetSeckillGoodsWithSeckillTime:(NSString*)time SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"product_position":@"3",@"seckill_time":kMeUnNilStr(time),@"page":@"1",@"pageSize":@"6"};
    NSString *url = kGetApiWithUrl(MEIPcommonGetgetSeckillGoods);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//获取秒杀时间
+ (void)postThridHomeGetSeckillTimeSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonGetgetSeckillTime);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

//获取2.0首页数据
+ (void)postThridHomeStyleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"tool":@"1"
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGetThridHomeBase);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

//获取首页推荐产品(2019-04-30)
+ (void)postThridHomehomegetRecommendWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonhomegetRecommend);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
//        if([error isKindOfClass:[ZLRequestResponse class]]){
//            ZLRequestResponse *res = (ZLRequestResponse*)error;
//            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
//        }else{
//            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
//        }
        kMeCallBlock(failure,error);
    }];
}
//获取推荐产品和抢购产品
+ (void)postThridHomeRecommendAndSpreebuyWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonhomegetRecommendAndSpreebuy);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        //        if([error isKindOfClass:[ZLRequestResponse class]]){
        //            ZLRequestResponse *res = (ZLRequestResponse*)error;
        //            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        //        }else{
        //            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        //        }
        kMeCallBlock(failure,error);
    }];
}

//获取通知消息
+ (void)postGetMessageWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"tool":@"1"
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGetMessage);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postActivityWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"tool":@"1"
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGetActivity);
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}
+ (void)postMystyleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"tool":@"1"
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGetMystyle);
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}


+ (void)postAdWithPosition_id:(NSInteger)position_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"position_id":@(position_id),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonAdGetAd);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postAdWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"tool":@"1"
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGetBanner);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}


#pragma mark - Store

+ (void)postCreatAppointWithAttrModel:(MEAppointAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSMutableDictionary *dic = [attrModel mj_keyValues];
    [dic removeObjectForKey:@"storeName"];
    [dic removeObjectForKey:@"isFromStroe"];
    NSLog(@"%@",dic);
    NSString *url = kGetApiWithUrl(MEIPcommonCreateReserve);
    MBProgressHUD *HUD = [self commitWithHUD:@"预约中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"预约成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


+ (void)postDelAppointWithReserveSn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"reserve_sn":kMeUnNilStr(reserve_sn),@"token":kMeUnNilStr(kCurrentUser.token)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonDeleteReserve);
    MBProgressHUD *HUD = [self commitWithHUD:@"删除预约中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"删除成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//预约完成B端
+ (void)postFinishReserveWithReserveSn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"reserve_sn":kMeUnNilStr(reserve_sn),@"token":kMeUnNilStr(kCurrentUser.token)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonfinishReserve);
    MBProgressHUD *HUD = [self commitWithHUD:@"预约完成中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"已完成"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//预约取消B端
+ (void)postCancelReserveWithReserveSn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"reserve_sn":kMeUnNilStr(reserve_sn),@"token":kMeUnNilStr(kCurrentUser.token)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommoncancelReserve);
    MBProgressHUD *HUD = [self commitWithHUD:@"预约取消中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"已取消"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


#pragma mark - Goods

+ (void)postGoodFilterWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPGoodsGetCategory);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
        [HUD hideAnimated:YES];
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postRecommendProductWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"tool":@"3"};
    NSString *url = kGetApiWithUrl(MEIPRecommendProduct);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postRushGoodWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"tool":@"1"};
    NSString *url = kGetApiWithUrl(MEIPGoodsRush);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGoodsTypeWithArticleCategoryId:(NSUInteger)ArticleCategoryId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"article_category_id":@(ArticleCategoryId),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGoodsGoodsType);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postHomeRecommendWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"other":@"is_recommend"
                          ,@"uid":kMeUnNilStr(kCurrentUser.uid)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonFindGoods);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGoodsListTopWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"other":@"is_hot",
                          @"uid":kMeUnNilStr(kCurrentUser.uid)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonFindGoods);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}


+ (void)postGoodsListWithType:(MEGoodsTypeNetStyle)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"type":@(type),
                          @"uid":kMeUnNilStr(kCurrentUser.uid)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGoodsGetGoodsList);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postHomeNewGoodsListWithType:(NSString *)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"other":kMeUnNilStr(type),
                          @"uid":kMeUnNilStr(kCurrentUser.uid)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonFindGoods);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGoodsDetailWithGoodsId:(NSInteger)goodsId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"goodsId":@(goodsId),
                          @"uid":kMeUnNilStr(kCurrentUser.uid)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGoodsGoodsDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGoodsDetailWithGoodsId:(NSInteger)goodsId seckillTime:(NSString*)seckillTime successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"goodsId":@(goodsId),
                          @"seckill_time":kMeUnNilStr(seckillTime),
                          @"uid":kMeUnNilStr(kCurrentUser.uid)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGoodsGoodsDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGoodsComboDetailWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"productType":@(3),
                          @"token":kMeUnNilStr(kCurrentUser.token)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGoodsComboDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:[NSString stringWithFormat:@"%@%@",@"获取详情失败,",kApiError]];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postPriceAndStockWithGoodsId:(NSString *)goodsId specIds:(NSString *)specIds ssuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"goods_id":goodsId,
                          @"spec_ids":specIds,
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGoodsGetPriceAndStock);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取库存中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            NSString *error = [NSString stringWithFormat:@"%@%@",@"获取库存失败,",kApiError];
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:error];
        }
        kMeCallBlock(failure,error);
    }];
}

#pragma mark - Shopcart

//删除购物车
+ (void)postDelGoodForShopWithMemberId:(NSInteger)memberId productCartId:(NSString *)productcartid successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"product_cart_id":kMeUnNilStr(productcartid),
                          //                          @"member_id":@(memberId)
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonCartDeleteCart);
    MBProgressHUD *HUD = [self commitWithHUD:@"删除中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)posteditCartNumWithShopCartId:(NSInteger)shopCartId num:(NSInteger)num successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"num":@(num).description,
                          @"id":@(shopCartId).description
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonCartEditCartNum);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postAddGoodForShopWithAttrModel:(MEShoppingCartAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = [attrModel mj_keyValues];
    NSString *url = kGetApiWithUrl(MEIPcommonCartAddCart);
    MBProgressHUD *HUD = [self commitWithHUD:@"加入中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"加入成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postCreateShopOrderWithAttrModel:(MEShoppingCartMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = [attrModel mj_keyValues];
    NSLog(@"%@",dic);
    NSString *url = kGetApiWithUrl(MEIPcommonOrderCartOrder);
    MBProgressHUD *HUD = [self commitWithHUD:@"生成订单中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        //        [HUD hideAnimated:YES];
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"生成成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}



#pragma mark - Address

//新增收货地址
+ (void)postAddAddressWithAttrModel:(MEAddAddressAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    if(!kMeUnNilStr(attrModel.truename).length){
        [MEShowViewTool showMessage:@"名字不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(attrModel.telphone).length){
        [MEShowViewTool showMessage:@"手机号不能为空" view:kMeCurrentWindow];
        return;
    }
    if(![MECommonTool isValidPhoneNum:kMeUnNilStr(attrModel.telphone)]){
        [MEShowViewTool showMessage:@"请填写正确的手机号码" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(attrModel.detail_address).length){
        [MEShowViewTool showMessage:@"地址不能为空" view:kMeCurrentWindow];
        return;
    }
    NSDictionary *dic = [attrModel mj_keyValues];
    NSString *url = kGetApiWithUrl(MEIPcommonAddressAddAddress);
    MBProgressHUD *HUD = [self commitWithHUD:@"添加地址中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
//编辑收货地址
+ (void)postEditAddressWithAttrModel:(MEAddAddressAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    if(!kMeUnNilStr(attrModel.truename).length){
        [MEShowViewTool showMessage:@"名字不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(attrModel.telphone).length){
        [MEShowViewTool showMessage:@"手机号不能为空" view:kMeCurrentWindow];
        return;
        if(![MECommonTool isValidPhoneNum:kMeUnNilStr(attrModel.telphone)]){
            [MEShowViewTool showMessage:@"请填写正确的手机号码" view:kMeCurrentWindow];
            return;
        }
    }
    if(!kMeUnNilStr(attrModel.detail_address).length){
        [MEShowViewTool showMessage:@"地址不能为空" view:kMeCurrentWindow];
        return;
    }
    NSDictionary *dic = [attrModel mj_keyValues];
    NSString *url = kGetApiWithUrl(MEIPcommonAddressEditAddress);
    MBProgressHUD *HUD = [self commitWithHUD:@"编辑地址中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
/*删除地址
 address_id    是    string    地址id
 token    是    string    用户凭证
 */
+ (void)postDelAddressWithAddressId:(NSInteger)AddressId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"address_id":@(AddressId),
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonAddressDelAddres);
    MBProgressHUD *HUD = [self commitWithHUD:@"删除中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postAddressDetailWithAddressId:(NSInteger)AddressId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"address_id":@(AddressId),
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonAddressGetOneAddress);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postAddressDefaultAddressWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonAddressGetdefaultAddress);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}



#pragma mark - UserCentre

+ (void)postGetMemberStoreInfoWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonGetMemberStoreInfo);
//#ifdef TestVersion
//    url = [@"http://test_dev.meshidai.com/api/" stringByAppendingString:MEIPcommonGetMemberStoreInfo];
//#else
//    url = [@"https://msd.meshidai.com/api/" stringByAppendingString:MEIPcommonGetMemberStoreInfo];
//#endif
    MBProgressHUD *HUD = [self commitWithHUD:@"获取审核状态"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postStoreApplyWithModel:(MEStoreApplyParModel *)model SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
//    NSMutableDictionary *dic = [model mj_keyValues];
//    [dic removeObjectForKey:@"mask_imgModel"];
//    [dic removeObjectForKey:@"mask_info_imgModel"];
//    [dic removeObjectForKey:@"business_imagesModel"];
    NSDictionary *dic = @{
                          @"true_name":kMeUnNilStr(model.true_name),
                          @"store_name":kMeUnNilStr(model.store_name),
                          @"name":kMeUnNilStr(model.name),
                          @"mobile":kMeUnNilStr(model.mobile),
                          @"intro":kMeUnNilStr(model.intro),
                          @"province":kMeUnNilStr(model.province),
                          @"city":kMeUnNilStr(model.city),
                          @"district":kMeUnNilStr(model.district),
                          @"address":kMeUnNilStr(model.address),
                          @"latitude":kMeUnNilStr(model.latitude),
                          @"longitude":kMeUnNilStr(model.longitude),
                          @"mask_img":kMeUnNilStr(model.mask_img),
                          @"mask_info_img":kMeUnNilStr(model.mask_info_img),
                          @"id_number":kMeUnNilStr(model.id_number),
                          @"business_images":kMeUnNilStr(model.business_images),
                          @"token":kMeUnNilStr(model.token),
                          @"cellphone":kMeUnNilStr(model.cellphone)
                          };
    NSLog(@"%@",dic);
    NSString *url = kGetApiWithUrl(MEIPcommonStoreApply);
//#ifdef TestVersion
//    url = [@"http://test_dev.meshidai.com/api/" stringByAppendingString:MEIPcommonStoreApply];
//#else
//    url = [@"https://msd.meshidai.com/api/" stringByAppendingString:MEIPcommonStoreApply];
//#endif
    MBProgressHUD *HUD = [self commitWithHUD:@"提交中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserGetUserWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonGetUser);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager getWithParameter:@{@"token":kMeUnNilStr(kCurrentUser.token),@"uid":kMeUnNilStr(kCurrentUser.uid)} strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        [kCurrentUser setterWithDict:responseObject.data];
        [kCurrentUser save];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserCheckFirstBuyWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonCheckFirstBuy);
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            [[NSUserDefaults standardUserDefaults] setObject:responseObject.data[@"first_buy"]  forKey:kcheckFirstBuy];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserGetTokenByFourWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPgetTokenByFour);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取token"];
    [THTTPManager getWithParameter:nil strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        [kCurrentUser setterWithDict:@{@"token":responseObject.data}];
        [kCurrentUser save];
        kNoticeUserLogin
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserCentreDataWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonUserUserCentre);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取个人数据"];
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUseAllReadedInfoWithType:(NSInteger)type SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonAllreadedNotice);
    MBProgressHUD *HUD = [self commitWithHUD:@"全部已读中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserUnreadNoticeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonUnreadNotice);
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserHomeUnreadNoticeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonUnreadNotice);
    //    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        //        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
            
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
            
            //            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserCountListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonCountList);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
        }else{
        }
        kMeCallBlock(failure,error);
    }];
}


+ (void)getUserReadedNoticeWithNoticeId:(NSInteger)noticeId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"id":@(noticeId)
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonreadedNotice);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
        }else{
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getAdminDistributionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonAdminDistribution);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取数据"];
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postcheckStoreGetOrderStatusWithGoodSn:(NSString *)order_goods_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"order_sn":kMeUnNilStr(order_goods_sn)
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommoncheckStoreGetOrderStatus);
    MBProgressHUD *HUD = [self commitWithHUD:@"确定提取中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getOrderDetailWithGoodSn:(NSString *)order_goods_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"order_sn":kMeUnNilStr(order_goods_sn)
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonUserGetOrderDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取订单详情"];
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


+ (void)getUserDistributionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonUserDistribution);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取分享数据..."];
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserGetCodeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonUserGetCode);
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    MBProgressHUD *HUD = [self commitWithHUD:@"获取二维码"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserGetEquitiesWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPcommonWebGetEquities);
    NSDictionary *dic = @{};
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)getUserWebgetAgreementWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPWebgetAgreement);
    NSDictionary *dic = @{};
    MBProgressHUD *HUD = [self commitWithHUD:@""];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}
#pragma mark - Order
//取消订单
+ (void)postDelOrderWithOrderSn:(NSString *)order_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"order_sn":kMeUnNilStr(order_sn)
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonOrderCancelOrder);
    MBProgressHUD *HUD = [self commitWithHUD:@"取消订单..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


+ (void)postCreateServiceOrderWithAttrModel:(MEMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = [attrModel mj_keyValues];
    NSString *url = kGetApiWithUrl(MEIPcommonOrderConvertOrde);
    MBProgressHUD *HUD = [self commitWithHUD:@"生成订单中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        //        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"兑换成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postCreateOrderWithAttrModel:(MEMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = [attrModel mj_keyValues];
    NSString *url = kGetApiWithUrl(MEIPcommonOrderCreateOrder);
    MBProgressHUD *HUD = [self commitWithHUD:@"生成订单中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//用户支付
+ (void)postPayOrderWithOrder_sn:(NSString *)order_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"order_sn":kMeUnNilStr(order_sn),
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"pay_type":@"app",
                          };
    NSString *url = kGetApiWithUrl(MEIPCommonOrderPayOrder);
    MBProgressHUD *HUD = [self commitWithHUD:@"支付中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGetLogistWithOrder_sn:(NSString *)order_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"order_sn":kMeUnNilStr(order_sn),
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          };
    NSString *url = kGetApiWithUrl(MEIPCommonOrderPayOrder);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取物流中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

/***************************************/
#pragma mark - AboutUser
//用户微信登录
+ (void)postWxAuthLoginWithAttrModel:(MEWxAuthModel *)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = [model mj_keyValues];
    NSLog(@"%@",dic);
    NSString *url = kGetApiWithUrl(MEIPAppAuthLogin);
    MBProgressHUD *HUD = [self commitWithHUD:@"微信登录中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//获取短信验证码
+ (void)postGetCodeWithrPhone:(NSString *)phone type:(NSString *)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    if(!kMeUnNilStr(phone).length){
        [MEShowViewTool showMessage:@"手机号不能为空" view:kMeCurrentWindow];
        return;
        if(![MECommonTool isValidPhoneNum:kMeUnNilStr(phone)]){
            [MEShowViewTool showMessage:@"请填写正确的手机号码" view:kMeCurrentWindow];
            return;
        }
    }
    
    NSDictionary *dic = @{@"phone":kMeUnNilStr(phone),@"type":kMeUnNilStr(type)};
    NSString *url = kGetApiWithUrl(MEIPAppGetCodel);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取验证码中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)posteditPhoneWithPhone:(NSString *)phone code:(NSString*)code new_phone:(NSString*)new_phone successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    
    if(!kMeUnNilStr(phone).length){
        [MEShowViewTool showMessage:@"手机号不能为空" view:kMeCurrentWindow];
        return;
        if(![MECommonTool isValidPhoneNum:kMeUnNilStr(phone)]){
            [MEShowViewTool showMessage:@"请填写正确的手机号码" view:kMeCurrentWindow];
            return;
        }
    }
    
    if(!kMeUnNilStr(new_phone).length){
        [MEShowViewTool showMessage:@"新手机号不能为空" view:kMeCurrentWindow];
        return;
        if(![MECommonTool isValidPhoneNum:kMeUnNilStr(new_phone)]){
            [MEShowViewTool showMessage:@"请填写正确的新手机号码" view:kMeCurrentWindow];
            return;
        }
    }
    
    if(!kMeUnNilStr(code).length){
        [MEShowViewTool showMessage:@"验证码不能为空" view:kMeCurrentWindow];
        return;
    }
    
    NSDictionary *dic = @{@"phone":kMeUnNilStr(phone),@"code":kMeUnNilStr(code),@"new_phone":kMeUnNilStr(new_phone),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPeditPhone);
    MBProgressHUD *HUD = [self commitWithHUD:@"修改手机号中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postloginByPhoneWithPhone:(NSString *)phone code:(NSString*)code successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    if(!kMeUnNilStr(phone).length){
        [MEShowViewTool showMessage:@"手机号不能为空" view:kMeCurrentWindow];
        return;
        if(![MECommonTool isValidPhoneNum:kMeUnNilStr(phone)]){
            [MEShowViewTool showMessage:@"请填写正确的手机号码" view:kMeCurrentWindow];
            return;
        }
    }
    
    if(!kMeUnNilStr(code).length){
        [MEShowViewTool showMessage:@"验证码不能为空" view:kMeCurrentWindow];
        return;
    }
    
    NSDictionary *dic = @{@"phone":kMeUnNilStr(phone),@"code":kMeUnNilStr(code)};
    NSString *url = kGetApiWithUrl(MEIPLoginByPhone);
    MBProgressHUD *HUD = [self commitWithHUD:@"登录中..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postaddPhoneWithPhone:(NSString *)phone code:(NSString*)code invate:(NSString*)invate successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    if(!kMeUnNilStr(phone).length){
        [MEShowViewTool showMessage:@"手机号不能为空" view:kMeCurrentWindow];
        return;
        if(![MECommonTool isValidPhoneNum:kMeUnNilStr(phone)]){
            [MEShowViewTool showMessage:@"请填写正确的手机号码" view:kMeCurrentWindow];
            return;
        }
    }
    
    if(!kMeUnNilStr(code).length){
        [MEShowViewTool showMessage:@"验证码不能为空" view:kMeCurrentWindow];
        return;
    }
    
    NSDictionary *dic = @{@"phone":kMeUnNilStr(phone),@"code":kMeUnNilStr(code),@"token":kMeUnNilStr(kCurrentUser.token),@"invite_code":kMeUnNilStr(invate)};
    NSString *url = kGetApiWithUrl(MEIPaddPhone);
    MBProgressHUD *HUD = [self commitWithHUD:@"绑定手机号..."];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        if([responseObject.status_code isEqualToString:kNetInvateCode]){
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(responseObject.message)];
        }else{
            [HUD hideAnimated:YES];
        }
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postGetAPPVersionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MEIPGetAPPVersion);
    [THTTPManager postWithParameter:@{} strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}
+ (void)postGetNewAPPVersionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSString *url = kGetApiWithUrl(MENewIPGetAPPVersion);
    [THTTPManager postWithParameter:@{@"version":kMEAppVersion} strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}

+ (void)postAddShareWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    if([MEUserInfoModel isLogin]){
        NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token)};
        NSString *url = kGetApiWithUrl(MEIPAddShare);
        [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
            kMeCallBlock(successBlock,responseObject);
        } failure:^(id error) {
            kMeCallBlock(failure,error);
        }];
    }
}

+ (void)postExpMiniprogramAtWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"member_id":kMeUnNilStr(kCurrentUser.uid),@"token":kMeUnNilStr(kCurrentUser.token)};
    NSString *url = kGetApiWithUrl(MEIPExpMiniprogramAt);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        kMeCallBlock(failure,error);
    }];
}


/***************************************/
#pragma mark - member
//获取超级会员数据 产品
+ (void)getSupportMemberWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{};
    NSString *url = kGetApiWithUrl(MEIPcommonSupportMember);
    [THTTPManager getWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}

//获取超级会员数据 美豆
+ (void)postSupportMemberManyGoodsWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    //4 为美豆
    NSDictionary *dic = @{@"type":@"4"};
    NSString *url = kGetApiWithUrl(MEIPcommonFindManyGoods);
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool showMessage:kMeUnNilStr(res.message) view:kMeCurrentWindow];
        }else{
            [MEShowViewTool showMessage:kApiError view:kMeCurrentWindow];
        }
        kMeCallBlock(failure,error);
    }];
}


/***************************************/


/***************************************/
#pragma mark - Store
//app 更新店铺商家信息
+ (void)postStroeFindStoreInfoWithEditModel:(MEBStoreMannagerEditModel*)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    if(!kMeUnNilStr(model.store_name).length){
        [MEShowViewTool showMessage:@"店铺名称不能为空" view:kMeCurrentWindow];
        return;
    }
    
    if(!kMeUnNilStr(model.mobile).length){
        [MEShowViewTool showMessage:@"店铺电话不能为空" view:kMeCurrentWindow];
        return;
    }
    if(![MECommonTool isValidPhoneNum:kMeUnNilStr(model.mobile)]){
        [MEShowViewTool showMessage:@"请填写正确的店铺电话" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(model.id_number).length){
        [MEShowViewTool showMessage:@"身份证不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(model.intro).length){
        [MEShowViewTool showMessage:@"店铺简介不能为空" view:kMeCurrentWindow];
        return;
    }
    
    
    NSDictionary *dic = [model mj_keyValues];
    NSString *url = kGetApiWithUrl(MEIPcommonUpdateStoreInfo);
    MBProgressHUD *HUD = [self commitWithHUD:@"更新店铺信息"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"更新成功"];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//app获取店铺商家信息
+ (void)postStroeFindStoreInfoWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"token":kMeUnNilStr(kCurrentUser.token),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonFindStoreInfo);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取店铺信息"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//获取门店祥情
+ (void)postStroeDetailWithGoodsId:(NSInteger)storeId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"store_id":@(storeId),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonStoreGetStore);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

//获取服务祥情
+ (void)postServiceDetailWithServiceId:(NSInteger)serviceId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{@"serviceId":@(serviceId),
                          };
    NSString *url = kGetApiWithUrl(MEIPcommonserviceDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取详情中"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}


+ (void)postAppointDetailWithReserve_sn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"reserve_sn":kMeUnNilStr(reserve_sn)
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonUserGetAppointDetail);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取预约详情"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

+ (void)postReserveDetailBlWithReserve_sn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure{
    NSDictionary *dic = @{
                          @"token":kMeUnNilStr(kCurrentUser.token),
                          @"reserve_sn":kMeUnNilStr(reserve_sn)
                          };
    
    NSString *url = kGetApiWithUrl(MEIPcommonreserveDetailB);
    MBProgressHUD *HUD = [self commitWithHUD:@"获取预约详情"];
    [THTTPManager postWithParameter:dic strUrl:url success:^(ZLRequestResponse *responseObject) {
        [HUD hideAnimated:YES];
        kMeCallBlock(successBlock,responseObject);
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        kMeCallBlock(failure,error);
    }];
}

/***************************************/

#pragma mark - Help

+ (MBProgressHUD *)commitWithHUD:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    //    UIImage *image = [UIImage sd_animatedGIFNamed:@"loading"];
    //    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:image];
    //    hud.mode = MBProgressHUDModeCustomView;
    //    hud.removeFromSuperViewOnHide = YES;
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.bezelView.backgroundColor = [UIColor clearColor];
    //    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    //    hud.customView = cusImageV;
    hud.label.text = str;
    //    hud.label.textColor = kMEPink;
    hud.userInteractionEnabled = YES;
    return hud;
}

@end
