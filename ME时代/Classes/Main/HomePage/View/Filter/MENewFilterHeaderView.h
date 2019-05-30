//
//  MENewFilterHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MENewFilterHeaderView : UIView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;

- (void)setUIWithBackgroundImage:(NSString *)bgImage bannerImage:(NSString *)bannerImage;
- (void)setUIWithModel;

@end

NS_ASSUME_NONNULL_END
