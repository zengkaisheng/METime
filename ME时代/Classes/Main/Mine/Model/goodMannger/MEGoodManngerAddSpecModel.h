//
//  MEGoodManngerAddSpecModel.h
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGoodManngerAddSpecModel : MEBaseModel

@property (nonatomic, strong) NSMutableArray *arrSpec;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *stock;
@property (nonatomic, strong) NSString *saleIntegral;
@property (nonatomic, strong) NSString *shareIntegral;
@property (nonatomic, strong) NSString *sepc_img;

@end

NS_ASSUME_NONNULL_END
