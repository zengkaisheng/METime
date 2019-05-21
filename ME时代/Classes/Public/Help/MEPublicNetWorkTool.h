//
//  MEPublicNetWorkTool.h
//  ME时代
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLRequestResponse.h"//处理网络请求错误信息
#import "THTTPRequestOperationManager.h"//网络请求工具类

//参数model
@class MEShoppingCartAttrModel;
@class MEAddAddressAttrModel;
@class MEMakeOrderAttrModel;
@class MEShoppingCartMakeOrderAttrModel;
@class MEWxAuthModel;
@class MEAppointAttrModel;
@class MEWithdrawalParamModel;
@class MEBStoreMannagerEditModel;
@class MEStoreApplyParModel;
@class MEDynamicGoodApplyModel;
@class MEAddGoodModel;
@class MEAiCustomerDataModel;

@interface MEPublicNetWorkTool : NSObject

/*********************************************/
#pragma makr - ai
//设置用户标签
+ (void)postgetCustomerGetLabelWithLabel:(NSString*)label uid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取标签列表
+ (void)postgetCustomerGetLabelWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//实际跟进阶段   更新
+ (void)postgetCustomerupdateFollowWithUid:(NSString*)uid follow_up:(NSString*)follow_up SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
////修改客户资料
+ (void)postgetCustomerDetailWithModel:(MEAiCustomerDataModel*)model SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//客户详情(雷达)
+ (void)postgetCustomerDetailWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//客户详情(雷达)
+ (void)postgetMemberBehaviorWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//雷达--行为
+ (void)postgetMemberBehaviorWithtype:(NSString*)type SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//跟进投票用户（点击打电话时调用） 1投票活动2海报3文章4访问店铺
+ (void)postgetIPcommonclerknotFollowUpMemberWithUid:(NSString*)uid type:(NSInteger)type SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/
#pragma makr - GoodMannger
//获取门店权限
+ (void)postgetStorePowerWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//门店自定义商品祥情
+ (void)postgetStoreGoodsDetailWithProduct_id:(NSString*)pid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除自定义商品
+ (void)postgetDelStoreGoodsWithProduct_id:(NSString*)pid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//商品规格
+ (void)postgetGoodSpecNameWithSuccessBlock:(RequestResponse)successBlock  failure:(kMeObjBlock)failure;
+ (void)postcommonAddOrEditGoodsWithParModel:(MEAddGoodModel *)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/
#pragma makr - xunweishi
+ (void)postXunweishiApplyWithParModel:(MEDynamicGoodApplyModel *)model images:(NSString*)images successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/

/*********************************************/
#pragma makr - BRAND
//能力排行
+ (void)postgetAbilityRankWithStoreId:(NSString*)storeId SuccessBlock:(RequestResponse)successBlock  failure:(kMeObjBlock)failure;
//数据分析
+ (void)postgetStoreDatAnalysisWithDate:(NSString *)date storeId:(NSString*)storeId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//总览
+ (void)postgetStoreOverviewWithDate:(NSString *)date SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;


/*********************************************/
#pragma makr - 公共
//获取七牛云TOKEN
+ (void)postgetQiuNiuTokkenWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//上传图片
+ (void)postQiNiuUpFileWithToken:(NSString *)token filePath:(NSString *)filePath successBlock:(kMeObjBlock)successBlock failure:(kMeObjBlock)failure;


/*********************************************/
#pragma makr - IM
+ (void)postUserInfoByTlsWithTls_id:(NSString *)tls_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

+ (void)getUserGetTokenByFourWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/
#pragma makr - 动态
//上传图片
+ (void)posUploadImagesWithFile:(UIImage *)image successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//B Clerk s发表评论
+ (void)postdynamicVotingCommentWithConten:(NSString *)content images:(NSString*)images successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除
+ (void)postdynamicDelDynamicWithdynamicId:(NSString *)dynamic_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//点赞
+ (void)postdynamicPraiselWithdynamicId:(NSString *)dynamic_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//评论
+ (void)postdynamicCommentdynamicId:(NSString *)dynamic_id content:(NSString*)content successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/



/*********************************************/
#pragma makr - JD
+ (void)postJDPromotionUrlGenerateWithUid:(NSString *)uid materialUrl:(NSString*)materialUrl couponUrl:(NSString*)couponUrl successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/
#pragma makr - pinduoduo
//拼多多推荐
+ (void)postGetPinduoduoCommondPoductWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//佣金祥情
+ (void)postGetPinduoduoBrokerageDetailBaseWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//多多商品详情
+ (void)postPinDuoduoGoodsDetailWithGoodsId:(NSString *)goodsId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//多多进宝推广链接生成
+ (void)postPromotionUrlGenerateWithUid:(NSString *)uid goods_id_list:(NSString*)goods_id_list SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/

/*********************************************/
//获取淘宝客Banner
+ (void)postAgetTbkBannerWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//推广券信息查询
+ (void)postCoupleTbkCouponGetWithActivity_id:(NSString *)activity_id item_id:(NSString*)item_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//通用物料搜索API
+ (void)postCoupledgMaterialOptionalWithType:(MECouponSearchType)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postTaobaokeGetTpwdWithTitle:(NSString *)title url:(NSString*)url logo:(NSString*)logo successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postShareTaobaokeGetTpwdWithTitle:(NSString *)title url:(NSString*)url logo:(NSString*)logo successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
#pragma makr - taobao
+ (void)postAddressTaobaokeGetCategoryWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//卷详情
+ (void)postCoupleDetailWithProductrId:(NSString *)productrId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
////查找用户渠道
+ (void)postShareTaobaokeGetMemberRelationWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取淘宝渠道备案URL
+ (void)postShareTaobaokeGetInviterUrlWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/

/*********************************************/
#pragma makr - gift
+ (void)postAgetGiftBannerWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/


/*********************************************/

/*********************************************/
#pragma makr - B&Clerk share
//商品编码
+ (void)postGoodsEncodeWithProductrId:(NSString *)productrId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//商品解码
+ (void)postGoodsEncodeWithStr:(NSString *)str successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/



/*********************************************/
#pragma makr - B deal
//数据统计
+ (void)postGetBstatisticsWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//我的佣金
+ (void)postMyBrokerageWithType:(MEClientTypeStyle)type memberId:(NSString *)memberId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/

/*********************************************/
#pragma makr - Withdrawal
//提现申请
+ (void)postDestoonFinanceCashWithAttrModel:(MEWithdrawalParamModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/***************************************/


/***************************************/
#pragma mark - clerk
//设置门店店员分佣比例
+ (void)postClerkCommissionPercentWithissetClerk:(BOOL)isset ratio:(NSString*)ratio successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取店员系统设置分佣比例、及本店的设置
+ (void)postClerkCommissionPercentrWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除店员
+ (void)postClerkToMemberWithmemberId:(NSString *)memberId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//会员升级为店员
+ (void)posMemberToClerkWithmemberId:(NSString *)memberId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/***************************************/


/***************************************/

#pragma mark - HomePage

//审核状态
+ (void)postcommonredeemgetStatusWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//兑换信息
+ (void)postGetredeemcodeInfoWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加兑换
+ (void)postGetredeemcodeaddCodeWithImage:(NSString*)image SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取APP首页标题
+ (void)postGetappThridHomeGetAppHomeTitleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//app第三版商业热门产品
+ (void)postGetappThridHomePagHotGoodWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//app获取店铺信息
+ (void)postGetappHomePageDataWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取秒杀商品
+ (void)postThridHomegetSeckillGoodsWithSeckillTime:(NSString*)time SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postThridHomeGetSeckillTimeSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取2.0首页数据
+ (void)postThridHomeStyleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取首面的背景和banner
+ (void)postActivityWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postAdWithPosition_id:(NSInteger)position_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postAdWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//首页产品
+ (void)postHomeRecommendWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取首页样式
+ (void)postMystyleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取通知消息
+ (void)postGetMessageWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取首页推荐产品(2019-04-30)
+ (void)postThridHomehomegetRecommendWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取推荐产品和抢购产品
+ (void)postThridHomeRecommendAndSpreebuyWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/


/***************************************/
#pragma mark - Article
//访问用户详情
+ (void)postVistorUserInfoWithuserId:(NSString *)userId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//访问统计
+ (void)postGetAccessWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取海报分类
+ (void)postArticleClassWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//文章详情
+ (void)postArticleClassWithId:(NSString *)aid successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//分享文章
+ (void)postShareArticelWithId:(NSString *)aid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//文章统计
+ (void)postCountArticleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取客户
+ (void)postGetAccessUserWithIntention:(NSInteger)intention successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//设为意向客户
+ (void)postSetIntentioUserId:(NSString *)userId intentio:(NSString *)intentio SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/

/***************************************/

#pragma mark - Poster
//获取海报分类
+ (void)postPostersClassWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//分享海报
+ (void)postSharePosterWithId:(NSString *)posters_id SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除海报
+ (void)postDelSharePosterWithId:(NSString *)shareId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/


/***************************************/
#pragma mark - Custom

+ (void)postGetCustomIdWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取客服信息
+ (void)postGetCustomerGetUserInfoWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postGetUserGetUserInfoWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/


/***************************************/
#pragma mark - Goods
//商品列表
+ (void)postGoodsListWithType:(MEGoodsTypeNetStyle)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//新接口,首页产品
+ (void)postHomeNewGoodsListWithType:(NSString *)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//商品详情
+ (void)postGoodsDetailWithGoodsId:(NSInteger)goodsId seckillTime:(NSString*)seckillTime successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postGoodsDetailWithGoodsId:(NSInteger)goodsId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//top
+ (void)postGoodsListTopWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postGoodsTypeWithArticleCategoryId:(NSUInteger)ArticleCategoryId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取抢购商品
+ (void)postRushGoodWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取商品分类
+ (void)postGoodFilterWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*
 获取库存和价格
 goods_id    是    string    商品的id
 spec_ids    是    string    组合属性 如 1,2
 token    否    string    用户凭证
 */
+ (void)postPriceAndStockWithGoodsId:(NSString *)goodsId specIds:(NSString *)specIds ssuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//980
+ (void)postGoodsComboDetailWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取推荐到首次购买活动商品
+ (void)postRecommendProductWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/




/***************************************/
#pragma mark - Address
//新增收货地址
+ (void)postAddAddressWithAttrModel:(MEAddAddressAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//编辑收货地址
+ (void)postEditAddressWithAttrModel:(MEAddAddressAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*删除地址
 address_id    是    string    地址id
 token    是    string    用户凭证
 */
+ (void)postDelAddressWithAddressId:(NSInteger)AddressId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*获取某个地址详情
 address_id    是    string    地址id
 token    是    string    用户凭证
 */
+ (void)postAddressDetailWithAddressId:(NSInteger)AddressId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取默认地址
+ (void)postAddressDefaultAddressWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/




/***************************************/
#pragma mark - Shopcart

/*
 删除购物车
 member_id    是    int    用户id
 token    是    string    登陆后返回的ID
 product_cart_id    是    string    购物车记录ID,多个记录以逗号分开，例如：‘1,4,5,7’
 */
+ (void)postDelGoodForShopWithMemberId:(NSInteger)memberId productCartId:(NSString *)productcartid successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//加入购物车 MEShoppingCartAttrModel
+ (void)postAddGoodForShopWithAttrModel:(MEShoppingCartAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//购物车下单
+ (void)postCreateShopOrderWithAttrModel:(MEShoppingCartMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//购物车数量修改
+ (void)posteditCartNumWithShopCartId:(NSInteger)shopCartId num:(NSInteger)num successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/



/***************************************/
#pragma mark - UserCentre
//获取未读总数
+ (void)getUserCountListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取用户信息
+ (void)getUserGetUserWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//一键已读
+ (void)getUseAllReadedInfoWithType:(NSInteger)type SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//首页获取未读的推送信息
+ (void)getUserHomeUnreadNoticeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//已读消息
+ (void)getUserReadedNoticeWithNoticeId:(NSInteger)noticeId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取未读的推送信息
+ (void)getUserUnreadNoticeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取个人中心的数据
+ (void)getUserCentreDataWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取商家分销中心
+ (void)getAdminDistributionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取订单详情
+ (void)getOrderDetailWithGoodSn:(NSString *)order_goods_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//设置到店领取订单(已提取)
+ (void)postcheckStoreGetOrderStatusWithGoodSn:(NSString *)order_goods_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//分销中心数据
+ (void)getUserDistributionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取C端二维码
+ (void)getUserGetCodeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取权益
+ (void)getUserGetEquitiesWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//电子协议
+ (void)getUserWebgetAgreementWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
// 门店申请、或修改申请
+ (void)postStoreApplyWithModel:(MEStoreApplyParModel *)model SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postGetMemberStoreInfoWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/


/***************************************/
#pragma mark - Order
//取消订单
+ (void)postDelOrderWithOrderSn:(NSString *)order_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//普通下单
+ (void)postCreateOrderWithAttrModel:(MEMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//用户支付
+ (void)postPayOrderWithOrder_sn:(NSString *)order_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//生成兑换订单
+ (void)postCreateServiceOrderWithAttrModel:(MEMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//查询快递
+ (void)postGetLogistWithOrder_sn:(NSString *)order_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/


/***************************************/
#pragma mark - AboutUser
//用户微信登录
+ (void)postWxAuthLoginWithAttrModel:(MEWxAuthModel *)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取短信验证码 type 登录 1 绑定修改 2
+ (void)postGetCodeWithrPhone:(NSString *)phone type:(NSString *)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//手机号登录
+ (void)postloginByPhoneWithPhone:(NSString *)phone code:(NSString*)code successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//绑定手机号
+ (void)postaddPhoneWithPhone:(NSString *)phone code:(NSString*)code invate:(NSString*)invate successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//修改手机号
+ (void)posteditPhoneWithPhone:(NSString *)phone code:(NSString*)code new_phone:(NSString*)new_phone successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取赠送小程序的到期时间
+ (void)postExpMiniprogramAtWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//APP分享成功
+ (void)postAddShareWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取app版本
+ (void)postGetAPPVersionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//新的获取app版本
+ (void)postGetNewAPPVersionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//判断是否完成首单
+ (void)getUserCheckFirstBuyWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/



/***************************************/
#pragma mark - member
//获取超级会员数据
+ (void)getSupportMemberWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
+ (void)postSupportMemberManyGoodsWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/


/***************************************/
#pragma mark - Store
//app 更新店铺商家信息
+ (void)postStroeFindStoreInfoWithEditModel:(MEBStoreMannagerEditModel*)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//app获取店铺商家信息
+ (void)postStroeFindStoreInfoWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取门店祥情
+ (void)postStroeDetailWithGoodsId:(NSInteger)storeId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取服务祥情
+ (void)postServiceDetailWithServiceId:(NSInteger)serviceId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//预约订单
+ (void)postCreatAppointWithAttrModel:(MEAppointAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除预约
+ (void)postDelAppointWithReserveSn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取预约详情
+ (void)postAppointDetailWithReserve_sn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//预约祥情B端
+ (void)postReserveDetailBlWithReserve_sn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//预约完成B端
+ (void)postFinishReserveWithReserveSn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//预约取消B端
+ (void)postCancelReserveWithReserveSn:(NSString *)reserve_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/

+ (MBProgressHUD *)commitWithHUD:(NSString *)str;

@end
