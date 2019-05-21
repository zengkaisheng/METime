//
//  MEAddClerkCell.h
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEClerkModel;
const static CGFloat kMEAddClerkCellHeight = 84;

@interface MEAddClerkCell : UITableViewCell

- (void)setUIWIthModel:(MEClerkModel *)model;
- (void)setUIWithModel:(MEClerkModel *)model withKey:(NSString *)key;
@property (nonatomic, copy) kMeBasicBlock updateBlock;

@end
