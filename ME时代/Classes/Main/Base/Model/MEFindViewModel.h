//
//  MEFindViewModel.h
//  ME时代
//
//  Created by hank on 2019/5/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEFindViewModel : MEBaseModel
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *push_version;
@end

NS_ASSUME_NONNULL_END
