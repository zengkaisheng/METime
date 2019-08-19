//
//  MEDiagnoseReportDetailModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseReportDetailModel.h"

@implementation MEReportDiagnosisModel

- (CGFloat)cellHeight {
    CGFloat height = 0.0;
    if (kMeUnNilStr(self.question).length > 0) {
        height += [[NSString stringWithFormat:@"%@",kMeUnNilStr(self.question)] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+10;
    }
    if (kMeUnNilStr(self.option).length > 0) {
        height += [[NSString stringWithFormat:@"%@",kMeUnNilStr(self.option)] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+13;
    }
    if (kMeUnArr(self.options).count > 0) {
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        for (int i = 0; i < self.options.count; i++) {
            NSString *string = self.options[i];
            if (i < self.options.count-1) {
                [tempStr appendFormat:@"%@\n",string];
            }else {
                [tempStr appendFormat:@"%@",string];
            }
        }
        height += [[NSString stringWithFormat:@"%@",tempStr] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+13;
    }
    return height+10;
}

@end


@implementation MEReportQuestionsModel

MEModelObjectClassInArrayWithDic((@{@"diagnosis" : [MEReportDiagnosisModel class]}))

@end


@implementation MEReportAnalyseModel

- (CGFloat)cellHeight {
    CGFloat height = 0.0;
    if (kMeUnNilStr(self.analysis).length > 0) {
        height += [[NSString stringWithFormat:@"%@",kMeUnNilStr(self.analysis)] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+10;
    }
    if (kMeUnNilStr(self.suggest).length > 0) {
        height += [[NSString stringWithFormat:@"%@",kMeUnNilStr(self.suggest)] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+13;
    }
    return height+20;
}

@end


@implementation MEDiagnoseReportDetailModel

MEModelObjectClassInArrayWithDic((@{@"questions" : [MEReportQuestionsModel class], @"analyse" : [MEReportAnalyseModel class]}))

@end
