//
//  MEOperationContentCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEOperationContentCell : UITableViewCell

@property (nonatomic, copy) kMeIndexBlock indexBlock;
- (void)setUIWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
