//
//  MEHomeAddTestSubjectContentCell.h
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEHomeAddTestDecContentModel;

@interface MEHomeAddTestSubjectContentCell : UICollectionViewCell

@property (nonatomic,copy)kMeBasicBlock forBlock;
@property (nonatomic,copy)kMeBasicBlock nextBlock;
@property (nonatomic,copy)kMeBasicBlock addTextBlock;
- (void)setUIWithModel:(MEHomeAddTestDecContentModel*)model index:(NSInteger)index type:(MEHomeAddTestDecTypeVC)type;

@end

NS_ASSUME_NONNULL_END
