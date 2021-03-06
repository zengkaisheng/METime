//
//  MEPublicNetWorkTool.h
//  志愿星
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
@class SSHomeAddTestDecModel;
@class MEAddCustomerInformationModel;
@class MESetCustomerFileSalesModel;
@class MEAddServiceModel;
@class MEAddCustomerExpenseModel;
@class MEAddCustomerAppointmentModel;
@class MERegisterVolunteerModel;
@class MEApplyOrganizationModel;

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
//（点击发消息时调用
+ (void)postgetIPcommonclerkAddCommunicationLogWithUid:(NSString*)uid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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
+ (void)postdynamicVotingCommentWithConten:(NSString *)content images:(NSString*)images terminal:(NSString *)terminal onlyClerkView:(NSString *)onlyClerkView successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除
+ (void)postdynamicDelDynamicWithdynamicId:(NSString *)dynamic_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//点赞
+ (void)postdynamicPraiselWithdynamicId:(NSString *)dynamic_id successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//评论
+ (void)postdynamicCommentdynamicId:(NSString *)dynamic_id content:(NSString*)content successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//意见反馈
+ (void)postFeedBackWithConten:(NSString *)content images:(NSString*)images successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/



/*********************************************/
#pragma makr - JD
+ (void)postJDPromotionUrlGenerateWithUid:(NSString *)uid materialUrl:(NSString*)materialUrl couponUrl:(NSString*)couponUrl successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/
#pragma makr - pinduoduo
//拼多多推荐
+ (void)postGetPinduoduoCommondPoductWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//拼多多筛选
+ (void)postGetPinduoduoCommondPoductWithSortType:(NSInteger)sortType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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

//通过Session获取relation_id
+ (void)postTaobaokePublisherInfoSaveWithSession:(NSString *)session successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/


/*********************************************/
#pragma makr - coupons
//获取优惠券Banner
+ (void)postGetCouponsBannerWithBannerType:(NSString *)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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
//获取首页导航分类-新 2019-10-22
+ (void)postGetHomeNavWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取淘宝客首页导航分类
+ (void)postGetMaterialWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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

//获取首页推荐商品/活动2019-7-31
+ (void)postFourGetHomeRecommendGoodsAndActivityWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取首页推荐产品（商品、砍价、拼团、秒杀）2019-7-23
+ (void)postFourGetHomeRecommendWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取首页推荐产品(2019-04-30)
+ (void)postThridHomehomegetRecommendWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取推荐产品和抢购产品
+ (void)postThridHomeRecommendAndSpreebuyWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//APP首页各入口选项
+ (void)postFourHomeOptionsWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取首页公益秀
+ (void)postGetSixHomePublicShowsWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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

//app获取技术客服微信信息
+ (void)postGetCustomerServiceWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

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


//新优选获取商品接口（5-30）
+ (void)postFetchProductsWithCategoryId:(NSString *)categoryId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//新优选获取banner图（5-30）
+ (void)postFetchYouxianBannerWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//品牌特卖获取banner图(新)
+ (void)postFetchSpecialSalesBannerWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//首页公告栏
+ (void)postFetchHomeBulletinWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//是否显示优选me的banner和分类是否显示
+ (void)postGetYouxuanAdGoodsShowWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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

//获取结算页邮费
+ (void)postOrderFreightWithAddressId:(NSString *)addressId postage:(NSString *)postage productId:(NSString *)productId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取购物车结算页邮费
+ (void)postOrderFreightBWithAddressId:(NSString *)addressId productId:(NSString *)productId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取到店领取的店铺地址
+ (void)postStoreAddressWithsuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/


/***************************************/
#pragma mark - Question

//常见问题列表
+ (void)postGetQuestionListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//常见问题详情
+ (void)postGetQuestionDetailWithQuestionId:(NSInteger)questionId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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
//我的入口
+ (void)getUserMenuDataWithType:(NSInteger)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//我的入口（新）
+ (void)getNewUserMenAlluDataWithType:(NSInteger)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取用户的邀请码
+ (void)getUserInvitationCodeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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
//获取C端二维码背景图
+ (void)getUserGetCodeBGImageWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取权益
+ (void)getUserGetEquitiesWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//电子协议
+ (void)getUserWebgetAgreementWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
// 门店申请、或修改申请
+ (void)postStoreApplyWithModel:(MEStoreApplyParModel *)model SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//新门店申请
+ (void)postNewStoreApplyWithModel:(MEStoreApplyParModel *)model SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

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

//申请退款
+ (void)postApplyRefundWithOrder_sn:(NSString *)order_sn order_goods_sn:(NSString *)order_goods_sn desc:(NSString *)desc successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//退款详情
+ (void)postRefundOrderDetailWithRefund_sn:(NSString *)refund_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

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
//通过邀请码查询上级信息
+ (void)postGetCodeMsgWithInvitationCode:(NSString *)code  successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//邀请码绑定关系
+ (void)postGetBindingParentWithInvitationCode:(NSString *)code  successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
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

//获取优惠券信息
+ (void)postPasteboardCouponDataWithQueryStr:(NSString *)queryStr successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/

/***************************************/
#pragma mark - Prize
//今日福利
+ (void)postGetPrizeTodayDataWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//抽奖活动 详情
+ (void)postGetPrizeDetailWithActivityId:(NSString *)activityId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//参加抽奖活动
+ (void)postJoinPrizeWithActivityId:(NSString *)activityId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//查看抽奖活动图文详情
+ (void)postCheckPrizeContentWithActivityId:(NSString *)activityId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//领取抽奖商品
+ (void)postCreatePrizeOrderWithAttrModel:(MEMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//查看全部总数
+ (void)postPrizeJoinUserCountWithActivityId:(NSString *)activityId lookType:(NSString *)lookType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/



/***************************************/
#pragma mark - Group
//拼团商品详情
+ (void)postGroupDetailWithProductId:(NSString *)productId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取拼团的人员信息
+ (void)postGetGroupUsersWithProductId:(NSString *)productId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//生成拼团订单
+ (void)postCreateGroupOrderWithAttrModel:(MEMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//拼团订单详情
+ (void)postGroupOrderDetailWithOrderSn:(NSString *)orderSn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/



/***************************************/
#pragma mark - Bargin
//砍价
+ (void)postBargainWithDict:(NSDictionary *)dict successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//砍价商品详情
+ (void)postBargainDetailWithBargainId:(NSString *)bargainId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//查看更多砍价帮
+ (void)postGetAllBarginLogWithBargainId:(NSString *)bargainId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//领取砍价商品
+ (void)postCreateBargainOrderWithAttrModel:(MEMakeOrderAttrModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/



/***************************************/
#pragma mark - auth
//添加极光注册id
+ (void)postAuthAddRegIdWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/***************************************/



/***************************************/
#pragma mark - Store
//点击数统计
+ (void)recordTapActionWithParameter:(NSDictionary *)parameter;
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

#pragma makr - 测试题
//删除测试库
+ (void)postgetbankdelBankWithId:(NSString*)pid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加测试库
+ (void)postgetbankaddBankWithModel:(SSHomeAddTestDecModel*)model SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//测试题库详情
+ (void)postgetbanktestBankWithId:(NSString*)pid SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//修改测试库
+ (void)postgetbankeditBankWithModel:(SSHomeAddTestDecModel*)model SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//测试规则
+ (void)postgetbanktestBankruleWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/



/*********************************************/
#pragma mark - 在线课程
//视频分类
+ (void)postGetVideoClassifyWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//视频首页信息
+ (void)postGetVideoIndexListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//视频列表
+ (void)postGetVideoListWithIsCharge:(NSInteger)is_charge videoType:(NSString *)videoType keyword:(NSString *)keyword successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//视频详情
+ (void)postGetVideoDetailWithVideoId:(NSInteger)videoId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加收藏
+ (void)postSetCollectionWithCollectionId:(NSInteger)collectionId type:(NSInteger)type SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//取消收藏
+ (void)postCancelCollectionWithCollectionId:(NSString *)collectionId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//音频
//音频分类
+ (void)postGetAudioClassifyWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//音频首页信息
+ (void)postGetAudioIndexListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//音频列表
+ (void)postGetAudioListWithIsCharge:(NSInteger)is_charge audioType:(NSString *)audioType keyword:(NSString *)keyword successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//音频详情
+ (void)postGetAudioDetailWithAudioId:(NSInteger)audioId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;


//音频/视频 生成订单
+ (void)postCreateOrderWithCourseId:(NSString *)courseId orderType:(NSString *)orderType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//音频/视频 支付订单
+ (void)postPayOnlineOrderWithOrderSn:(NSString *)order_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//轮询订单状态
+ (void)postGetOrderStatusWithOrderSn:(NSString *)order_sn successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//音视频点赞
+ (void)postPraiseCourseWithCourseId:(NSInteger)courseId courseType:(NSInteger)courseType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//学习（播放时调用）
+ (void)postStudyCourseWithCourseId:(NSInteger)courseId courseType:(NSInteger)courseType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//一起创业banner
+ (void)postGetBannerWithAdType:(NSInteger)adType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//一起创业分类
+ (void)postGetCareerCategoryWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/


/*********************************************/
#pragma mark - Diagonse
//诊断问题
+ (void)postGetDiagnoseQuestionWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//提交诊断问题
+ (void)postAddDiagnoseQuestionWithName:(NSString *)name phone:(NSString *)phone isBeen:(NSString *)is_been optionsJson:(NSString *)options_json successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//专家诊断服务列表
+ (void)postGetDiagnosisProductWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
// 创建诊断订单
+ (void)postCreateDiagnoiseOrderWithProductId:(NSString *)productId orderType:(NSString *)orderType phone:(NSString *)phone remark:(NSString *)remark successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//提交问题咨询
+ (void)postConsultQuestionWithProblem:(NSString *)problem images:(NSString*)images successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//问题资讯详情
+ (void)postGetConsultDetailWithConsultId:(NSString *)consultId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//诊断报告
+ (void)postGetDiagnoseReportWithReportId:(NSString *)reportId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//问题回复
+ (void)postReplyQuestionWithAnswer:(NSString *)answer questionId:(NSString*)questionId userType:(NSInteger)userType answerImages:(NSString*)answerImages successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/



/*********************************************/
#pragma mark - Diagonse
//获取顾客分类列表
+ (void)postGetCustomerClassifyListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除顾客分类
+ (void)postDeleteCustomerClassifyWithClassifyId:(NSInteger)classifyId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加顾客分类
+ (void)postAddCustomerClassifyWithClassifyName:(NSString *)classifyName successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加顾客基本信息
+ (void)postAddCustomerInformationWithInformationModel:(MEAddCustomerInformationModel *)informationModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取顾客档案信息
+ (void)postGetCustomerInformationWithCustomerId:(NSInteger)customerId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除顾客档案
+ (void)postDeleteCustomerFileWithFileId:(NSInteger)fileId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//修改顾客基本信息
+ (void)postEditCustomerInformationWithInformationModel:(MEAddCustomerInformationModel *)informationModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//顾客档案销售信息-修改
+ (void)postSetCustomerSalesInfoWithSalesModel:(MESetCustomerFileSalesModel *)salesModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//顾客档案跟进信息-添加
+ (void)postAddCustomerFollowInfoWithFileId:(NSInteger )fileId project:(NSString *)project followTime:(NSString *)followTime followType:(NSString *)followType result:(NSString *)result successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//顾客档案跟进信息-修改
+ (void)postEditCustomerFollowInfoWithFileId:(NSInteger )fileId followId:(NSInteger)followId project:(NSString *)project followTime:(NSString *)followTime followType:(NSString *)followType result:(NSString *)result successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取生活习惯分类列表及选项
+ (void)postGetLivingHabitListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取顾客档案生活习惯-添加/修改
+ (void)postEditLivingHabitWithCustomerFilesId:(NSString *)customerFilesId habit:(NSString *)habit successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取跟进方式列表
+ (void)postGetFollowTypeListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;


//添加生活习惯
+ (void)postAddLivingHabitWithClassifyId:(NSString *)classifyId habit:(NSString *)habit habitType:(NSString *)habitType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//修改生活习惯
+ (void)postEditLivingHabitWithClassifyId:(NSString *)classifyId habitId:(NSString *)habitId habit:(NSString *)habit habitType:(NSString *)habitType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除生活习惯
+ (void)postDeleteLivingHabitWithHabitId:(NSString *)habitId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//修改生活习惯分类
+ (void)postEditLivingHabitClassifyNameWithClassifyId:(NSString *)classifyId classifyTitle:(NSString *)classifyTitle type:(NSInteger)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加生活习惯分类
+ (void)postAddCustomerLivingHabitClassifyWithClassifyTitle:(NSString *)classifyTitle type:(NSInteger)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加生活习惯分类
+ (void)postDeleteCustomerLivingHabitClassifyWithClassifyId:(NSString *)classifyId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/


/*********************************************/
#pragma mark - 顾客服务
//通过手机号获取顾客档案-基本信息
+ (void)postGetCustomerFilesDetailWithPhone:(NSString *)phone successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取顾客服务祥情
+ (void)postGetCustomerServiceDetailWithFilesId:(NSInteger )filesId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除顾客服务
+ (void)postDeleteCustomerServiceWithServiceId:(NSInteger)serviceId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加顾客服务
+ (void)postAddCustomerServiceWithServiceModel:(MEAddServiceModel *)serviceModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加/修改顾客服务--记录
+ (void)postAddCustomerServiceRecordsWithServiceModel:(MEAddServiceModel *)serviceModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/

/*********************************************/
#pragma mark - 顾客消费
//获取顾客消费祥情
+ (void)postGetCustomerExpenseDetailWithFilesId:(NSInteger )filesId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加顾客消费/充值
+ (void)postAddCustomerExpenseWithExpenseModel:(MEAddCustomerExpenseModel *)expenseModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//修改顾客消费/充值
+ (void)postEditCustomerExpenseWithExpenseModel:(MEAddCustomerExpenseModel *)expenseModel expenseId:(NSInteger)expenseId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//顾客消费详情
+ (void)postGetCustomerExpenseDetailWithExpenseId:(NSInteger)expenseId type:(NSInteger)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//产品性质列表
+ (void)postGetExpenseProductNatureListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//产品性质列表
+ (void)postGetExpenseSourceListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

/*********************************************/


/*********************************************/
#pragma mark - 顾客预约
//预约时间列表
+ (void)postGetAppointmentDateListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取项目列表
+ (void)postGetAppointmentObjectListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加项目
+ (void)postAddAppointmentObjectWithObjectName:(NSString *)objectName successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加顾客预约
+ (void)postAddCustomerAppointmentWithModel:(MEAddCustomerAppointmentModel *)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//取消预约
+ (void)postCancelAppointmentWithAppointmentId:(NSString *)appointmentId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//确认预约
+ (void)postConfirmAppointmentWithAppointmentId:(NSString *)appointmentId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取顾客预约祥情
+ (void)postGetAppointmentDetailWithAppointmentId:(NSString *)appointmentId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//编辑顾客预约
+ (void)postEditCustomerAppointmentWithModel:(MEAddCustomerAppointmentModel *)model appointmentId:(NSString *)appointmentId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/

/*********************************************/
#pragma mark - 运营管理
//运营管理首页数据
+ (void)postGetOperationDataWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//员工排名
+ (void)postGetClerkRankingDatasWithType:(NSInteger)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//服务项目排名
+ (void)postGetObjectRankingDatasWithDateType:(NSInteger)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取项目列表
+ (void)postGetObjectListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除项目
+ (void)postDeleteObjectsWithObjectId:(NSInteger)objectId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//修改项目
+ (void)postEditObjectWithObjectId:(NSInteger)objectId objectName:(NSString *)objectName money:(NSString *)money SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//添加项目
+ (void)postAddObjectWithObjectName:(NSString *)objectName money:(NSString *)money SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/

/*********************************************/
#pragma mark - 联通充值
//获取门店确认充值联通订单
+ (void)postTopUpLianTongOrderWithOrderSn:(NSString *)orderSn SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//佣金祥情统计
+ (void)postGetLianTongBrokerageDetailWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//门店联通订单提现
+ (void)postLianTongDestoonFinanceCashWithAttrModel:(MEWithdrawalParamModel *)attrModel successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/

/*********************************************/
#pragma mark - C端课程
//课程详情
+ (void)postGetCourseDetailWithCourseId:(NSInteger)courseId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//VIP会员课程套餐
+ (void)postGetCourseVIPDetailWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//创建VIP课程订单
+ (void)postCreateVIPOrderWithCourseId:(NSString *)courseId orderType:(NSString *)orderType successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//我的VIP
+ (void)postGetMyCourseVIPDetailWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//课程点赞
+ (void)postSetLikeCourseWithCourseId:(NSInteger)courseId SuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取B端C端VIP
+ (void)postGetCourseVIPWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/


/*********************************************/
#pragma mark - 志愿者
//申请志愿者
+ (void)postRegisterVolunteerWithModel:(MERegisterVolunteerModel *)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//申请志愿者-协议
+ (void)postGetVolunteerProtocolWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取社区服务分类
+ (void)postGetCommunityServericeClassifyListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//社区服务详情
+ (void)postGetServiceDetailWithServiceId:(NSInteger)serviceId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取公益秀分类列表
+ (void)postGetUsefulactivityClassifyListWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//点赞/取消点赞
+ (void)postPraiseShowWithShowId:(NSInteger)showId status:(NSInteger)status successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//公益秀详情
+ (void)postGetPublicShowDetailWithShowId:(NSInteger)showId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//公益秀评论
+ (void)postCommentPublicShowWithShowId:(NSString *)showId content:(NSString *)content successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取服务类型
+ (void)postGetRecruitServiceTypeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//招募活动详情
+ (void)postGetRecruitDetailWithRecruitId:(NSInteger)recruitId latitude:(NSString *)latitude longitude:(NSString *)longitude successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//招募活动-关注/取消关注
+ (void)postPraiseRecruitWithRecruitId:(NSInteger)recruitId status:(NSInteger)status successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//招募活动-报名/取消报名
+ (void)postJoinRecruitWithRecruitId:(NSInteger)recruitId status:(NSInteger)status successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//招募活动留言咨询
+ (void)postCommentRecruitActivityWithActivityId:(NSString *)activityId content:(NSString *)content successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//招募活动留言咨询 回复
+ (void)postCommentBackRecruitActivityWithCommentId:(NSString *)commentId content:(NSString *)content successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//验证活动编码
+ (void)postCheckSignInCodeWithCode:(NSString *)code successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//签到
+ (void)posSignUpWithSignInCode:(NSString *)signInCode latitude:(NSString *)latitude longitude:(NSString *)longitude successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//签退
+ (void)posSignOutWithSignInCode:(NSString *)signInCode latitude:(NSString *)latitude longitude:(NSString *)longitude successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//志愿者视力预约详情
+ (void)postGetVolunteerReserveDetailWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//志愿者详情
+ (void)postGetVolunteerDetailWithVolunteerId:(NSInteger)volunteerId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//点赞志愿者
+ (void)postPraiseVolunteerWithVolunteerId:(NSInteger)volunteerId status:(NSInteger)status successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//关注志愿者
+ (void)postAttentionVolunteerWithVolunteerId:(NSInteger)volunteerId status:(NSInteger)status successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取机构服务类型
+ (void)postGetServiceTypeWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//申请志愿者组织
+ (void)postApplyOrganizationWithApplyModel:(MEApplyOrganizationModel *)model successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//组织详情
+ (void)postGetOrganizationDetailWithOrganizationId:(NSInteger)organizationId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//关注机构
+ (void)postAttentionOrganizationWithOrganizationId:(NSInteger)organizationId status:(NSInteger)status successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//加入/退出机构
+ (void)postJoinOrganizationWithOrganizationId:(NSInteger)organizationId status:(NSInteger)status successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//删除评论
+ (void)postDeleteCommentWithCommentId:(NSString *)commentId successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//个人资料
+ (void)postGetMyInfoWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//修改昵称
+ (void)postEditNickNameWithNickName:(NSString *)nickName successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//修改签名
+ (void)postEditSignatureWithSignature:(NSString *)signature successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;

//获取我的资金
+ (void)postGetMyAccountWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//设置/修改支付密码
+ (void)postSetPayPasswordWithPassword:(NSString *)password rPassword:(NSString *)rPassword type:(NSString *)type phone:(NSString *)phone code:(NSString *)code successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//获取短信验证码--New
+ (void)postGetNewCodeWithPhone:(NSString *)phone type:(NSString *)type successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//余额支付
+ (void)postBuyCourseWithOrderSn:(NSString *)orderSn type:(NSString *)type password:(NSString *)password successBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
//充值协议
+ (void)postGetTopUpProtocolWithSuccessBlock:(RequestResponse)successBlock failure:(kMeObjBlock)failure;
/*********************************************/


+ (MBProgressHUD *)commitWithHUD:(NSString *)str;

@end
