//
//  MESignInListCell.h
//  ME时代
//
//  Created by gao lei on 2019/6/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEPrizeListModel;

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMESignInListCellHeight = 350;

@interface MESignInListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (nonatomic,copy) kMeIndexBlock selectedIndexBlock;
@property (nonatomic,copy) kMeBasicBlock tapBlock;

- (void)setUIWithModel:(MEPrizeListModel *)model;

@end

NS_ASSUME_NONNULL_END
