//
//  MEMemberHomeDeanCell.h
//  ME时代
//
//  Created by hank on 2018/10/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEMemberHomeDeanCellHeight = 207.0f;

@interface MEMemberHomeDeanCell : UITableViewCell

- (void)setUIWithArr:(NSArray *)arrModel;
@property (nonatomic, copy) kMeIndexBlock indexBlock;

@end
