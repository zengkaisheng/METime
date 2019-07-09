//
//  MEHomeOptionsModel.h
//  ME时代
//
//  Created by gao lei on 2019/7/9.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEHomeOptionsModel : MEBaseModel

@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * logo;

@end

NS_ASSUME_NONNULL_END
