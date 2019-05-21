//
//  MENewMineHomeContentCell.h
//  ME时代
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMENewMineHomeContentCellHeight 75
#define kMENewMineHomeContentCellWdith ((SCREEN_WIDTH - 30)/3)

@interface MENewMineHomeContentCell : UICollectionViewCell

- (void)setUIWithType:(MEMineHomeCellStyle )type;

@end

NS_ASSUME_NONNULL_END
