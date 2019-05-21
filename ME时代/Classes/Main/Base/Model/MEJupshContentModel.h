//
//  MEJupshContentModel.h
//  ME时代
//
//  Created by hank on 2019/1/30.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEJupshContentModel : MEBaseModel

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger msg_id;


@end

NS_ASSUME_NONNULL_END
