//
//  MEApplyOrganizationCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEAddCustomerInfoModel;

@interface MEApplyOrganizationCell : UITableViewCell

@property (nonatomic, copy) kMeTextBlock textBlock;
@property (nonatomic, copy) kMeBasicBlock reloadBlock;
@property (nonatomic, copy) kMeIndexBlock indexBlock;
- (void)setUIWithCustomerModel:(MEAddCustomerInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
