//
//  MEBdataStoreCustomerTopCell.h
//  ME时代
//
//  Created by hank on 2019/3/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBDataDealModel;

const static CGFloat kMEBdataStoreCustomerTopCellHeight = 146;

@interface MEBdataStoreCustomerTopCell : UITableViewCell

- (void)setUIWithModel:(MEBDataDealModel *)model;

@end

NS_ASSUME_NONNULL_END
