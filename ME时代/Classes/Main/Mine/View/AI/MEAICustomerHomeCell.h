//
//  MEAICustomerHomeCell.h
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEAICustomerHomeModel;
const static CGFloat kMEAICustomerHomeCellHeight = 77;

@interface MEAICustomerHomeCell : UITableViewCell

- (void)setUiWithAddModel:(MEAICustomerHomeModel *)model;
- (void)setSearchUiWithAddModel:(MEAICustomerHomeModel *)model;
@end

NS_ASSUME_NONNULL_END
