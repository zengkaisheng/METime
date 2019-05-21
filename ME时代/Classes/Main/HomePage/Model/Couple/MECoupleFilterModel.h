//
//  MECoupleFilterModel.h
//  ME时代
//
//  Created by hank on 2018/12/24.
//  Copyright © 2018 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECoupleFilterModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *subcategories;

@end

@interface MECoupleFilterSubModel : NSObject

@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
