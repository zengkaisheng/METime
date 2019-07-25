//
//  MEHomeTestAddContentVC.h
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MEHomeAddTestDecContentModel;

typedef void (^kHomeTestAddContenBlock)(MEHomeAddTestDecContentModel *dic);
//
@interface MEHomeTestAddContentVC : MEBaseVC

@property (nonatomic,copy) kHomeTestAddContenBlock block;
@property (nonatomic, strong) MEHomeAddTestDecContentModel *model;

@end

NS_ASSUME_NONNULL_END
