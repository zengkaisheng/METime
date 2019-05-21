//
//  MEMineExchangeCell.h
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEGoodModel;
#define kMEMineExchangeCellHeight  (130 * kMeFrameScaleX())

@interface MEMineExchangeCell : UITableViewCell

- (void)setUIWithModel:(MEGoodModel *)model ExchangeBlock:(kMeBasicBlock)exchangeBlock;

@end
