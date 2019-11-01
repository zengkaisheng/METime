//
//  MEBynamicHomeModel.m
//  志愿星
//
//  Created by hank on 2019/1/24.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBynamicHomeModel.h"

@implementation MEBynamicHomepraiseModel

@end

@implementation MEBynamicJDModel

@end

@implementation MEBynamicHomecommentModel

@end

@implementation MEBynamicHomeModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"praise" : [MEBynamicHomepraiseModel class],@"comment" : [MEBynamicHomecommentModel class],@"imageList" : [MEBynamicJDModel class]}))

- (NSString *)content{
    if(!_content || kMeUnNilStr(_content).length == 0){
        return @" ";
    }else{
        return _content;
    }
}

@end
