//
//  MEDiagnoseQuestionModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseQuestionModel.h"

@implementation MEDiagnoseQuestionUserModel

MEModelIdToIdField

@end


@implementation MEOptionsSubModel

MEModelIdToIdField

- (CGFloat)cellHeight {
    CGFloat height = 0.0;
    if (kMeUnNilStr(self.option).length > 0) {
        height = [kMeUnNilStr(self.option) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-54-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+11;
    }
    return height;
}

@end


@implementation MEQuestionsSubModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"options" : [MEOptionsSubModel class]}))

- (CGFloat)cellHeight {
    CGFloat height = 0.0;
    if (kMeUnNilStr(self.question).length > 0) {
        height = [[NSString stringWithFormat:@"2、%@",kMeUnNilStr(self.question)] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-35-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+16;
    }
    return height;
}

@end


@implementation MEDiagnosisSubModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"questions" : [MEQuestionsSubModel class]}))


@end



@implementation MEDiagnoseQuestionModel

MEModelObjectClassInArrayWithDic((@{@"diagnosis" : [MEDiagnosisSubModel class]}))


@end
