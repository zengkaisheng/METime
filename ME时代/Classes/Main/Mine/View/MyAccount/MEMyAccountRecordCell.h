//
//  MEMyAccountRecordCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEMyAccountRecordModel;

@interface MEMyAccountRecordCell : UITableViewCell

- (void)setUIWithModel:(MEMyAccountRecordModel *)model;

@end

NS_ASSUME_NONNULL_END
