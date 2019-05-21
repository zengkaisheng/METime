//
//  MEBDataDealView.h
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEBDataDealModel;
const static CGFloat kMEBDataDealViewHeight = 513;

@interface MEBDataDealView : UIView

- (void)setUIWithModel:(MEBDataDealModel *)Model;

@end
