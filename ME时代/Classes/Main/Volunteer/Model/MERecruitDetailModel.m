//
//  MERecruitDetailModel.m
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecruitDetailModel.h"

@implementation MERecruitJoinUserModel


@end


@implementation MERecruitCommentBackModel

MEModelIdToIdField
- (CGFloat)contentHeight {
    if (!_contentHeight) {
        _contentHeight = 0;
        if (kMeUnNilStr(self.content).length > 0) {
            _contentHeight += [kMeUnNilStr(self.content) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-140-50, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height;
        }
    }
    return _contentHeight;
}

@end


@implementation MERecruitCommentModel

MEModelIdToIdField
MEModelObjectClassInArrayWithDic((@{@"comment_back" : [MERecruitCommentBackModel class]}))
- (CGFloat)contentHeight {
    if (!_contentHeight) {
        _contentHeight = 14+19+8+11+6;
        if (kMeUnNilStr(self.content).length > 0) {
            _contentHeight += [kMeUnNilStr(self.content) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-73, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height;
        }
        if (kMeUnArr(self.comment_back).count > 0) {
            for (MERecruitCommentBackModel *model in self.comment_back) {
                _contentHeight += 10+model.contentHeight+10;
            }
        }
    }
    return _contentHeight;
}

@end


@implementation MERecruitDetailModel

MEModelIdToIdField
MEModelObjectClassInArrayWithDic((@{@"join_users" : [MERecruitJoinUserModel class], @"comment":[MERecruitCommentModel class]}))

@end
