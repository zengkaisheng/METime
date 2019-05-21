//
//  MEBStoreMannagerEditInfoVC.h
//  ME时代
//
//  Created by hank on 2019/2/19.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class MEBStoreMannagercontentInfoModel;
@interface MEBStoreMannagerEditInfoVC : MEBaseVC

- (instancetype)initWithContent:(MEBStoreMannagercontentInfoModel*)model;

@property (nonatomic, copy) kMeTextBlock contenBlock;

@end

NS_ASSUME_NONNULL_END
