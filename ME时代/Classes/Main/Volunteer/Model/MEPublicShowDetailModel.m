//
//  MEPublicShowDetailModel.m
//  ME时代
//
//  Created by gao lei on 2019/10/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublicShowDetailModel.h"

@implementation MEPublicShowCommentModel

MEModelIdToIdField

@end



@implementation MEPublicShowDetailModel

MEModelIdToIdField
MEModelObjectClassInArrayWithDic((@{@"comment" : [MEPublicShowCommentModel class]}))

@end
