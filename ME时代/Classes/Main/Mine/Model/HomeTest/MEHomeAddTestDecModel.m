//
//  MEHomeAddTestDecModel.m
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeAddTestDecModel.h"


@implementation MEHomeAddTestDecResultModel

MEModelIdToIdField

@end
//@implementation MEHomeAddTestDecImageModel
//
//@end


@implementation MEHomeAddTestDecContentModel

MEModelIdToIdField

@end


@implementation MEHomeAddTestDecModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"questions" : [MEHomeAddTestDecContentModel class],@"answers" : [MEHomeAddTestDecResultModel class]}))

- (NSMutableArray *)questions{
    if(!_questions){
        _questions = [NSMutableArray array];
    }
    return _questions;
}
- (NSMutableArray *)answers{
    if(!_answers){
        _answers = [NSMutableArray array];
    }
    return _answers;
}

@end
