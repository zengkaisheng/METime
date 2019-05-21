//
//  MEBynamicPublishGridModel.h
//  ME时代
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MEBynamicPublishGridModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MEBynamicPublishGridModelIdelStatus,
    MEBynamicPublishGridModelUploadingStatus,
    MEBynamicPublishGridModelSucStatus,
    MEBynamicPublishGridModelFailStatus,
} MEBynamicPublishGridModelStatus;

@interface MEBynamicPublishGridModel : MEBaseModel


@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) MEBynamicPublishGridModelStatus status;

//选中的时候用的


+ (MEBynamicPublishGridModel*)modelWithImage:(UIImage *)image isAdd:(BOOL)isAdd;

@end

NS_ASSUME_NONNULL_END
