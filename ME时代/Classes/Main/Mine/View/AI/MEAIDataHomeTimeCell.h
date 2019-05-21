//
//  MEAIDataHomeTimeCell.h
//  ME时代
//
//  Created by hank on 2019/4/9.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEAIDataHomeTimeModel;
const static CGFloat kMEAIDataHomeTimeCellHeight = 95;

@interface MEAIDataHomeTimeCell : UITableViewCell

- (void)setUIWithModel:(MEAIDataHomeTimeModel *)model;
- (void)setPeopleUIWithModel:(MEAIDataHomeTimeModel *)model;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;

@end

NS_ASSUME_NONNULL_END
