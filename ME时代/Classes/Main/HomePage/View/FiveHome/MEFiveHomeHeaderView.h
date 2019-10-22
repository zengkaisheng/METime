//
//  MEFiveHomeHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/10/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class METhridHomeModel;

const static CGFloat kFiveSdHeight = 137;
const static CGFloat kMEFiveHomeHeaderViewHeight = 369;

@interface MEFiveHomeHeaderView : UICollectionReusableView

+ (CGFloat)getViewHeightWithOptionsArray:(NSArray *)options materArray:(NSArray *)materArray;

- (void)setUIWithModel:(METhridHomeModel *)model materArray:(NSArray *)materArray optionsArray:(NSArray *)options;

@property (nonatomic,copy) kMeIndexBlock scrollToIndexBlock;
@property (nonatomic,copy) kMeIndexBlock selectIndexBlock;
@property (nonatomic,copy) kMeTextBlock activityBlock;
@property (nonatomic,copy) kMeBasicBlock reloadBlock;

@property (weak, nonatomic) IBOutlet UIView *ViewForBack;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewConsHeight;


@end

NS_ASSUME_NONNULL_END
