//
//  MEBDataDealModel.h
//  ME时代
//
//  Created by hank on 2018/12/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface  MEBDataDealmemberModel: MEBaseModel

@property (nonatomic, assign) NSInteger  man;
@property (nonatomic, assign) NSInteger  privary;
@property (nonatomic, strong) NSString * today_new_member;
@property (nonatomic, strong) NSString * total;
@property (nonatomic, assign) NSInteger women;

@end

@interface MEBDataDealgoodsModel : MEBaseModel
@property (nonatomic, assign) NSInteger  man_sales;
@property (nonatomic, assign) NSInteger  privary_sales;
@property (nonatomic, strong) NSString * total_sales;
@property (nonatomic, assign) NSInteger  women_sales;
@end

@interface  MEBDataDealbrokerageModel: MEBaseModel
@property (nonatomic, assign) CGFloat  can_use_brokerage;
@property (nonatomic, assign) CGFloat settle_accounts_ok;
@property (nonatomic, assign) CGFloat settle_accounts_no;
@property (nonatomic, assign) CGFloat today_brokerage;
@end

@interface MEBDataDealorderModel : MEBaseModel
@property (nonatomic, strong) NSString * total_order_count;
@property (nonatomic, strong) NSString * today_order_count;
@end


@interface MEBDataDealBusinessModel : MEBaseModel
@property (nonatomic, strong) NSString * follow;
@property (nonatomic, assign) CGFloat  reserveDealPercent;
@property (nonatomic, strong) NSString * reserveMounth;
@property (nonatomic, strong) NSString * achievementMounth;
@property (nonatomic, assign) CGFloat achievementPercent;
@end

@interface MEBDataDealmarketingModel : MEBaseModel
@property (nonatomic, strong) NSString * totalPeople;
@property (nonatomic, strong) NSString * totalDeal;
@end

@interface MEBDataDealstoreProject : MEBaseModel
@property (nonatomic, strong) NSString * dealPeoplePercent;
@property (nonatomic, assign) CGFloat allProjectPercent;
@property (nonatomic, assign) CGFloat nomalProjectPercent;
@property (nonatomic, assign) CGFloat promotionProjectPercent;

@end



@interface MEBDataDealAchievementCatagery: MEBaseModel

@property (nonatomic, assign) CGFloat  percent;
@property (nonatomic, strong) NSString * category_name;
@property (nonatomic, strong) NSString * order_goods_status_name;

@end

@interface MEBDataDealAchievementMember: MEBaseModel

@property (nonatomic, assign) NSInteger  old;
@property (nonatomic, assign) NSInteger  people;
//@property (nonatomic, strong) NSString * newPeople;
@property (nonatomic, assign) NSInteger  active;

@end


@interface MEBDataDealStoreAchievement: MEBaseModel

@property (nonatomic, strong) NSArray *AchievementCatagery;//品类业务结构
@property (nonatomic, strong) NSString *AchievementMouth;//月销售额
@property (nonatomic, strong) MEBDataDealAchievementMember *AchievementMember;//顾客业绩结构
@end

@interface MEBDataDealGoodsNum: MEBaseModel
@property (nonatomic, assign) CGFloat count;
@property (nonatomic, strong) NSString *product_name;
@property (nonatomic, strong) NSString *order_goods_status_name;
@end

@interface MEBDataDealAge: MEBaseModel
@property (nonatomic, assign) CGFloat one;
@property (nonatomic, assign) CGFloat two;
@property (nonatomic, assign) CGFloat three;
@property (nonatomic, assign) CGFloat five;
@end

@interface MEBDataDealageAccessStr: MEBaseModel

@property (nonatomic, assign) CGFloat small_software;
@property (nonatomic, assign) CGFloat app;
@end

@interface MEBDataDealageAccess: MEBaseModel

@property (nonatomic, strong) MEBDataDealAge *small_software;
@property (nonatomic, strong) MEBDataDealAge *app;
@end

@interface MEBDataDealstoreCustomer: MEBaseModel

//app small_software
@property (nonatomic, strong) MEBDataDealageAccessStr *AccessTimes;
@property (nonatomic, strong) NSString *spendAmount;//消费额
@property (nonatomic, strong) NSString *spendTimes;//消费
@property (nonatomic, strong) NSString *spendMax;//消费额
//app small_software
@property (nonatomic, strong) MEBDataDealageAccessStr *AccessTimesByMouth;//月均到店次数和标准值
@property (nonatomic, strong) NSArray *GoodsNum;
@property (nonatomic, strong) MEBDataDealAge *ageFramework;//年龄结构分析
@property (nonatomic, strong) MEBDataDealAge *ageCost;//年龄消费分析
@property (nonatomic, strong) MEBDataDealageAccess *ageAccess;//不同年龄到店
@property (nonatomic, strong) MEBDataDealAge *ageAverageCost;//年龄人均消费
@property (nonatomic, strong) MEBDataDealAge *newsAge;//新客年龄结构

@property (nonatomic, strong) NSString *newsDealTimes;//新客成交
@property (nonatomic, strong) NSString *newsDealAmount;//新客消费
@end




@interface MEBDataDealModel : MEBaseModel

@property (nonatomic, strong) MEBDataDealbrokerageModel * brokerage;
@property (nonatomic, strong) MEBDataDealgoodsModel * goods;
@property (nonatomic, strong) MEBDataDealmemberModel * member;
@property (nonatomic, strong) MEBDataDealorderModel * order;

@property (nonatomic, strong) MEBDataDealBusinessModel * business;
@property (nonatomic, strong) MEBDataDealmarketingModel * marketing;
@property (nonatomic, strong) MEBDataDealstoreProject * storeProject;
@property (nonatomic, strong) MEBDataDealStoreAchievement *storeAchievement;

@property (nonatomic, strong) MEBDataDealstoreCustomer *storeCustomer;
@end
