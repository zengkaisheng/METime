//
//  MERankingListCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEOperationClerkRankModel;
@class MEOperationObjectRankModel;

NS_ASSUME_NONNULL_BEGIN

@interface MERankingListCell : UITableViewCell

- (void)setUIWithClerkModel:(MEOperationClerkRankModel *)model index:(NSInteger)index;

- (void)setUIWithObjectRankModel:(MEOperationObjectRankModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
