//
//  MEHomeAddTestDecCell.h
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEHomeAddTestDecModel;

const static CGFloat kMEHomeAddTestDecCellHeight = 416;

@interface MEHomeAddTestDecCell : UITableViewCell

@property (nonatomic,copy)kMeBasicBlock addPhotoBlcok;

- (void)setUIWIthModel:(MEHomeAddTestDecModel *)model;

@end

NS_ASSUME_NONNULL_END
