//
//  MEFiveHomeBaseVC.h
//  志愿星
//
//  Created by gao lei on 2019/10/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class METhridHomeModel;
@class MEStoreModel;


@interface MEFiveHomeBaseVC : MEBaseVC

@property (nonatomic, copy) kMeObjBlock changeColorBlock;//颜色改变
@property (nonatomic, copy) kMeTextBlock changeStoreBlock;//改变小店
@property (nonatomic, copy) kMeIndexBlock selectedIndexBlock;//首页顶部分类点击下标及是否显示

- (instancetype)initWithType:(NSInteger)type materialArray:(NSArray *)materialArray;

- (void)toStore;

- (void)reloadData;

- (void)setCurrentIndex:(NSInteger)currentIndex;

@end

NS_ASSUME_NONNULL_END
