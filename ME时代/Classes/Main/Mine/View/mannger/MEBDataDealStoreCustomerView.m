//
//  MEBDataDealStoreCustomerView.m
//  ME时代
//
//  Created by hank on 2019/2/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBDataDealStoreCustomerView.h"
#import "MEBDataDealStructView.h"
#import "MEBDataDealModel.h"

@interface MEBDataDealStoreCustomerView ()
@property (weak, nonatomic) IBOutlet UILabel *lblSpendMaxTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblSpendTimes;
@property (weak, nonatomic) IBOutlet UILabel *lblSpendMax;
@property (weak, nonatomic) IBOutlet UILabel *lblSpendAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsDealTimes;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsDealAmount;

@property (weak, nonatomic) IBOutlet UILabel *lblAccessTimesByMouthWeb;
@property (weak, nonatomic) IBOutlet UILabel *lblAccessTimesByMouthApp;
@property (weak, nonatomic) IBOutlet UILabel *lblAccessTimesWeb;
@property (weak, nonatomic) IBOutlet UILabel *lblAccessTimesApp;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consStructHeight;
@property (weak, nonatomic) IBOutlet MEBDataDealStructView *structView;

//门店顾客年龄结构分析
@property (weak, nonatomic) IBOutlet UILabel *lblAgeFrameworkOne;
@property (weak, nonatomic) IBOutlet UILabel *lblAgeFrameworkTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblAgeFrameworkThree;
@property (weak, nonatomic) IBOutlet UILabel *lblAgeFrameworkFive;

//门店顾客各年龄消费额分析
@property (weak, nonatomic) IBOutlet UILabel *lblageCostOne;
@property (weak, nonatomic) IBOutlet UILabel *lblageCostTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblageCostThree;
@property (weak, nonatomic) IBOutlet UILabel *lblageCostFive;

//门店顾客不同年龄人均消费分析
@property (weak, nonatomic) IBOutlet UILabel *lblageageAverageCostOne;
@property (weak, nonatomic) IBOutlet UILabel *lblageageAverageCostTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblageageAverageCostThree;
@property (weak, nonatomic) IBOutlet UILabel *lblageageAverageCostFive;

//门店顾客各年龄结构分析
@property (weak, nonatomic) IBOutlet UILabel *lblnewsAgeOne;
@property (weak, nonatomic) IBOutlet UILabel *lblnewsAgeTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblnewsAgeThree;
@property (weak, nonatomic) IBOutlet UILabel *lblnewsAgeFive;

//门店顾客不同年龄到店次数-小程序
@property (weak, nonatomic) IBOutlet UILabel *lblageAccessAgeOne;
@property (weak, nonatomic) IBOutlet UILabel *lblageAccessAgeTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblageAccessAgeThree;
@property (weak, nonatomic) IBOutlet UILabel *lblageAccessAgeFive;

//门店顾客不同年龄到店次数-APP
@property (weak, nonatomic) IBOutlet UILabel *lblageAccessAgeOneAPP;
@property (weak, nonatomic) IBOutlet UILabel *lblageAccessAgeTwoAPP;
@property (weak, nonatomic) IBOutlet UILabel *lblageAccessAgeThreeApp;
@property (weak, nonatomic) IBOutlet UILabel *lblageAccessAgeFiveApp;



@end

@implementation MEBDataDealStoreCustomerView

- (void)awakeFromNib{
    [super awakeFromNib];
    _lblSpendMaxTitle.adjustsFontSizeToFitWidth = YES;
}

- (void)setUIWithModel:(MEBDataDealModel *)model{
    [_structView setGoodNUmUIWithArr:kMeUnArr(model.storeCustomer.GoodsNum)];
    _consStructHeight.constant = [MEBDataDealStructView getViewWithArr:kMeUnArr(model.storeCustomer.GoodsNum)];
    _lblSpendTimes.text = kMeUnNilStr(model.storeCustomer.spendTimes);
    _lblSpendMax.text = kMeUnNilStr(model.storeCustomer.spendMax);
    _lblSpendAmount.text = kMeUnNilStr(model.storeCustomer.spendAmount);
    _lblNewsDealTimes.text = kMeUnNilStr(model.storeCustomer.newsDealTimes);
    _lblNewsDealAmount.text = kMeUnNilStr(model.storeCustomer.newsDealAmount);
    
//    _lblAccessTimesByMouthWeb.text = kMeUnNilStr(model.storeCustomer.AccessTimesByMouth.small_software);
//     _lblAccessTimesByMouthApp.text = kMeUnNilStr(model.storeCustomer.AccessTimesByMouth.app);
//
//     _lblAccessTimesWeb.text = kMeUnNilStr(model.storeCustomer.AccessTimes.small_software);
//     _lblAccessTimesApp.text = kMeUnNilStr(model.storeCustomer.AccessTimes.app);
    
//    //门店顾客年龄结构分析
//    _lblAgeFrameworkOne.text = kMeUnNilStr(model.storeCustomer.ageFramework.one);
//    _lblAgeFrameworkTwo.text =kMeUnNilStr(model.storeCustomer.ageFramework.two);
//    _lblAgeFrameworkThree.text =kMeUnNilStr(model.storeCustomer.ageFramework.three);
//    _lblAgeFrameworkFive.text =kMeUnNilStr(model.storeCustomer.ageFramework.five);
    
    //门店顾客各年龄消费额分析
//    _lblageCostOne.text= kMeUnNilStr(model.storeCustomer.ageCost.one);
//    _lblageCostTwo.text= kMeUnNilStr(model.storeCustomer.ageCost.two);
//    _lblageCostThree.text= kMeUnNilStr(model.storeCustomer.ageCost.three);
//    _lblageCostFive.text= kMeUnNilStr(model.storeCustomer.ageCost.five);
    
    //门店顾客不同年龄人均消费分析
//    _lblageageAverageCostOne.text = kMeUnNilStr(model.storeCustomer.ageAverageCost.one);
//    _lblageageAverageCostTwo.text = kMeUnNilStr(model.storeCustomer.ageAverageCost.two);
//    _lblageageAverageCostThree.text = kMeUnNilStr(model.storeCustomer.ageAverageCost.three);
//    _lblageageAverageCostFive.text = kMeUnNilStr(model.storeCustomer.ageAverageCost.five);
    
    //门店顾客各年龄结构分析
//    _lblnewsAgeOne.text = kMeUnNilStr(model.storeCustomer.newsAge.one);
//    _lblnewsAgeTwo.text = kMeUnNilStr(model.storeCustomer.newsAge.two);
//    _lblnewsAgeThree.text = kMeUnNilStr(model.storeCustomer.newsAge.three);
//    _lblnewsAgeFive.text = kMeUnNilStr(model.storeCustomer.newsAge.five);
    
    //门店顾客不同年龄到店次数-小程序
//    _lblageAccessAgeOne.text =kMeUnNilStr(model.storeCustomer.ageAccess.small_software.one);
//    _lblageAccessAgeTwo.text =kMeUnNilStr(model.storeCustomer.ageAccess.small_software.two);
//    _lblageAccessAgeThree.text =kMeUnNilStr(model.storeCustomer.ageAccess.small_software.three);
//    _lblageAccessAgeFive.text =kMeUnNilStr(model.storeCustomer.ageAccess.small_software.five);
//
//    //门店顾客不同年龄到店次数-APP
//    _lblageAccessAgeOneAPP.text =kMeUnNilStr(model.storeCustomer.ageAccess.app.one);
//    _lblageAccessAgeTwoAPP.text =kMeUnNilStr(model.storeCustomer.ageAccess.app.two);
//    _lblageAccessAgeThreeApp.text =kMeUnNilStr(model.storeCustomer.ageAccess.app.three);
//    _lblageAccessAgeFiveApp.text =kMeUnNilStr(model.storeCustomer.ageAccess.app.five);

}

+(CGFloat)getViewHeightWithModel:(MEBDataDealModel *)model{
    CGFloat height = 1394-128;
    height+=[MEBDataDealStructView getViewWithArr:kMeUnArr(model.storeCustomer.GoodsNum)];
    return height;
}

@end
