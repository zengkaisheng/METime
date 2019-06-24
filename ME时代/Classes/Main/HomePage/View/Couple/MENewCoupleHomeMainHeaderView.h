//
//  MENewCoupleHomeMainHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/6/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MENewCoupleHomeMainHeaderViewImageType) {
    kTodayHotImageType = 0,
    k99BuyImageType = 1,
    kBigJuanImageType = 2,
};

@interface MENewCoupleHomeMainHeaderView : UICollectionReusableView

- (void)setUIWithArr:(NSArray *)arrModel type:(MENewCoupleHomeMainHeaderViewImageType)type;
+ (CGFloat)getCellHeightWithArr:(NSArray*)arr;

@end

NS_ASSUME_NONNULL_END
