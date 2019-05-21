//
//  METhridHomeHeaderView.h
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEStoreModel;
@class METhridHomeModel;
const static CGFloat kSdHeight = 137;
const static CGFloat kSecondImageHeight = 154;
const static CGFloat kThridImageWidth = 177;
const static CGFloat kThridImageHeight = 200;

const static CGFloat kMEThridHomeHeaderViewHeight = 331;


@interface METhridHomeHeaderView : UIView

//+ (CGFloat)getViewHeightWithModel:(METhridHomeModel *)model;
+ (CGFloat)getViewHeight;
//- (void)setUIWithModel:(METhridHomeModel *)model;
- (void)setUIWithModel:(METhridHomeModel *)model stroeModel:(MEStoreModel *)storemodel;
@property (nonatomic,copy)kMeIndexBlock scrollToIndexBlock;

@property (weak, nonatomic) IBOutlet UIView *viewForBack;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@end

NS_ASSUME_NONNULL_END
