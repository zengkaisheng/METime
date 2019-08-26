//
//  MEServiceCardCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEServiceDetailSubModel;
NS_ASSUME_NONNULL_BEGIN

#define kMEServiceCardCellHeight 113

@interface MEServiceCardCell : UITableViewCell

- (void)setUIWithServiceModel:(MEServiceDetailSubModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
