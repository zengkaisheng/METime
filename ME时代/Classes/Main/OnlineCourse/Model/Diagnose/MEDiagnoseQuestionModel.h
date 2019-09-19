//
//  MEDiagnoseQuestionModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEDiagnoseQuestionUserModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_been;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;

@end


@interface MEOptionsSubModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * option;
@property (nonatomic, assign) NSInteger question_id;
@property (nonatomic, strong) NSString * updated_at;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) CGFloat cellHeight;

@end


@interface MEQuestionsSubModel : MEBaseModel

@property (nonatomic, strong) NSString * answer;
@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray * options;
@property (nonatomic, strong) NSString * question;
@property (nonatomic, strong) NSString * sort;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * type_name;
@property (nonatomic, strong) NSString * updated_at;

@property (nonatomic, assign) CGFloat cellHeight;

@end



@interface MEDiagnosisSubModel : MEBaseModel

@property (nonatomic, strong) NSString * classify_name;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSArray * questions;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger type;

@end



@interface MEDiagnoseQuestionModel : MEBaseModel

@property (nonatomic, strong) NSArray * diagnosis;
@property (nonatomic, strong) MEDiagnoseQuestionUserModel * user;
@property (nonatomic, strong) NSString * tips;

@end

NS_ASSUME_NONNULL_END
