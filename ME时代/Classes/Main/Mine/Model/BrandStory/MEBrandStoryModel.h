//
//  MEBrandStoryModel.h
//  ME时代
//
//  Created by hank on 2019/4/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MEBrandStoryContentModelTXTType,
    MEBrandStoryContentModelVideoType,
    MEBrandStoryContentModelPicType,
} MEBrandStoryContentModelType;

@interface MEBrandStoryContentModel : MEBaseModel

@property (nonatomic, assign) MEBrandStoryContentModelType Type;
@property (nonatomic, strong) NSString *content;

@end

@interface MEBrandStoryModel : MEBaseModel

@property (nonatomic, strong) NSMutableArray *arrdata;

@end

NS_ASSUME_NONNULL_END
