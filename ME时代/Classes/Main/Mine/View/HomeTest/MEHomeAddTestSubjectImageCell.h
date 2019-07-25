//
//  MEHomeAddTestSubjectImageCell.h
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEHomeAddTestDecContentModel;

@interface MEHomeAddTestSubjectImageCell : UICollectionViewCell

@property (nonatomic,copy)kMeBasicBlock forBlock;
@property (nonatomic,copy)kMeBasicBlock nextBlock;
@property (nonatomic,copy)kMeBasicBlock addPhotoBlock;

- (void)setUIWithModel:(MEHomeAddTestDecContentModel*)model index:(NSInteger)index type:(MEHomeAddTestDecTypeVC)type;

@end

NS_ASSUME_NONNULL_END
