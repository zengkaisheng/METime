//
//  MERichTextVC.h
//  ME时代
//
//  Created by hank on 2019/3/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class MEAddGoodModel;
@interface MERichTextVC : MEBaseVC

@property (nonatomic,strong) MEAddGoodModel *model;
@property (nonatomic,strong) NSString *token;
@property (nonatomic, copy) kMeBasicBlock finishBlcok;

@end

NS_ASSUME_NONNULL_END
