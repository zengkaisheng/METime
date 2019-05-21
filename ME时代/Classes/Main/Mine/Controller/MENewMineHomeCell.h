//
//  MENewMineHomeCell.h
//  ME时代
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MENewMineHomeCell : UITableViewCell

- (void)setUIWithAtrr:(NSArray *)arr title:(NSString*)title;
+ (CGFloat)getHeightWithArr:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
