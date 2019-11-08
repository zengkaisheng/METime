//
//  MESignInActivityCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MESignInActivityModel;

@interface MESignInActivityCell : UITableViewCell

- (void)setUIWithModel:(MESignInActivityModel *)model;

@end

NS_ASSUME_NONNULL_END
