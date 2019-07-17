//
//  MEFourHomeBaseVC.h
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class METhridHomeModel;
@class MEStoreModel;

@interface MEFourHomeBaseVC : MEBaseVC

@property (nonatomic, copy) kMeObjBlock changeColorBlock;//颜色改变
@property (nonatomic, copy) kMeTextBlock changeStoreBlock;//改变小店

- (instancetype)initWithType:(NSInteger)type materialArray:(NSArray *)materialArray;

- (void)setHeaderViewUIWithModel:(METhridHomeModel *)model stroeModel:(MEStoreModel *)storemodel optionsArray:(NSArray *)array;

- (void)toStore;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
