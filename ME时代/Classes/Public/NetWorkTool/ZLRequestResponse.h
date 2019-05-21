//
//  ZLRequestResponse.h
//  我要留学
//
//  Created by Hank on 10/13/16.
//  Copyright © 2016 深圳市智联天下国际教育有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEBaseModel.h"

@interface ZLRequestResponse : MEBaseModel

//@property (nonatomic,assign) BOOL success;         //版本号
@property (nonatomic,strong) id data;
@property (nonatomic,strong) NSString *status_code;
@property (nonatomic,strong) NSString *message;


//@property (nonatomic,assign) NSInteger amount;
//for融云 test
@property (nonatomic,strong) NSString *token;


@end
