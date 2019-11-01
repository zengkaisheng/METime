//
//  MECommonQuestionListModel.m
//  志愿星
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommonQuestionListModel.h"

@implementation MECommonQuestionSubModel

MEModelIdToIdField

@end


@implementation MECommonQuestionListModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic(@{@"problem" : [MECommonQuestionSubModel class]})

- (CGFloat )cellHeight{
    if(!_cellHeight){
        _cellHeight = 11 + 45;
        if (self.problem.count > 0) {
            _cellHeight += 45*self.problem.count;
        }
    }
    return _cellHeight;
}

@end
