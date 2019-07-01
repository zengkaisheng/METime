//
//  MEIntelligentSearchView.h
//  ME时代
//
//  Created by gao lei on 2019/6/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEIntelligentSearchView : UIView

+ (void)ShowWithTitle:(NSString *)title tapBlock:(kMeIndexBlock)tapBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView;
//- (instancetype)initWithTitle:(NSString *)title superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
