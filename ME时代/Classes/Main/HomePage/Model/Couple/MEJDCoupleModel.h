//
//  MEJDCoupleModel.h
//  ME时代
//
//  Created by hank on 2019/2/18.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponContentInfo : MEBaseModel

@property (nonatomic, assign) NSInteger bindType;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, assign) NSInteger getEndTime;
@property (nonatomic, assign) NSInteger getStartTime;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, assign) NSInteger platformType;
@property (nonatomic, assign) NSInteger quota;
@property (nonatomic, strong) NSString *useEndTime;
@property (nonatomic, strong) NSString *useStartTime;

@end

@interface ImageContentInfo : MEBaseModel

@property (nonatomic, strong) NSString *url;

@end

@interface CouponInfo : MEBaseModel
@property (nonatomic, strong) NSArray *couponList;
@end

@interface ImageInfo : MEBaseModel

@property (nonatomic, strong) NSArray *imageList;

@end

@interface PriceInfo : MEBaseModel

@property (nonatomic, strong) NSString * price;

@end

@interface CommissionInfo : MEBaseModel

@property (nonatomic, assign) CGFloat commission;

@end

@interface MEJDCoupleModel : MEBaseModel

@property (nonatomic, strong) NSString * brandCode;
@property (nonatomic, strong) NSString * brandName;
//@property (nonatomic, strong) CategoryInfo * categoryInfo;
@property (nonatomic, strong) NSString * comments;
@property (nonatomic, strong) CommissionInfo * commissionInfo;
@property (nonatomic, strong) CouponInfo * couponInfo;
@property (nonatomic, assign) NSInteger goodCommentsShare;
@property (nonatomic, strong) ImageInfo * imageInfo;
@property (nonatomic, assign) NSInteger inOrderCount30Days;
@property (nonatomic, assign) NSInteger inOrderCount30DaysSku;
@property (nonatomic, assign) NSInteger isHot;
@property (nonatomic, strong) NSString * materialUrl;
@property (nonatomic, strong) NSString * owner;
//@property (nonatomic, strong) PinGouInfo * pinGouInfo;
@property (nonatomic, strong) PriceInfo * priceInfo;
//@property (nonatomic, strong) ResourceInfo * resourceInfo;
//@property (nonatomic, strong) ShopInfo * shopInfo;
@property (nonatomic, strong) NSString * skuId;
@property (nonatomic, strong) NSString * skuName;
@property (nonatomic, assign) NSInteger spuid;
@property (nonatomic, assign) CGFloat percent;

@end

NS_ASSUME_NONNULL_END
