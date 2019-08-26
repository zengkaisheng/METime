//
//  MECustomerServiceListCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MECustomerFileListModel;

NS_ASSUME_NONNULL_BEGIN

#define kMECustomerServiceListCellHeight 107

@interface MECustomerServiceListCell : UITableViewCell

@property (nonatomic ,copy) kMeIndexBlock tapBlock;
- (void)setUIWithModel:(MECustomerFileListModel *)model;

@end

NS_ASSUME_NONNULL_END
