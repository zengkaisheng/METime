//
//  MEAICustomerCheckDetailCell.h
//  ME时代
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEAICustomerCheckDetailModel;
NS_ASSUME_NONNULL_BEGIN

const static CGFloat MEAICustomerCheckDetailCellHeight = 65;

@interface MEAICustomerCheckDetailCell : UITableViewCell

- (void)setUIWithModel:(MEAICustomerCheckDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
