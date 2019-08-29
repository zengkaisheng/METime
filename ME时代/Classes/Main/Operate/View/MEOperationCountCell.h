//
//  MEOperationCountCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEOperateDataSubModel;

@interface MEOperationCountCell : UITableViewCell

@property (nonatomic, copy) kMeIndexBlock indexBlock;

- (void)setUpWithModel:(MEOperateDataSubModel *)model type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
