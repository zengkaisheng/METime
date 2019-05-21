//
//  MEBdataTopCell.h
//  ME时代
//
//  Created by hank on 2019/3/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBDataDealModel;
const static CGFloat kMEBdataTopCellHeight = 242;

@interface MEBdataTopCell : UITableViewCell

- (void)setUIWithModel:(MEBDataDealModel *)Model;


@end

NS_ASSUME_NONNULL_END
