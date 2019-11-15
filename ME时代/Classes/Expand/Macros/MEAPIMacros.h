//
//  MEAPIMacros.h
//  志愿星
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#ifndef MEAPIMacros_h
#define MEAPIMacros_h

//#warning -mustNotes 上线一定要注释/海报分享产品分享

#define TestVersion

//域名 develop
#ifdef TestVersion
#define BASEIP @"https://test.meshidai.com/api/"
//#define BASEIP @"https://develop.meshidai.com/api/"
//#define BASEIP @"http://test_dev.meshidai.com/api/"
#else
#define BASEIP @"https://msd.meshidai.com/api/"
#endif

#define kGetApiWithUrl(url) [BASEIP stringByAppendingString:url]


#define MEIPgetQiniuToken @"getQiniuTokenPermanent"

#pragma makr - TEST
#define MEIPgetTokenByFour @"common/user/getTokenByFour"

/*********************************************/
//网络状态码

#define kNetSuccess @"200"
#define kNetTokenInvalid @"401"
#define kNetError @"503"
#define kNetInvateCode @"502"

/*********************************************/
//苹果内购
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/*********************************************/

/*********************************************/
#pragma makr - ai
//查询 雷达(底部导航) 时间 访问人数数据信息
#define MEIPcommonairadartime @"common/airadar/time"
//互动次数查询
#define MEIPcommonairadarcommunication @"common/airadar/communication"
//雷达--行为
#define MEIPcommonaigetMemberBehavior @"common/airadar/getMemberBehavior"
//客户   -  加入时间
#define MEIPcommonaigetjoinTime @"common/airadar/joinTime"
//客户 -   活跃时间
#define MEIPcommonaigetactive @"common/airadar/active"
//客户 -   跟进
#define MEIPcommonaigetupdateFollow @"common/airadar/follow"
//客户搜索
#define MEIPcommonaigetsearch @"common/airadar/search"
//客户详情(雷达)
#define MEIPcommonaigetMemberDetail @"common/airadar/getMemberDetail"
//用户访问记录
#define MEIPcommonaigetMemberVisit @"common/airadar/getMemberVisit"
//获取客户资料
#define MEIPcommonaigetCustomerDetail @"common/airadar/customerDetail"
//修改客户资料
#define MEIPcommonaiupdateDetail @"common/airadar/updateDetail"
//实际跟进阶段   更新
#define MEIPcommonaiupdateFollow @"common/airadar/updateFollow"
//获取标签列表
#define MEIPcommonaigetLabel @"common/label/getLabel"
//设置用户标签
#define MEIPcommonaisetMemberLabel @"common/user/setMemberLabel"
//跟进投票用户（点击打电话时调用）
#define MEIPcommonaifollowUpMember @"common/followup/followUpMember"
//Ai雷达点战友（点击发消息时调用）
#define MEIPcommonaiAddCommunicationLog @"common/airadar/addCommunicationLog"


//行为--查看店铺
#define MEIPcommonAIBehaviorVisitStore @"common/airadar/behaviorVisitStore"
//行为--分享店铺
#define MEIPcommonAIBehaviorShareStore @"common/airadar/behaviorShareStore"
//行为--查看拼团活动
#define MEIPcommonAIBehaviorLookGroupBuyActivity @"common/airadar/behaviorLookGroupBuyActivity"
//行为--查看服务项目
#define MEIPcommonAIBehaviorLookServices @"common/airadar/behaviorLookServices"
/*********************************************/

/*********************************************/
#pragma makr - goodMannger
//获取门店权限
#define MEIPcommonggetStorePower @"common/store/getStorePower"
//申请
#define MEIPcommongGoodsGetStoreGoods @"common/goods/getStoreGoods"
//获取规格
#define MEIPcommonggetSpecName @"common/goods/getSpecName"
//获取门店商品类型
#define MEIPcommonggetStoreGoodsType @"common/goods/getStoreGoodsType"
//添加修改商品
#define MEIPcommonAddOrEditGoods @"common/goods/commonAddOrEditGoods"
//删除自定义商品
#define MEIPcommonDelStoreGoods @"common/goods/delStoreGoods"
//门店自定义商品祥情
#define MEIPcommonStoreGoodsDetail @"common/goods/storeGoodsDetail"
/*********************************************/
#pragma makr - xunweishi

//申请
#define MEIPcommongXunweishiApply @"common/xunweishi/apply"
//申请记录
#define MEIPcommongXunweishiApplyList @"common/xunweishi/applyList"
//申请祥情
#define MEIPcommongXunweishiDetail @"common/xunweishi/detail"

/*********************************************/
#pragma makr - BRAND
//总览
#define MEIPcommongStoreOverview @"common/store/storeOverview"
//排行榜
#define MEIPcommongCustomerRankingList @"common/store/customerRankingList"
//数据分析
#define MEIPcommongStoreDatAnalysis @"common/store/storeDatAnalysis"
//AI分析
#define MEIPcommongAiRank @"common/store/aiRank"
//能力排行
#define MEIPcommongAbilityRank @"common/store/abilityRank"
//来访记录
#define MEIPcommongStoreAccessCount @"common/store/storeAccessCount"
/*********************************************/
#pragma makr - IM
//获取tls用户信息
#define MEIPcommongUserInfoByTls @"common/user/getUserInfoByTls"

/*********************************************/
#pragma makr - 动态
//动态列表
#define MEIPcommongetDynamicList @"common/dynamic/getDynamicList"
//点赞
#define MEIPcommongetDynamicpraise @"common/dynamic/praise"
//评论
#define MEIPcommongetDynamiccommentt @"common/dynamic/comment"
//删除
#define MEIPcommongetDynamiDelDynamic @"common/dynamic/delDynamic"
//发表
#define MEIPcommongetGetVotingComment @"common/dynamic/addDynamic"
//上传图片
#define MEIPcommonUploadImages @"common/common/uploadImages"

//意见反馈
#define MEIPcommonFeedbBack @"common/feedback/feedback"
/*********************************************/


/*********************************************/
#pragma makr - JD
//关键词商品查询接口
#define MEIPcommonjingdonggoodsgoodsQuery @"common/jingdong/goodsQuery"

//京粉精选商品查询接口
#define MEIPcommonjingdonggoodsJingFen @"common/jingdong/goodsJingFen"
//京东获取佣金商品详情
#define MEIPcommongetCommissionGoodsDetail @"common/jingdong/getCommissionGoodsDetail"
/*********************************************/

/*********************************************/
#pragma makr - JD
#define MEIPcommondJDgoodsPromotionUrlGenerate @"common/jingdong/createdPromotedByUnionid"
/*********************************************/


/*********************************************/
#pragma makr - pinduoduo
//获取拼多多商品列表
#define MEIPcommonduoduokeGetgetGoodsList @"common/duoduoke/getGoodsList"
//商品详情
#define MEIPcommonduoduokeGetgetGoodsInfo @"common/duoduoke/getGoodsInfo"
//多多进宝推广链接生成
#define MEIPcommonduoduokegoodsPromotionUrlGenerate @"common/duoduoke/goodsPromotionUrlGenerate"
//佣金祥情--商品
#define MEIPcommonduoduokeGetBrokerageDetailGoods @"common/duoduoke/getBrokerageDetailGoods"
//佣金祥情
#define MEIPcommonduoduokeGetBrokerageDetailBase @"common/duoduoke/getBrokerageDetailBase"


//获取新优选推荐商品列表
#define MEIPcommonGetRecommendGoodsLit @"common/duoduoke/getRecommendGoodsLit"
/*********************************************/


/*********************************************/
#pragma makr - taobao
//获取淘宝客Banner
#define MEIPcommonTaobaokeGetgetTbkBanner @"common/taobaoke/getTbkBanner"
//淘宝分类
#define MEIPcommonTaobaokeGetCategory @"common/taobaoke/getCategory"
//好券列表
#define MEIPcommonTaobaokeGetCoupon @"common/taobaoke/getCoupon"
//好券商品祥情
#define MEIPcommonTaobaokeGetGoodsInfo @"common/taobaoke/getGoodsInfo"
//淘口令
#define MEIPcommonTaobaokeGetGetTpwd @"common/taobaoke/getTpwd"
//通用物料搜索API
#define MEIPcommonTaobaokeGetDgMaterialOptional @"common/taobaoke/dgMaterialOptional"
//推广券信息查询
#define MEIPcommonTaobaokeGetTbkCouponGet @"common/taobaoke/tbkCouponGet"
//聚划算列表
#define MEIPcommonTaobaokeGetTbkJuItemsSearch @"common/taobaoke/tbkJuItemsSearch"

//猜你喜欢
#define MEIPcommonTaobaokeGetGuessLike @"common/taobaoke/guessLike"

//查找用户渠道
#define MEIPcommonTaobaokecheckMemberRelation @"common/taobaoke/checkMemberRelation"
//获取淘宝渠道备案URL
#define MEIPcommonTaobaokecheckgetInviterUrl @"common/taobaoke/getInviterUrl"
//获取我的淘优惠券明细
#define MEIPcommonTaobaokecheckgetMyTbkOrder @"common/taobaoke/getMyTbkOrder"

//通过Session获取relation_id
#define MEIPcommonTaobaokePublisherInfoSave @"common/taobaoke/scPublisherInfoSave"

/*********************************************/



/*********************************************/
#pragma makr - coupon

//获取优惠券Banner
#define MEIPcommonGetConponsBanner @"common/ad/getConponsBanner"

/*********************************************/




/*********************************************/
#pragma makr - bargain
//砍价商品列表
#define MEIPcommonGetBarginGoodsList @"common/bargin/barginGoodsList"
//我的砍价列表
#define MEIPcommonGetMyBarginList @"common/bargin/myBarginList"
//砍价
#define MEIPcommonGetBargin @"common/bargin/bargin"
//砍价详情
#define MEIPcommonGetMemberBarginDetail @"common/bargin/memberBarginDetail"
//砍价详情
#define MEIPcommonGetAllBarginLog @"common/bargin/getAllBarginLog"
//领取砍价商品
#define MEIPCommonPrizeCreateBargainOrder @"common/order/barginOrder"
/*********************************************/




/*********************************************/
#pragma makr - Group
//拼团商品列表
#define MEIPcommonGetGroupList @"common/marketing/groupList"
//拼团活动详情
#define MEIPcommonGetGroupInfo @"common/marketing/groupInfo"
//获取拼团的人员信息
#define MEIPcommonGetGroupUser @"common/marketing/getGroupUser"
//生成拼团订单
#define MEIPCommonCreateGroupOrder @"common/marketing/createGroupOrder"
//获取拼团订单列表
#define MEIPCommonGetGroupOrder @"common/marketing/getGroupOrder"
//获取拼团订单详情
#define MEIPCommonGetGroupOrderDetail @"common/marketing/getGroupOrderDetail"

/*********************************************/




/*********************************************/
#pragma makr - gift

//获取礼品首页banner
#define MEIPcommonGetGiftBanner @"common/ad/getGiftBanner"

/*********************************************/


/*********************************************/
#pragma makr - B&Clerk share
//商品编码
#define MEIPcommonGoodsEncode @"common/goods/getProductShareText"
//商品解码
#define MEIPcommonGoodsDecode @"common/goods/getDecodeShareText"

/*********************************************/




/*********************************************/
#pragma makr - B deal
//预约完成B端
#define MEIPcommonfinishReserve @"common/reserve/finishReserve"
//预约取消B端
#define MEIPcommoncancelReserve @"common/reserve/cancelReserve"
//预约列表B端
#define MEIPcommonreserveListB @"common/reserve/reserveListB"
//B端数据统计
#define MEIPcommonstatistics @"common/order/statistics"
//预约祥情B端
#define MEIPcommonreserveDetailB @"common/reserve/reserveDetailB"

//我的佣金
#define MEIPcommonMyBrokerage @"common/order/myBrokerage"
//佣金明细
#define MEIPcommonBrokerageDetail @"common/order/brokerageDetail"

/*********************************************/

/*********************************************/
#pragma makr - Withdrawal
//提现申请
#define MEIPcommondestoonFinanceCash @"common/money/destoonFinanceCash"
//提现列表
#define MEIPcommondestoonFinanceCashListh @"common/money/destoonFinanceCashList"
//提现明细
#define MEIPcommondestoonFinanceCashDetail @"common/money/destoonFinanceCashDetail"
/*********************************************/


/*********************************************/
#pragma makr - clerk

//店员列表
#define MEIPcommonMyClerk @"common/user/myClerk"
//会员列表
#define MEIPcommonMemberList @"common/user/memberList"
//删除店员
#define MEIPcommonClerkToMember @"common/user/clerkToMember"
//会员升级为店员
#define MEIPcommonMemberToClerk @"common/user/memberToClerk"
//店员排名列表
#define MEIPcommonMyClerkOrder @"common/user/myClerkOrder"
//获取店员系统设置分佣比例、及本店的设置
#define MEIPcommongetClerkCommissionPercent @"common/web/getClerkCommissionPercent"
//设置门店店员分佣比例
#define MEIPcommonsetClerkCommissionPercent @"common/store/setClerkCommissionPercent"

/*********************************************/



/*********************************************/
#pragma makr - AD

//广告banner
#define MEIPcommonAdGetAd @"common/ad/getAd"
//获取Banner
#define MEIPcommonGetBanner @"common/ad/getBanner"
/*********************************************/

/*********************************************/
#pragma makr - home
//获取首页导航分类-新2019-10-22
#define MEIPcommonGetHomeNav @"common/home/getHomeNav"
//获取淘宝客首页导航分类
#define MEIPcommonGetMaterial @"common/taobaoke/getMaterial"

//兑换审核状态
#define MEIPcommonredeemgetStatus @"common/redeemcode/getStatus"

//兑换信息
#define MEIPcommonredeemcodeinfo @"common/redeemcode/info"
//添加兑换
#define MEIPcommonredeemcodeaddCode @"common/redeemcode/addCode"

//获取秒杀商品
#define MEIPcommonGetgetSeckillGoods @"common/home/getSeckillGoods"
//获取秒杀时间
#define MEIPcommonGetgetSeckillTime @"common/home/getSeckillTime"

//获取首面的背景和banner
#define MEIPcommonGetActivity @"common/activity/getActivity"
//获取首页样式
#define MEIPcommonGetMystyle @"common/mystyle/getMystyle"
//获取通知消息
#define MEIPcommonGetMessage @"common/message/getMessage"
//获取2.0首页数据
#define MEIPcommonGetThridHomeBase @"common/home/getHomeBase"
//app获取店铺信息
#define MEIPcommonappHomePageData @"common/store/appHomePageData"

//apphome 爆款专区
#define MEIPcommonappYThirdHomeHotGood @"common/goods/getIndexHotGoods"

//获取APP首页标题
#define MEIPcommonGetAppHomeTitle @"getAppHomeTitle"
//获取首页推荐商品/活动 2019-7-31
#define MEIPcommonhomeGetHomeRecommendGoodsAndActivity @"common/home/getHomeRecommendGoodsAndActivity"
//获取首页推荐产品（商品、砍价、拼团、秒杀）2019-7-23
#define MEIPcommonhomeGetHomeRecommend @"common/home/getHomeRecommend"
//获取首页推荐产品(2019-04-30)
#define MEIPcommonhomegetRecommend @"common/home/getRecommend"
//获取推荐产品和抢购产品
#define MEIPcommonhomegetRecommendAndSpreebuy @"common/home/recommendAndSpreebuy"

//APP首页各入口选项
#define MEIPcommonGetHomeOptions @"common/home/getHomeOptions"
/*********************************************/



/*********************************************/
#pragma makr - articel
//文章分类列表
#define MEIPcommonGetArticleClass @"common/article/getArticleClass"
//获取文章列表
#define MEIPcommonGetArticle @"common/article/getArticle"
//文章详情
#define MEIPcommonFindArticle @"common/article/findArticle"
//分享文章
#define MEIPcommonShareAricel @"common/article/shareArticle"
//文章统计
#define MEIPcommonCountArticlel @"common/article/countArticle"
//访问统计
#define MEIPcommonGetAccess @"common/article/getAccess"
//获取客户
#define MEIPcommonGetAccessUser @"common/article/getAccessUser"
//文章传播路径
#define MEIPcommonGetSpreadPath @"common/article/spreadPath"
//海报传播路径
#define MEIPcommonGetPosterSpreadPath @"common/posters/posterSpreadPath"
//设为意向客户
#define MEIPcommonSetIntentioUser @"common/article/setIntentioUser"
//访问用户详情
#define MEIPcommonVistorUserInfo @"common/article/getSpreadUser"
/*********************************************/



/*********************************************/
#pragma makr - poster

//获取海报分类
#define MEIPcommonGetPostersClass @"common/posters/getPostersClass"
//根据分类获取海报列表
#define MEIPcommonFindPostersClass @"common/posters/findPostersClass"
//分享海报
#define MEIPcommonSharePoster @"common/posters/sharePoster"
//获取分享海报
#define MEIPcommonGetSharePoster @"common/posters/getSharePoster"
//获取活动海报列表
#define MEIPadminGetActivePoster @"common/groupfission/getActivity"
//查询会员当前活动任务情况
#define MEIPadminGetAppGetShare @"common/posters/getActivityLog"
//删除海报
#define MEIPcommonDelSharePosters @"common/posters/delSharePosters"
//获取活动海报二维码
#define MEIPadminappGetQrcode @"common/groupfission/appGetQrcode"
/*********************************************/


/*********************************************/
#pragma makr - member

//获取超级会员数据
#define MEIPcommonSupportMember @"common/goods/supportMember"
//获取兑换商品
#define MEIPcommonFindManyGoods @"common/goods/findManyGoods"

/*********************************************/




/*********************************************/
#pragma makr - Stroe
//app更新店铺商家信息
#define MEIPcommonUpdateStoreInfo @"common/store/updateStoreInfo"
//app获取店铺商家信息
#define MEIPcommonFindStoreInfo @"common/store/findStoreInfo"
//门店列表
#define MEIPcommonStoreStoreList @"common/store/getStoreList"
//门店祥情
#define MEIPcommonStoreGetStore @"common/store/getStore"
//服务详情
#define MEIPcommonserviceDetail @"common/goods/serviceDetail"
//提及服务
#define MEIPcommonCreateReserve @"common/reserve/createReserve"

#define MEIPcommonStoreSelectStore @"common/store/selectStore"
/*********************************************/



/*********************************************/
#pragma makr - Custom

//获取客服id
#define MEIPAppUserGetCustomer @"app/user/getCustomer"
//获取客服信息
#define MEIPCustomerGetUserInfo @"customer/auth/getCustomerInfo"
//获取用户信息
#define MEIPUserGetUserInfo @"common/user/getUser"
//获取平台技术客服微信
#define MEIPGetCustomerService @"common/service/getCustomerService"
/*********************************************/




/*********************************************/
#pragma makr - Goods

//商品列表
#define MEIPcommonGoodsGetGoodsList @"common/goods/getGoodsList"
//商品详情
#define MEIPcommonGoodsGoodsDetail @"common/goods/goodsDetail"
//获取库存和价格
#define MEIPcommonGoodsGetPriceAndStock @"common/goods/getPriceAndStock"
//首页商品列表
#define MEIPcommonGoodsGoodsType @"common/goods/goodsType"
//详情推荐
#define MEIPcommonGoodsRecommend @"common/goods/getRecommend"
//获取980活动祥情
#define MEIPcommonGoodsComboDetail @"common/goods/goodsComboDetail"
//app分享
#define MEIPWechatAuthShare @"wechat/auth/index"
//app文章分享
#define MEIPWechatAuthArticelShare @"wechat/auth/article"
//分类
#define MEIPGoodsGetCategory @"common/goods/getCategory"
//抢购
#define MEIPGoodsRush @"common/ad/getPopUp"
//获取推荐到首次购买活动商品
#define MEIPRecommendProduct @"common/goods/getRecommendProduct"
//获取商品评论
#define MEIPRecommenGetGoodsComment @"common/goods/getGoodsComment"
/*********************************************/





/*********************************************/
#pragma makr - UserCentre
//获取当前用户的门店祥情
#define MEIPcommonGetMemberStoreInfo @"common/store/getMemberStoreInfo"
//门店申请、或修改申请
#define MEIPcommonStoreApply @"common/store/storeApply"
//新门店申请、或修改申请
#define MEIPcommonNewStoreApply @"common/store/NewStoreApply"
//一键已读
#define MEIPcommonAllreadedNotice @"common/message/listRead"
//已读消息
#define MEIPcommonreadedNotice @"common/message/findRead"
//获取未读的推送信息
#define MEIPcommonUnreadNotice @"common/message/getJpush"
//获取通知列表
#define MEIPcommonNotice @"common/message/getJpushList"
//获取未读总数
#define MEIPcommonCountList @"common/message/countList"
//3.0.1获取通知列表
#define MEIPcommonNotices @"common/message/getList"
//获取个人中心的数据
#define MEIPcommonUserUserCentre @"common/user/userCentre"
//获取商家分销中心
#define MEIPcommonAdminDistribution @"common/user/adminDistribution"
//获取用户全部订单
#define MEIPcommonUserGetOrderList @"common/user/getOrderList"
//自提订单
#define MEIPcommongetStoreGetOrderList @"common/user/getStoreGetOrder"
//获取订单详情
#define MEIPcommonUserGetOrderDetail @"common/user/getOrderSnDetail"
//设置到店领取订单(已提取)
#define MEIPcommoncheckStoreGetOrderStatus @"common/user/checkStoreGetOrderStatus"
//分销中心数据
#define MEIPcommonUserDistribution @"common/user/distribution"
//获取分销订单信息
#define MEIPcommonUserGetDistributionOrder @"common/user/getDistributionOrder"
//获取团队 C
#define MEIPcommonUserGetTeam @"common/user/getTeam"
//获取C端以上用户列表 B
#define MEIPcommonUserGetAdminTeam @"common/user/getAdminTeam"
//获取C端以上用户的订单明细 B
#define MEIPcommonUserGetAdminOrder @"common/user/getAdminOrder"
//获取C端二维码
#define MEIPcommonUserGetCode @"common/user/getWechatCode"
//获取C端二维码背景图
#define MEIPcommonUserGetGeneralizeTheBackground @"common/user/getGeneralizeTheBackground"

//第二版 获取首页数据
//#define MEIPGetHomePageData @"homePageData"
//判断是否完成首单
#define MEIPcommonCheckFirstBuy @"common/user/checkFirstBuy"
//获取用户信息
#define MEIPcommonGetUser @"common/user/getUser"
//我的入口
#define MEIPcommonGetUserMenu @"common/my/menu"
//我的入口(新)
#define MEIPcommonGetUserMenuAll @"common/my/menuAll"
//获取用户的邀请码
#define MEIPcommonGetInvitationCode @"common/user/getInvitationCode"

//获客图文-海报
#define MEIPcommonposterspostersVisitList @"common/posters/postersVisitList"
//获客图文-文章
#define MEIPcommonpostersarticleVisitList @"common/article/articleVisitList"


//获取用户佣金订单
#define MEIPcommonUserGetRatioOrder @"common/user/getRatioOrder"
/*********************************************/





/*********************************************/
#pragma makr - Order

//用户支付
#define MEIPcommonOrderPayOrder @"common/order/payOrder"
//订单轮询
#define MEIPcommonOrderGetOrderStatus @"common/order/getOrderStatus"
//普通下单
#define MEIPcommonOrderCreateOrder @"common/order/createOrder"
//生成兑换订单
#define MEIPcommonOrderConvertOrde @"common/order/convertOrder"
//购物车下单
#define MEIPcommonOrderCartOrder @"common/order/cartOrder"
//取消订单
#define MEIPcommonOrderCancelOrder @"common/order/cancelOrder"
//支付订单
#define MEIPCommonOrderPayOrder @"common/order/payOrder"
//获取物流
#define MEIPCommongetLogist @""


//退款列表
#define MEIPCommonOrderRefundList @"common/order/refundList"
//申请退款
#define MEIPCommonOrderApplyRefund @"common/order/applyRefund"
//退款详情
#define MEIPCommonOrderRefundDetail @"common/order/refundDetail"

/*********************************************/


/*********************************************/
#pragma makr - Prize 签到抽奖
//今日福利
#define MEIPCommonPrizeToday @"common/prize/prizeToday"
//往期福利
#define MEIPCommonPrizeHistory @"common/prize/prizeHistory"
//抽奖活动详情
#define MEIPCommonPrizeDetails @"common/prize/prizeDetails"
//参加抽奖活动
#define MEIPCommonPrizeJoin @"common/prize/prizeJoin"
//查看抽奖活动图文详情
#define MEIPCommonPrizeLookContent @"common/prize/prizeLookContent"
//查看抽奖活动参与人数
#define MEIPCommonPrizeJoinUserList @"common/prize/prizeJoinUserList"
//领取抽奖商品
#define MEIPCommonPrizeCreateOrder @"common/prize/createOrder"
//查看全部总数
#define MEIPCommonPrizeJoinUserCount @"common/prize/prizeJoinUserCount"
/*********************************************/

/*********************************************/
#pragma makr - auth
//添加极光注册id
#define MEIPAPPAuthAddRegId @"app/auth/addRegId"


/*********************************************/


/*********************************************/
#pragma makr - ShopCart

//购物车列表
#define MEIPcommonCartCartGoodsList @"common/cart/cartGoodsList"
//加入购物车
#define MEIPcommonCartAddCart @"common/cart/addCart"
//删除购物车
#define MEIPcommonCartDeleteCart @"common/cart/deleteCart"
//购物车数量修改
#define MEIPcommonCartEditCartNum @"common/cart/editCartNum"
/*********************************************/


/*********************************************/
#pragma makr - AppointMent

//查看自己的预约订单
#define MEIPcommonGetReserveList @"common/reserve/getReserveList"
//取消预约
#define MEIPcommonDeleteReserve @"common/reserve/deleteReserve"
//获取预约详情
#define MEIPcommonUserGetAppointDetail @"common/reserve/reserveDetail"


/*********************************************/





/*********************************************/
#pragma makr - Address

//收货地址列表
#define MEIPcommonAddressAddressList @"common/address/addressList"
//新增收货地址 warn
#define MEIPcommonAddressAddAddress @"common/address/addAddress"
//获取某个地址详情
#define MEIPcommonAddressGetOneAddress @"common/address/getOneAddress"
//获取默认地址
#define MEIPcommonAddressGetdefaultAddress @"common/address/defaultAddress"

//获取结算页邮费
#define MEIPcommonAddressGetOrderFreight @"common/order/orderFreight"
//获取购物车结算页邮费
#define MEIPcommonAddressGetOrderFreightB @"common/order/orderFreightB"

//获取到店领取的店铺地址
#define MEIPcommonAddressGetStoreAddress @"common/address/addStoreAddress"


//编辑收货地址
#define MEIPcommonAddressEditAddress @"common/address/editAddress"
//删除地址
#define MEIPcommonAddressDelAddres @"common/address/delAddress"
//搜索产品
#define MEIPcommonFindGoods @"common/goods/findGoods"
//是否显示优选me的banner和分类是否显示
#define MEIPcommonGetYouxuanAdGoodsShow @"common/web/getYouxuanAdGoodsShow"

//获取新优选banner图
#define MEIPcommonGetYouxianBanner @"common/ad/getYouxianBanner"
//获取新优选banner图（新）
#define MEIPcommonGetYouxianBannerNew @"common/ad/getYouxianBannerNew"
//获取聚划算banner图
#define MEIPcommonGetSpecialSalsesBanner @"common/ad/specialSalsesBanner"
//首页公告栏
#define MEIPcommonGetHomeBulletin @"common/home/getHomeBulletin"
/*********************************************/


/*********************************************/
#pragma makr - question
//获取常见问题列表
#define MEIPcommonGetQuestionList @"common/problem/problem"
//获取常见问题详情
#define MEIPcommonGetQuestionDetail @"common/problem/problemDetail"

/*********************************************/



/*********************************************/
#pragma makr - record
//记录点击数
#define MEIPGetClickRecord @"common/clickrecord/record"
//批量记录点击数
#define MEIPGetClickRecordAll @"common/clickrecord/recordAll"

/*********************************************/



/*********************************************/
#pragma makr - aboutUser
//新手指南G
#define MEIPguidegetList @"common/guide/getList"
//电子协议
#define MEIPWebgetAgreement @"common/web/getAgreement"
//微信授权登录
#define MEIPAppAuthLogin @"app/auth/login"
//app获取验证码
#define MEIPAppGetCodel @"app/auth/getMesCode"
//手机号登录
#define MEIPLoginByPhone @"app/auth/loginByPhone"
//wep绑定手机号码
#define MEIPaddPhone @"weapp/user/addPhone"
//修改手机号
#define MEIPeditPhone @"app/user/editPhone"

//通过邀请码查询上级信息
#define MEIPGetCodeMsg @"common/user/getCodeMsg"
//邀请码绑定关系
#define MEIPGetBindingParent @"common/user/bindingParent"

#define MEIPAddShare @"app/user/addShare"
//获取权益
#define MEIPcommonWebGetEquities @"common/web/getEquities"
#define MEIPShare [NSString stringWithFormat:@"%@?code=%@",kGetApiWithUrl(MEIPWechatAuthShare),kMeUnNilStr(kCurrentUser.uid)]
#define MEIPArticelShare [NSString stringWithFormat:@"%@?code=%@&pid=0&article_id=",kGetApiWithUrl(MEIPWechatAuthArticelShare),kMeUnNilStr(kCurrentUser.uid)]
#define MEIPposterShare @""
//获取赠送小程序的到期时间
#define MEIPExpMiniprogramAt @"common/user/getExpMiniprogramAt"
//获取app版本
#define MEIPGetAPPVersion @"getAppVersion"
//新的获取app更新版本
#define MENewIPGetAPPVersion @"checkAppVersions"

/*********************************************/

/*********************************************/
#pragma makr - 测试题
//删除测试库
#define MEIPcommonbankdelBank @"common/bank/delBank"
//添加测试库
#define MEIPcommonbankaddBank @"common/bank/addBank"
//测试题库详情
#define MEIPcommonbanktestBank @"common/bank/testBank"
//修改测试库
#define MEIPcommonbankeditBank @"common/bank/editBank"
//历史测试库
#define MEIPcommonbankhistoryTest @"common/bank/historyTest"
//平台测试库
#define MEIPcommonbankplatformTest @"common/bank/platformTest"
//测试规则
#define MEIPcommonbankrule @"common/bank/rule"

/*********************************************/


/*********************************************/
#pragma makr - 在线课程
//在线课堂首页
#define MEIPcommonOnlineHomeIndex @"common/online/index"
//视频
//视频分类
#define MEIPcommonVideoType @"common/video/getVideoType"
//视频首页信息
#define MEIPcommonVideoIndexList @"common/video/indexList"
//视频列表
#define MEIPcommonVideoList @"common/video/videoList"
//视频详情
#define MEIPcommonVideoDetail @"common/video/videoDetail"
//添加收藏
#define MEIPcommonOnlineCollection @"common/online/collection"
//取消收藏
#define MEIPcommonOnlineCancelCollection @"common/online/cancelCollection"

//音频
//音频分类
#define MEIPcommonAudioType @"common/audio/getAudioType"
//音频首页信息
#define MEIPcommonAudioIndexList @"common/audio/indexList"
//音频列表
#define MEIPcommonAudioList @"common/audio/audioList"
//音频详情
#define MEIPcommonAudioDetail @"common/audio/audioDetail"


//生成订单
#define MEIPcommonOnlineCreateOrder @"common/online/createOrder"
//支付订单
#define MEIPcommonOnlinePayOrder @"common/online/payOrder"
//轮询订单状态
#define MEIPcommonOnlineGetOrderStatus @"common/online/getOrderStatus"

//收藏列表
#define MEIPcommonOnlineCollectionList @"common/online/collectionList"

//订单列表
#define MEIPcommonOnlineGetOrderList @"common/online/orderList"


#pragma 新版B端
//学习计划首页
#define MEIPcommonOnlineHomeStudied @"common/home/studied"
//学习计划 音视频点赞
#define MEIPcommonVideoLikePraise @"common/online/videoLike"
//推荐学习（更多）
#define MEIPcommonHomeRecommentStudyList @"common/home/recommentStudyList"
//学习过的（更多）
#define MEIPcommonHomeStudiedList @"common/home/studiedList"
//收藏过的（更多）
#define MEIPcommonHomeCollectedList @"common/home/collectedList"
//学习（播放时调用）
#define MEIPcommonOnlineStudy @"common/online/study"

//获取一起创业banner
#define MEIPcommonADGetTypeBanner @"common/ad/getTypeBanner"
//获取一起创业banner
#define MEIPcommonOnlineGetCategory @"common/online/getCategory"
//一起创业列表
#define MEIPcommonOnlineGetLists @"common/online/getLists"
/*********************************************/



/*********************************************/
#pragma makr - 在线诊断
//诊断问题
#define MEIPcommonDiagnosisQuestion @"common/diagnosis/diagnosisQuestion"
//提交诊断问题
#define MEIPcommonAddDiagnosisQuestion @"common/diagnosis/addDiagnosis"

//诊断服务列表
#define MEIPcommonDiagnosisProduct @"common/diagnosis/diagnosisProduct"
//创建诊断订单
#define MEIPcommonDiagnosisCreateOrder @"common/diagnosis/createOrder"
//提交问题咨询
#define MEIPcommonDiagnosisAddProblem @"common/online/addProblem"
//我的诊断服务订单
#define MEIPcommonDiagnosisService @"common/diagnosis/diagnosisService"
//诊断反馈列表
#define MEIPcommonDiagnosisList @"common/diagnosis/diagnosisList"
//问题资讯详情
#define MEIPcommonProblemInfo @"common/online/problemInfo"
//诊断报告
#define MEIPcommonDiagnosisReport @"common/diagnosis/report"
//待回问题列表
#define MEIPcommonDiagnosisGetNoReply @"common/online/getNoReply"
//回复问题
#define MEIPcommonDiagnosisReply @"common/online/reply"
/*********************************************/


/*********************************************/
#pragma makr - 客户档案
//获取顾客分类列表
#define MEIPcommonCustomerClassifyList @"common/customerclassify/classifyList"
//删除顾客分类
#define MEIPcommonCustomerClassifyDel @"common/customerclassify/classifyDel"
//添加顾客分类
#define MEIPcommonCustomerClassifyAdd @"common/customerclassify/classifyAdd"

//获取顾客档案列表
#define MEIPcommonCustomerFilesList @"common/customerfiles/customerFilesList"
//新增顾客基本信息
#define MEIPcommonCustomerFilesAdd @"common/customerfiles/customerFilesAdd"
//获取顾客档案信息
#define MEIPcommonGetCustomerFilesInfo @"common/customerfiles/customerFilesInfo"
//修改顾客档案信息
#define MEIPcommonGetCustomerFilesEdit @"common/customerfiles/customerFilesEdit"
//删除顾客档案信息
#define MEIPcommonGetCustomerFilesDel @"common/customerfiles/customerFilesDel"

//修改顾客档案销售信息
#define MEIPcommonSetCustomerFilesSales @"common/customerfiles/setCustomerFilesSales"

//顾客档案跟进信息添加
#define MEIPcommonCustomerFilesFollowAdd @"common/customerfiles/customerFilesFollowAdd"
//顾客档案跟进信息修改
#define MEIPcommonCustomerFilesFollowEdit @"common/customerfiles/customerFilesFollowEdit"
//获取跟进方式列表
#define MEIPcommonGetFollowType @"common/followtype/getFollowType"

//获取生活习惯分类列表及选项
#define MEIPcommonLivingHabitList @"common/livinghabit/livingHabitList"
//获取顾客档案生活习惯-添加/修改
#define MEIPcommonSetCustomerFilesHabit @"common/customerfiles/setCustomerFilesHabit"

//添加生活习惯
#define MEIPcommonLivingHabitAdd @"common/livinghabit/livingHabitAdd"
//修改生活习惯
#define MEIPcommonLivingHabitEdit @"common/livinghabit/livingHabitEdit"
//删除生活习惯
#define MEIPcommonLivingHabitDel @"common/livinghabit/livingHabitDel"

//修改生活习惯分类
#define MEIPcommonLivingHabitClassifyEdit @"common/livinghabit/livingHabitClassifyEdit"
//添加生活习惯分类
#define MEIPcommonLivingHabitClassifyAdd @"common/livinghabit/livingHabitClassifyAdd"
//删除生活习惯分类
#define MEIPcommonLivingHabitClassifyDel @"common/livinghabit/livingHabitClassifyDel"
/*********************************************/


/*********************************************/
#pragma makr - 客户服务
//获取顾客服务列表
#define MEIPcommonCustomerServiceList @"common/customerservice/customerServiceList"
//通过手机号获取顾客档案-基本信息
#define MEIPcommonCustomerFilesDetailByPhone @"common/customerfiles/customerFilesDetailByPhone"
//获取顾客服务祥情
#define MEIPcommonCustomerServiceDetail @"common/customerservice/customerServiceDetail"
//删除顾客服务
#define MEIPcommonCustomerServiceDel @"common/customerservice/customerServiceDel"
//添加顾客服务
#define MEIPcommonCustomerServiceAdd @"common/customerservice/customerServiceAdd"
//添加/修改顾客服务--记录
#define MEIPcommonCustomerServiceLogAdd @"common/customerservice/customerServiceLogAddOrEdit"

//查看更多服务项目
#define MEIPcommonCustomerServiceServiceList @"common/customerservice/serviceList"
//查看更多服务记录
#define MEIPcommonCustomerServiceServiceLogs @"common/customerservice/serviceLogs"

/*********************************************/

/*********************************************/
#pragma makr - 客户消费
//获取消费顾客列表
#define MEIPcommonCustomerExpenseList @"common/customerexpense/expenseCustomerList"
//获取顾客消费祥情
#define MEIPcommonCustomerExpenseCustomerDetail @"common/customerexpense/expenseCustomerDetail"
//获取顾客消费记录
#define MEIPcommonCustomerExpenseExpenseList @"common/customerexpense/expenseList"
//添加顾客消费/充值
#define MEIPcommonCustomerExpenseAdd @"common/customerexpense/customerExpenseAdd"
//修改顾客消费/充值
#define MEIPcommonCustomerExpenseEdit @"common/customerexpense/customerExpenseEdit"
//顾客消费详情
#define MEIPcommonCustomerExpenseDetail @"common/customerexpense/expenseDetail"

//获取消费来源列表
#define MEIPcommonCustomerExpenseSourceList @"common/customerexpense/sourceList"
//获取产品性质列表
#define MEIPcommonCustomerExpenseNatureList @"common/customerexpense/natureList"
/*********************************************/


/*********************************************/
#pragma makr - 客户预约
//预约时间列表
#define MEIPcommonCustomerAppointmentDate @"common/customerappointment/appointmentDate"
//获取顾客预约列表
#define MEIPcommonCustomerAppointmentList @"common/customerappointment/customerAppointmentList"
//获取项目列表
#define MEIPcommonCustomerAppointmentObjectList @"common/customerobject/objectList"
//添加项目
#define MEIPcommonCustomerAppointmentObjectAdd @"common/customerobject/objectAdd"

//添加顾客预约
#define MEIPcommonCustomerAppointmentAdd @"common/customerappointment/customerAppointmentAdd"
//删除顾客预约
#define MEIPcommonCustomerAppointmentDel @"common/customerappointment/customerAppointmentDel"
//确认顾客预约
#define MEIPcommonCustomerAppointmentConfirm @"common/customerappointment/appointmentConfirm"
//获取顾客预约祥情
#define MEIPcommonCustomerAppointmentDetail @"common/customerappointment/customerAppointmentDetail"
//修改顾客预约
#define MEIPcommonCustomerAppointmentEdit @"common/customerappointment/customerAppointmentEdit"
/*********************************************/

/*********************************************/
#pragma makr - 运营管理
//运营管理首页数据
#define MEIPcommonStoreOperationData @"common/store/operationData"
//运营管理首页数据（新）
#define MEIPcommonStoreNewOperationData @"common/store/newOperationData"
//员工排名
#define MEIPcommonExpenseClerkRanking @"common/customerexpense/clerkRanking"
//服务项目排名
#define MEIPcommonExpenseObjectRanking @"common/customerexpense/objectRanking"
//店员总顾客数排名（今日）
#define MEIPcommonExpenseClerkCustomerNumOrder @"common/customerappointment/clerkCustomerNumOrder"
//店员手工费总数（今日）
#define MEIPcommonExpenseClerkWorkmanshipChargeOrder @"common/customerappointment/clerkWorkmanshipChargeOrder"

//获取项目列表
#define MEIPcommonCustomerObjectList @"common/customerobject/objectList"
//删除项目
#define MEIPcommonCustomerObjectDelete @"common/customerobject/objectDel"
//修改项目
#define MEIPcommonCustomerObjectEdit @"common/customerobject/objectEdit"
//添加项目
#define MEIPcommonCustomerObjectAdd @"common/customerobject/objectAdd"
/*********************************************/


/*********************************************/
#pragma makr - 运营管理
//获取用户联通订单
#define MEIPcommonOrderGetLianTongOrder @"common/order/getLianTongOrder"
//获取门店联通订单
#define MEIPcommonOrderGetStoreLianTongOrder @"common/order/getStoreLianTongOrder"
//获取门店联通订单
#define MEIPcommonOrderTopUpLianTongOrder @"common/order/topUpLianTongOrder"
//门店佣金统计
#define MEIPcommonOrderLianTongBrokerage @"common/order/liantongBrokerage"
//门店联通提现历史记录
#define MEIPcommonOrderLianTongWithdrawHistory @"common/order/liantongWithdrawHistory"
//门店联通订单提现
#define MEIPcommonOrderLianTongWithdrawDeposit @"common/order/liantongWithdrawDeposit"
/*********************************************/


/*********************************************/
#pragma makr - 个人课程
//首页课程列表
#define MEIPcommonCoursesGetCourses @"common/courses/getCourses"
//查看更多、公益课程、公益视力
#define MEIPcommonCoursesGetCoursesList @"common/courses/getCoursesList"
//课程详情
#define MEIPcommonCoursesGetCoursesDetail @"common/courses/getCoursesDetail"
//VIP会员课程套餐
#define MEIPcommonCoursesGetCoursesVIP @"common/courses/coursesVip"
//创建VIP课程订单
#define MEIPcommonCoursesCreateVIPOrder @"common/courses/createOrder"
//我的VIP
#define MEIPcommonCoursesGetMyCoursesVip @"common/courses/myCoursesVip"
//vip交易记录
#define MEIPcommonCoursesGetMyCoursesVipLog @"common/courses/myCoursesVipLog"
//课程点赞
#define MEIPcommonCoursesAddLike @"common/courses/addLike"
//获取B端C端VIP
#define MEIPcommonCoursesGetCoursesVIPNew @"common/courses/getCoursesVip"

//苹果支付订单
#define MEIPcommonOnlineApplePayNotify @"common/online/applePayNotify"
/*********************************************/


/*********************************************/
#pragma makr - 志愿者
//申请志愿者
#define MEIPcommonUserRegisterVolunteer @"common/user/registerVolunteer"
//申请志愿者-协议
#define MEIPcommonRegisterVolunteerProtocol @"common/user/registerVolunteerProtocol"
//获取社区服务分类
#define MEIPcommonCommunityServericeGetClassify @"common/communityserverice/getClassify"
//社区服务列表
#define MEIPcommonCommunityServericeGetList @"common/communityserverice/getList"
//社区服务详情
#define MEIPcommonCommunityServericeInfo @"common/communityserverice/info"

//获取公益秀分类
#define MEIPcommonUsefulactivityGetClassify @"common/usefulactivity/getClassify"
//公益秀列表
#define MEIPcommonUsefulactivityGetList @"common/usefulactivity/getList"
//公益秀评论
#define MEIPcommonUsefulactivityComment @"common/usefulactivity/comment"
//公益秀 评论列表
#define MEIPcommonUsefulactivityCommentList @"common/usefulactivity/commentList"
//点赞/取消点赞
#define MEIPcommonUsefulactivityPraise @"common/usefulactivity/praise"
//公益秀详情
#define MEIPcommonUsefulactivityInfo @"common/usefulactivity/info"
//获取服务类型
#define MEIPcommonRecruitGetClassify @"common/recruit/getClassify"
//招募活动列表
#define MEIPcommonRecruitGetList @"common/recruit/getList"
//招募活动详情
#define MEIPcommonRecruitInfo @"common/recruit/info"
//招募活动-关注/取消关注
#define MEIPcommonRecruitAttention @"common/recruit/attention"
//获取报名人员列表
#define MEIPcommonRecruitJoinUsersList @"common/recruit/joinUsersList"
//招募活动-报名/取消报名
#define MEIPcommonRecruitJoin @"common/recruit/join"
//招募活动留言咨询 列表
#define MEIPcommonRecruitActivityComment @"common/recruit/activityComment"
//招募活动留言咨询
#define MEIPcommonRecruitComment @"common/recruit/comment"
//招募活动留言咨询 回复
#define MEIPcommonRecruitCommentBack @"common/recruit/commentBack"
//验证活动编码
#define MEIPcommonSigninCheckSignInCode @"common/signin/checkSignInCode"
//签到
#define MEIPcommonSigninSignIn @"common/signin/signIn"
//签到
#define MEIPcommonSigninSignOut @"common/signin/signOut"

//活动页数据
#define MEIPcommonHomeGetRecommendGoodsAndActivity @"common/home/getRecommendGoodsAndActivity"
//公益课程
#define MEIPcommonCoursesCoursesList @"common/courses/coursesList"
//志愿者视力预约详情
#define MEIPcommonGoodsVolunteerReserve @"common/goods/volunteerReserve"


//已报名的活动
#define MEIPcommonRecruitMyJoinActivity @"common/recruit/myJoinActivity"
//已报名的活动
#define MEIPcommonSigninSignInActivity @"common/signin/signInActivity"
//我的关注
#define MEIPcommonUserMyAttention @"common/user/myAttention"
//志愿者详情
#define MEIPcommonUserVolunteerDetail @"common/user/volunteerDetail"
//点赞志愿者
#define MEIPcommonUserPraiseVolunteer @"common/user/praiseVolunteer"
//关注志愿者
#define MEIPcommonUserAttentionVolunteer @"common/user/attentionVolunteer"
//获取机构服务类型
#define MEIPcommonVolunteerOrganizationGetType @"common/volunteerOrganization/getType"
//申请志愿者组织
#define MEIPcommonVolunteerOrganizationApply @"common/volunteerOrganization/apply"
//获取组织列表
#define MEIPcommonVolunteerOrganizationGetList @"common/volunteerOrganization/getList"
//获取加入的组织列表
#define MEIPcommonVolunteerOrganizationJoinList @"common/volunteerOrganization/joinList"
//获取创建的组织列表
#define MEIPcommonVolunteerOrganizationMyOrganization @"common/volunteerOrganization/myOrganization"
//组织详情
#define MEIPcommonVolunteerOrganizationGetDetail @"common/volunteerOrganization/getDetail"
//关注组织
#define MEIPcommonVolunteerOrganizationAttention @"common/volunteerOrganization/attention"
//加入组织
#define MEIPcommonVolunteerOrganizationJoinOrg @"common/volunteerOrganization/joinOrg"

//我的评论
#define MEIPcommonUserMyComment @"common/user/myComment"
//删除评论
#define MEIPcommonRecruitCommentDel @"common/recruit/commentDel"

//爱心榜
#define MEIPcommonSigninListOfLove @"common/signin/listOfLove"
//个人资料
#define MEIPcommonUserVolunteerInfo @"common/user/volunteerInfo"
//修改昵称
#define MEIPcommonUserEditNickName @"common/user/editNickName"
//修改签名
#define MEIPcommonUserEditSignature @"common/user/editSignature"


//获取我的资金
#define MEIPcommonMoneyGetMoney @"common/money/getMoney"
//获取充值记录
#define MEIPcommonMoneyGetMoneyLog @"common/money/getMoneyLog"
//生成充值订单
#define MEIPcommonMoneyMemberRecharge @"common/money/memberRecharge"
//苹果支付回调成功
#define MEIPcommonMoneyAppleSuccess @"common/money/appleSuccess"
/*********************************************/


#endif /* MEAPIMacros_h */

