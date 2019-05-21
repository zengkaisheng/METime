//
//  MECommondCouponCell.h
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MECommondCouponCell : UITableViewCell

- (void)setUIWithArr:(NSArray *)arrModel imgUrl:(NSString *)imgUrl;
+ (CGFloat)getCellHeight;

@end

NS_ASSUME_NONNULL_END
