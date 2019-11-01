//
//  MENewMineHomeContentCell.h
//  志愿星
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEMineHomeMuneChildrenModel;
NS_ASSUME_NONNULL_BEGIN

#define kMENewMineHomeContentCellHeight 75
#define kMENewMineHomeContentCellWdith ((SCREEN_WIDTH - 30)/3)

@interface MENewMineHomeContentCell : UICollectionViewCell

- (void)setUIWithType:(MEMineHomeMenuCellStyle )type;

- (void)setUIWithModel:(MEMineHomeMuneChildrenModel *)model;

@end

NS_ASSUME_NONNULL_END
