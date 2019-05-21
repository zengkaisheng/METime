//
//  MEMineExchangeRudeSectionView.h
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEMineExchangeRudeSectionViewHeight = 50;

@interface MEMineExchangeRudeSectionView : UITableViewHeaderFooterView

- (void)setUIWihtStr:(NSString *)title isExpand:(BOOL)isExpand ExpandBlock:(kMeBOOLBlock)expandBlock;


@end
