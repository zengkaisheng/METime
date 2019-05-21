//
//  MeHomeNewGuideCell.h
//  ME时代
//
//  Created by hank on 2019/5/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MeHomeNewGuideModel;

@interface MeHomeNewGuideCell : UITableViewCell

- (void)setUIWitModel:(MeHomeNewGuideModel *)model;
+ (CGFloat)getCellHeight;
@end

NS_ASSUME_NONNULL_END
