//
//  MERecruitCommentCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^kMeCustomerBlock)(NSString *str,NSInteger index);

@interface MERecruitCommentCell : UITableViewCell

@property (nonatomic, copy) kMeCustomerBlock tapBlock;
- (void)setUIWithArray:(NSArray *)array;

- (void)setShowUIWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
