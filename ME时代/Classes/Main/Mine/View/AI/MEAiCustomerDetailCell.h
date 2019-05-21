//
//  MEAiCustomerDetailCell.h
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEAiCustomerDetailModel;
@interface MEAiCustomerDetailCell : UITableViewCell

- (void)setUIWithModel:(MEAiCustomerDetailModel *)model;
+ (CGFloat)getCellHeightWithModel:(MEAiCustomerDetailModel *)model;

@property (nonatomic , copy) kMeBasicBlock followBlock;
@property (nonatomic , copy) kMeBasicBlock addTagBlock;

@end

NS_ASSUME_NONNULL_END
