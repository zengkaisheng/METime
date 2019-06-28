//
//  MECommonQuestionListCell.h
//  ME时代
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MECommonQuestionListModel;

@interface MECommonQuestionListCell : UITableViewCell

@property (nonatomic, copy) kMeIndexBlock indexBlock;
- (void)setUIWithModel:(MECommonQuestionListModel *)model;

@end

NS_ASSUME_NONNULL_END
