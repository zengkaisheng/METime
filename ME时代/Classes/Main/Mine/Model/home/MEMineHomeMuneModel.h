//
//  MEMineHomeMuneModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEMineHomeMuneChildrenModel : MEBaseModel

@property (nonatomic, strong) NSString * icon;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * path;

@end


@interface MEMineHomeMuneModel : MEBaseModel

@property (nonatomic, strong) NSArray * children;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * path;

@end

NS_ASSUME_NONNULL_END
