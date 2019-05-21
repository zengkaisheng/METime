//
//  MEPolarChartMixedCell.h
//  ME时代
//
//  Created by hank on 2019/3/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBrandAbilityAnalysisModel;
const static CGFloat kMEPolarChartMixedCellHeight = 311;

@interface MEPolarChartMixedCell : UITableViewCell

- (void)setUiWithModel:(MEBrandAbilityAnalysisModel *)model;

@end

NS_ASSUME_NONNULL_END
