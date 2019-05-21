//
//  MECoupleHomeHeaderView.h
//  ME时代
//
//  Created by hank on 2019/1/3.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MECoupleHomeHeaderView : UIView

- (void)setUiWithModel:(NSArray *)Model isTKb:(BOOL)isTbk;
+ (CGFloat)getViewHeightWithisTKb:(BOOL)isTbk;


@end

NS_ASSUME_NONNULL_END
