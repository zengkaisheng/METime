//
//  MEMyInfoListCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEAddCustomerInfoModel;

@interface MEMyInfoListCell : UITableViewCell

@property (nonatomic, copy) kMeTextBlock textBlock;
- (void)setUIWithCustomerModel:(MEAddCustomerInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
