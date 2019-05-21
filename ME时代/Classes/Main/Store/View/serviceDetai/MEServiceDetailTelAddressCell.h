//
//  MEServiceDetailTelAddressCell.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEStoreDetailModel;
const static CGFloat kMEServiceDetailTelAddressCellHeight = 101;

@interface MEServiceDetailTelAddressCell : UITableViewCell

- (void)setUIWithModel:(MEStoreDetailModel *)model;

@end
