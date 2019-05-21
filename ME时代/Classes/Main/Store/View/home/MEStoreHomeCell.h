//
//  MEStoreHomeCell.h
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEStoreModel;
#define kMEStoreHomeCellHeight  (89 + (220 *kMeFrameScaleY()))

@interface MEStoreHomeCell : UITableViewCell

- (void)setUIWithModel:(MEStoreModel *)model;
- (void)setUIWithModel:(MEStoreModel *)model WithKey:(NSString *)key;
+ (CGFloat)getCellHeightWithModel:(MEStoreModel *)model;
@end
