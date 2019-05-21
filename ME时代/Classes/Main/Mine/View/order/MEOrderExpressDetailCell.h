//
//  MEOrderExpressDetailCell.h
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEexpressDetailModel;

@interface MEOrderExpressDetailCell : UITableViewCell

- (void)setUIWIthModel:(MEexpressDetailModel *)model;
+ (CGFloat)getCellHeightWithModel:(MEexpressDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
