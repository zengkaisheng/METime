//
//  MEVistorUserPathModel.h
//  ME时代
//
//  Created by hank on 2018/12/4.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEVistorUserPathModel : MEBaseModel


@property (nonatomic, strong) NSString * member;
@property (nonatomic, assign) NSInteger member_id;
@property (nonatomic, strong) NSString * spread_member;
@property (nonatomic, assign) NSInteger spread_member_id;
@property (nonatomic, strong) NSString * spread_member_images;
@property (nonatomic, strong) NSString * member_images;
@end
