//
//  MEVistorPathCell.h
//  ME时代
//
//  Created by hank on 2018/11/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEVistorUserPathModel;
const static CGFloat kMEVistorPathCellHeight = 59;

@interface MEVistorPathCell : UITableViewCell

- (void)setUiWIthModel:(MEVistorUserPathModel *)model count:(NSInteger)count;

@end
