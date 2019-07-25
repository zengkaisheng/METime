//
//  MEHomeTestAddContentCell.h
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEHomeTestAddContentCellHeight = 256;

@class MEHomeAddTestDecContentModel;
@interface MEHomeTestAddContentCell : UITableViewCell

- (void)setUiWithModel:(MEHomeAddTestDecContentModel *)model;



@end

NS_ASSUME_NONNULL_END
