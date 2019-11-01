//
//  MEChooseTerminalView.h
//  志愿星
//
//  Created by gao lei on 2019/5/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEChooseTerminalView : UIView

//返回是否店员可见
@property (nonatomic, copy) kMeBasicBlock chooseBlock;
//返回是否店员可见
@property (nonatomic, copy) kMeBOOLBlock visiableBlock;

- (void)setTerminalWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
