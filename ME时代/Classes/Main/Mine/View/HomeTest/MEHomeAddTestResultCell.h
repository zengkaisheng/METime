//
//  MEHomeAddTestResultCell.h
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEHomeAddTestDecResultModel;
const static CGFloat kMEHomeAddTestResultCellHeight = 364;

@interface MEHomeAddTestResultCell : UITableViewCell

@property (nonatomic,copy)kMeBasicBlock addPhotoBlock;
- (void)setUiWIthModel:(MEHomeAddTestDecResultModel *)model index:(NSInteger)index type:(MEHomeAddTestDecTypeVC)type;

@end

NS_ASSUME_NONNULL_END
