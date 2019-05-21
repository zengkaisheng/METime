//
//  MECouponOrderSectionView.h
//  ME时代
//
//  Created by hank on 2019/2/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MECouponOrderSectionViewTBType = 0,
    MECouponOrderSectionViewPinduoduoType,
    MECouponOrderSectionViewJDType
} MECouponOrderSectionViewType;


const static CGFloat kMECouponOrderSectionViewHeight = 49;

@interface MECouponOrderSectionView : UITableViewHeaderFooterView

@property (nonatomic, copy) kMeIndexBlock selectBlock;
@property (nonatomic, assign) MECouponOrderSectionViewType type;
@end

NS_ASSUME_NONNULL_END
