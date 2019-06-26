//
//  MEBargainLisCell.h
//  ME时代
//
//  Created by gao lei on 2019/6/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEBargainListModel;
@class MEMyBargainListModel;

#define kMEBargainLisCellHeight 117

@interface MEBargainLisCell : UITableViewCell

@property (nonatomic,copy) kMeBasicBlock tapBlock;

- (void)setUIWithModel:(MEBargainListModel *)model;

- (void)setMyBargainUIWithModel:(MEMyBargainListModel *)model;

@end

NS_ASSUME_NONNULL_END
