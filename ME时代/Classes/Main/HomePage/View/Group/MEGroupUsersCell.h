//
//  MEGroupUsersCell.h
//  ME时代
//
//  Created by gao lei on 2019/7/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEGroupUsersCell : UITableViewCell

@property (nonatomic, copy) kMeIndexBlock indexBlock;
@property (nonatomic, copy) kMeBasicBlock checkMoreBlock;
- (void)setUIWithArray:(NSArray *)array count:(NSString *)count;
+ (CGFloat)getHeightWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
 
