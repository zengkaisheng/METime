//
//  MEFiveHomeVolunteerHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/10/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class METhridHomeModel;

#define kMEFiveHomeVolunteerHeaderViewHeight 223*kMeFrameScaleX()

@interface MEFiveHomeVolunteerHeaderView : UICollectionReusableView

@property (nonatomic,copy) kMeIndexBlock selectIndexBlock;

- (void)setUIWithModel:(METhridHomeModel *)model;

@end

NS_ASSUME_NONNULL_END
