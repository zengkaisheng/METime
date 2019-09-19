//
//  MEFourHomeGoodGoodMainHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEFourHomeGoodGoodMainHeaderView : UICollectionReusableView

@property (nonatomic, assign) BOOL showHeader;

- (void)setupUIWithArray:(NSArray *)array showFooter:(BOOL)show;


@end

NS_ASSUME_NONNULL_END
