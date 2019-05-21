//
//  MEBStoreMannagerInfoModel.h
//  ME时代
//
//  Created by hank on 2019/2/19.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MEBStoreMannagerInfoNameType,
    MEBStoreMannagerInfoTelType,
    MEBStoreMannagerInfolevelType,
    MEBStoreMannagerInfoLoginNameType,
    MEBStoreMannagerInfoTopNameType,
    MEBStoreMannagerInfoSupoirNameType,
    MEBStoreMannagerInfoStoreNameType,
    MEBStoreMannagerInfoStoreTelType,
    MEBStoreMannagerInfocodeIdType,
    MEBStoreMannagerStoreIntoduceType,
    MEBStoreMannagerInfoAddressType,
    MEBStoreMannagerInfodetailAddressType,
    MEBStoreMannagerInfoTimeType
} MEBStoreMannagerInfoType;

@interface MEBStoreMannagercontentInfoModel : MEBaseModel

@property (nonatomic ,assign) MEBStoreMannagerInfoType type;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *subTitle;

+ (MEBStoreMannagercontentInfoModel *)initWithType:(MEBStoreMannagerInfoType )type title:(NSString *)title subTitle:(NSString *)subTitle;

@end

@interface MEBStoreMannagerInfoModel : MEBaseModel

@property (nonatomic ,strong) NSMutableArray *arrModel;
@property (nonatomic ,strong) NSString *title;


@end

NS_ASSUME_NONNULL_END
