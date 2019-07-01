//
//  MEBargainUsresCell.h
//  ME时代
//
//  Created by gao lei on 2019/7/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEBargainDetailModel;


@interface MEBargainUsresCell : UITableViewCell

@property (nonatomic,copy) kMeBOOLBlock moreBlock;

- (void)setUIWithModel:(MEBargainDetailModel *)model;

+ (CGFloat)getCellHeightWithArray:(NSArray *)array showMore:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
