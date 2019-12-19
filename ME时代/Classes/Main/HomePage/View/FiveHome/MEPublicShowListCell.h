//
//  MEPublicShowListCell.h
//  ME时代
//
//  Created by gao lei on 2019/12/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MECommunityServericeListModel;

#define kMEPublicShowListCellHeight 146

@interface MEPublicShowListCell : UICollectionViewCell

@property (nonatomic, copy) kMeIndexBlock indexBlock;

- (void)setShowUIWithModel:(MECommunityServericeListModel *)model;

@end

NS_ASSUME_NONNULL_END
