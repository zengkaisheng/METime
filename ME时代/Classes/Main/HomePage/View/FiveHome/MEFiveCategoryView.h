//
//  MEFiveCategoryView.h
//  志愿星
//
//  Created by gao lei on 2019/10/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEFiveCategoryViewHeight 39

@interface MEFiveCategoryView : UIView

@property (nonatomic ,copy) kMeIndexBlock selectIndexBlock;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

- (void)setMaterArray:(NSArray *)materArray;

@end

NS_ASSUME_NONNULL_END
