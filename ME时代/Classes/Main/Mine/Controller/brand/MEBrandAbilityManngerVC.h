//
//  MEBrandAbilityManngerVC.h
//  志愿星
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class MEBrandAISortModel;
const static CGFloat kMEBrandAbilityManngerVCHeight = 150;


@interface MEBrandAbilityManngerVC : MEBaseVC
- (instancetype)initWithModel:(MEBrandAISortModel *)model;
@end

NS_ASSUME_NONNULL_END
