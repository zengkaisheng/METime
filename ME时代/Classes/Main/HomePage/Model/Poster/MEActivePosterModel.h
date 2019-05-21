//
//  MEActivePosterModel.h
//  ME时代
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEActivePosterModel : MEBaseModel

@property (nonatomic, strong) NSString * activity_id;
@property (nonatomic, strong) NSString * activity_name;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSString * total_reward;

@end

NS_ASSUME_NONNULL_END
