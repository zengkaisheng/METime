//
//  MENewBaoQiangCell.h
//  ME时代
//
//  Created by hank on 2018/11/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMENewBaoQiangCellHeight (190* kMeFrameScaleX())

@interface MENewBaoQiangCell : UITableViewCell
- (void)setUIWithArr:(NSArray *)arrModel;
@property (nonatomic, copy) kMeIndexBlock indexBlock;
@end
