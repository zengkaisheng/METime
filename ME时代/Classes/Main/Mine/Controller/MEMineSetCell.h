//
//  MEMineSetCell.h
//  ME时代
//
//  Created by hank on 2018/9/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEMineSetCellHeight = 50;

@interface MEMineSetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//- (void)setType:(MESetStyle)type status:(BOOL)status switchBlock:(kMeBOOLBlock)switchBlock;

@end
