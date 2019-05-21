//
//  MEHomeGoodModel.h
//  ME时代
//
//  Created by hank on 2018/9/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEHomeGoodModel : MEBaseModel

@property (nonatomic, assign) NSInteger article_category_id;
@property (nonatomic, strong) NSArray * goodsList;
@property (nonatomic, strong) NSString * mask_img;
@property (nonatomic, strong) NSString * title;

@end
