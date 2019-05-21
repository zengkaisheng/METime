//
//  MEBrandAbilityAnalysisModel.h
//  ME时代
//
//  Created by hank on 2019/3/14.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEBrandAbilityAnalysisMemberInfo : MEBaseModel
@property (nonatomic, assign) NSInteger store_count;
@property (nonatomic, strong) NSString * header_pic;
@end


@interface MEBrandAbilityAnalysisModel : MEBaseModel

@property (nonatomic, assign) NSInteger access_rank;
@property (nonatomic, assign) NSInteger activity_rank;
@property (nonatomic, assign) NSInteger communicate_rank;
@property (nonatomic, strong) MEBrandAbilityAnalysisMemberInfo * member_info;
@property (nonatomic, assign) NSInteger product_rank;
@property (nonatomic, assign) NSInteger sale_comprehensive;
@property (nonatomic, assign) NSInteger sale_num_rank;
@property (nonatomic, assign) NSInteger sale_rank;
@property (nonatomic, assign) NSInteger total_store;

@end

NS_ASSUME_NONNULL_END
