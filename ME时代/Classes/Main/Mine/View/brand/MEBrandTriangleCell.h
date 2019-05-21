//
//  MEBrandTriangleCell.h
//  ME时代
//
//  Created by hank on 2019/3/8.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBrandManngerAllModel;
const static CGFloat kMEBrandTriangleCellHeight = 285;

@interface MEBrandTriangleCell : UITableViewCell

- (void)setUIWithModel:(MEBrandManngerAllModel *)model;

@end

NS_ASSUME_NONNULL_END
