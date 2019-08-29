//
//  MENewStoreApplyView.h
//  ME时代
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEStoreApplyParModel;
const static CGFloat kMENewStoreApplyViewHeight = 554;

@interface MENewStoreApplyView : UIView

@property (strong, nonatomic) MEStoreApplyParModel *model;

- (void)reloadUI;
@property (nonatomic, copy) kMeBasicBlock locationBlock;
@property (nonatomic, copy) kMeBasicBlock applyBlock;

@end

NS_ASSUME_NONNULL_END
