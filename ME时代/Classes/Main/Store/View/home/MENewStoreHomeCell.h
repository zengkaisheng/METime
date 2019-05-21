//
//  MENewStoreHomeCell.h
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEStoreModel;
const static CGFloat kMENewStoreHomeCellHeight = 99;

@interface MENewStoreHomeCell : UITableViewCell

- (void)setUIWithModel:(MEStoreModel *)model;
- (void)setUIWithModel:(MEStoreModel *)model WithKey:(NSString *)key;
+ (CGFloat)getCellHeightWithmodel:(MEStoreModel *)model;

@end

NS_ASSUME_NONNULL_END
