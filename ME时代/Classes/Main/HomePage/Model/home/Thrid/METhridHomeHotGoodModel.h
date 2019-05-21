//
//  METhridHomeHotGoodModel.h
//  ME时代
//
//  Created by hank on 2019/4/14.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface METhridHomeHotGoodProductModel : MEBaseVC

@property (nonatomic, copy) NSString * goodtitle;
@property (nonatomic, copy) NSString * market_price;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * images;
@property (nonatomic, copy) NSString * desc;

@end

@interface METhridHomeHotGoodModel : MEBaseVC

//@property (nonatomic, strong) NSString * isIndexHotImages;
@property (nonatomic, copy) NSString * is_index_hot_images_url;
//@property (nonatomic, strong) NSString * isIndexHotVideo;
@property (nonatomic, copy) NSString * is_index_hot_video_url;
@property (nonatomic, strong) METhridHomeHotGoodProductModel * product;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, copy) NSString * sale;

@end

NS_ASSUME_NONNULL_END
