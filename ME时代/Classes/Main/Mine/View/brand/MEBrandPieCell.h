//
//  MEBrandPieCell.h
//  ME时代
//
//  Created by hank on 2019/3/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEBrandPieCellHeight = 273;

@interface MEBrandPieCell : UITableViewCell

- (void)setUiWithModel:(NSArray *)model;

@end

NS_ASSUME_NONNULL_END
