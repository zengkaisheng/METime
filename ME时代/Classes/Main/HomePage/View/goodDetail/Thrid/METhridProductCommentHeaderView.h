//
//  METhridProductCommentHeaderView.h
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEGoodDetailModel;
typedef enum : NSUInteger {
    METhridProductCommentHeaderViewAllType = 0,
    METhridProductCommentHeaderViewGoodType  = 1,
    METhridProductCommentHeaderViewPhotoType = 2,
} METhridProductCommentHeaderViewType;

const static CGFloat kMEThridProductCommentHeaderViewHeight = 103;

@interface METhridProductCommentHeaderView : UIView

@property (nonatomic, copy) kMeIndexBlock selectBlock;
- (void)setUIWithModel:(MEGoodDetailModel *)model type:(METhridProductCommentHeaderViewType)type;

@end

NS_ASSUME_NONNULL_END
