//
//  METhridProductDetailsVC.h
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, METhridProductDetailsVCType) {
    METhridProductDetailsVCNormalType=0,
    METhridProductDetailsVCRudeType=1,
    METhridProductDetailsVCNoticeType=2,
    
};
@interface METhridProductDetailsVC : MEBaseVC

- (instancetype)initWithId:(NSInteger)detailsId;
//砍价
- (instancetype)initWithId:(NSInteger)detailsId bargainId:(NSInteger)bargainId;
//来自好友分享
@property(nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL isGift;
@property (nonatomic, assign) BOOL isReceivePrize;//是否领取奖品
@property (nonatomic, copy) NSString *activity_id;//领取奖品时的抽奖活动ID
@property (nonatomic, strong) NSString *time;

@property (nonatomic, assign) BOOL isBargain;//砍价领取商品

@end

NS_ASSUME_NONNULL_END
