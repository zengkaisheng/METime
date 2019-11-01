//
//  MEFourHomeHeaderView.h
//  志愿星
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEStoreModel;
@class METhridHomeModel;
const static CGFloat kSdHeight = 137;
const static CGFloat kSecondImageHeight = 154;
const static CGFloat kThridImageWidth = 177;
const static CGFloat kThridImageHeight = 200;

const static CGFloat kMEThridHomeHeaderViewHeight = 423;


@interface MEFourHomeHeaderView : UICollectionReusableView

//+ (CGFloat)getViewHeightWithModel:(METhridHomeModel *)model;
+ (CGFloat)getViewHeightWithOptionsArray:(NSArray *)options;
//- (void)setUIWithModel:(METhridHomeModel *)model;
- (void)setUIWithModel:(METhridHomeModel *)model stroeModel:(MEStoreModel *)storemodel optionsArray:(NSArray *)options;
@property (nonatomic,copy)kMeIndexBlock scrollToIndexBlock;
@property (nonatomic,copy) kMeTextBlock activityBlock;
@property (nonatomic,copy) kMeBasicBlock reloadBlock;

@property (weak, nonatomic) IBOutlet UIView *ViewForBack;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;

@end

NS_ASSUME_NONNULL_END
