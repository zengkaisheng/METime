//
//  MEPublicShowDetailVC.h
//  ME时代
//
//  Created by gao lei on 2019/10/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEPublicShowDetailVC : MEBaseVC

@property (nonatomic, copy) kMeIndexBlock praiseBlock;
- (instancetype)initWithShowId:(NSInteger)showId;

@end

NS_ASSUME_NONNULL_END
