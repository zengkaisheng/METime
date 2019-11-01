//
//  MEPublicShowContentCell.h
//  志愿星
//
//  Created by gao lei on 2019/10/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEPublicShowDetailModel;

@interface MEPublicShowContentCell : UITableViewCell

@property (nonatomic, copy) kMeIndexBlock indexBlock;

- (void)setUIWithModel:(MEPublicShowDetailModel *)model;
+ (CGFloat)getCellHeightithModel:(MEPublicShowDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
