//
//  MEBrandAbilityAnalysisCell.h
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBrandAbilityAnalysisDataModel;
const static CGFloat kMEBrandAbilityAnalysisCellHeight =40;

@interface MEBrandAbilityAnalysisCell : UITableViewCell

- (void)setUIWithModel:(MEBrandAbilityAnalysisDataModel*)model;

@end

NS_ASSUME_NONNULL_END
