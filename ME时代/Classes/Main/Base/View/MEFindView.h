//
//  MEFindView.h
//  ME时代
//
//  Created by hank on 2019/5/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEFindView : UIView

- (void)show;
- (void)hide;
- (void)setUIWithV:(NSString *)v content:(NSString*)content isShowCancel:(BOOL)isShowCancel;
+ (MEFindView *)getViewWithV:(NSString *)v content:(NSString*)content isShowCancel:(BOOL)isShowCancel;
@end

NS_ASSUME_NONNULL_END
