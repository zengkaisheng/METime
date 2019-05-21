//
//  MEBrandAbilityAnalysisDataModel.h
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEBrandAbilityAnalysisDataModel : MEBaseModel

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;

+ (MEBrandAbilityAnalysisDataModel *)modelWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
