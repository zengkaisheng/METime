//
//  MEVistorVisterCell.h
//  ME时代
//
//  Created by hank on 2018/11/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEVistorUserModel;
const static CGFloat kMEVistorVisterCellHeight = 240;

@interface MEVistorVisterCell : UITableViewCell

- (void)setUIWithModel:(MEVistorUserModel *)model;
@property (nonatomic, copy) kMeBasicBlock setIntenBlock;
@end
