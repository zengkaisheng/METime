//
//  MEPosterContentListContentCell.h
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEPosterChildrenModel;
const static CGFloat kMEPosterContentListContentCellHeight  = 152;
#define kMEPosterContentListContentCellWdith (102)

@interface MEPosterContentListContentCell : UICollectionViewCell

- (void)setUIWithModel:(MEPosterChildrenModel *)model;
@end
