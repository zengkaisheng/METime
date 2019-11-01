//
//  MEDiagnoseReportDetailModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEReportDiagnosisModel : MEBaseModel

@property (nonatomic, strong) NSString * question;
@property (nonatomic, strong) NSString * option;
@property (nonatomic, strong) NSArray * options;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) CGFloat cellHeight;
@end



@interface MEReportQuestionsModel : MEBaseModel

@property (nonatomic, strong) NSString * classify_name;
@property (nonatomic, strong) NSArray * diagnosis;

@property (nonatomic, assign) BOOL isSpread;//是否收起 默认NO
@end



@interface MEReportAnalyseModel : MEBaseModel

@property (nonatomic, strong) NSString * analysis;
@property (nonatomic, strong) NSString * classify_name;
@property (nonatomic, strong) NSString * suggest;

@property (nonatomic, assign) BOOL isSpread;//是否展开 默认NO
@property (nonatomic, assign) CGFloat cellHeight;
@end



@interface MEDiagnoseReportDetailModel : MEBaseModel

@property (nonatomic, strong) NSArray * analyse;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSArray * questions;
@property (nonatomic, strong) NSArray * suggests;
@property (nonatomic, strong) NSString * telephone;

@end

NS_ASSUME_NONNULL_END
