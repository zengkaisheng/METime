//
//  MEFiveHomeEntranceCell.h
//  志愿星
//
//  Created by gao lei on 2019/10/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class METhridHomeAdModel;

#define kMEFiveHomeEntranceCellWdith ((SCREEN_WIDTH - 30)/2)
#define kMEFiveHomeEntranceCellHeight 106*kMeFrameScaleX()

@interface MEFiveHomeEntranceCell : UICollectionViewCell

- (void)setUIWithModel:(METhridHomeAdModel *)model;

@end

NS_ASSUME_NONNULL_END
