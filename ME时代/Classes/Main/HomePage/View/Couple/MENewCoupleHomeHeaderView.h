//
//  MENewCoupleHomeHeaderView.h
//  志愿星
//
//  Created by gao lei on 2019/6/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MENewCoupleHomeHeaderView : UICollectionReusableView

@property (nonatomic, assign) NSInteger recordType;

- (void)setUiWithModel:(NSArray *)Model isTKb:(BOOL)isTbk;

+ (CGFloat)getViewHeightWithisTKb:(BOOL)isTbk;
+ (CGFloat)getViewHeightWithisTKb:(BOOL)isTbk hasSdView:(BOOL)hasSdView;

@end

NS_ASSUME_NONNULL_END
