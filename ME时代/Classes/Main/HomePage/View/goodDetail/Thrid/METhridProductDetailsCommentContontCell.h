//
//  METhridProductDetailsCommentContontCell.h
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEGoodDetailCommentModel;

const static CGFloat kMEThridProductDetailsCommentContontCellHeight = 110;
const static CGFloat kMEThridProductDetailsCommentContontCellWdith = 260;

@interface METhridProductDetailsCommentContontCell : UICollectionViewCell

- (void)setUIWithModel:(MEGoodDetailCommentModel *)model;

@end

NS_ASSUME_NONNULL_END
