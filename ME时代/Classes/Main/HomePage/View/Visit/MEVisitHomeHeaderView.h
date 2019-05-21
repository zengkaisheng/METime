//
//  MEVisitHomeHeaderView.h
//  ME时代
//
//  Created by hank on 2018/11/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEVistorCountModel;
const static CGFloat kMEVisitHomeHeaderViewHeight = 265;

@interface MEVisitHomeHeaderView : UITableViewHeaderFooterView

+ (CGFloat)getViewHeight;
- (void)setUIWithModel:(MEVistorCountModel *)model;

@end
