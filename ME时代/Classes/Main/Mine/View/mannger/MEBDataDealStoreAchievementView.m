//
//  MEBDataDealStoreAchievementView.m
//  ME时代
//
//  Created by hank on 2019/2/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBDataDealStoreAchievementView.h"
#import "MEBDataDealStructView.h"
#import "MEBDataDealModel.h"

@interface MEBDataDealStoreAchievementView ()

@property (weak, nonatomic) IBOutlet UILabel *lblAchievementMemberNew;
@property (weak, nonatomic) IBOutlet UILabel *lblAchievementMemberOld;
@property (weak, nonatomic) IBOutlet UILabel *lblAchievementMemberActive;
@property (weak, nonatomic) IBOutlet UILabel *lblAchievementMouth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consStructView;
@property (weak, nonatomic) IBOutlet MEBDataDealStructView *viewforStruct;

@end

@implementation MEBDataDealStoreAchievementView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setUIWithModel:(MEBDataDealModel *)model{
//    _lblAchievementMemberNew.text = kMeUnNilStr(model.storeAchievement.AchievementMember.people);
//    _lblAchievementMemberOld.text = kMeUnNilStr(model.storeAchievement.AchievementMember.old);
//    _lblAchievementMemberActive.text = kMeUnNilStr(model.storeAchievement.AchievementMember.active);
    _lblAchievementMouth.text = kMeUnNilStr(model.storeAchievement.AchievementMouth);
    [_viewforStruct setUIWithArr:kMeUnArr(model.storeAchievement.AchievementCatagery)];
    _consStructView.constant = [MEBDataDealStructView getViewWithArr:kMeUnArr(model.storeAchievement.AchievementCatagery)];
}

+(CGFloat)getViewHeightWithModel:(MEBDataDealModel *)model{
    CGFloat height = 430-128;
    height+=[MEBDataDealStructView getViewWithArr:kMeUnArr(model.storeAchievement.AchievementCatagery)];
    return height;
}

@end
