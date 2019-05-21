//
//  MEAddGoodVC.h
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddGoodVC : MEBaseVC
- (instancetype)initWithProductId:(NSString *)productId;
@property (nonatomic, copy) kMeBasicBlock finishAddBlock;
@end

NS_ASSUME_NONNULL_END
