//
//  MEAiTagCell.h
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEAiTagCellW (SCREEN_WIDTH - 90)/3
#define kMEAiTagCellH 30
#define kMEAiTagCellMargin 15

@class MEAiCustomerTagchildrenModel;
@interface MEAiTagCell : UICollectionViewCell

- (void)setUIWithModel:(MEAiCustomerTagchildrenModel *)model;

@end

NS_ASSUME_NONNULL_END
