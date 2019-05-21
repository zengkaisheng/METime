//
//  MECoupleHomeMainCell.h
//  ME时代
//
//  Created by hank on 2019/1/3.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MECoupleHomeMainCellImageType) {
    kTodayHotImageType = 0,
    k99BuyImageType = 1,
    kBigJuanImageType = 2,
};

@interface MECoupleHomeMainCell : UITableViewCell

- (void)setUIWithArr:(NSArray *)arrModel type:(MECoupleHomeMainCellImageType)type;
+ (CGFloat)getCellHeightWithArr:(NSArray*)arr;

@end

NS_ASSUME_NONNULL_END
