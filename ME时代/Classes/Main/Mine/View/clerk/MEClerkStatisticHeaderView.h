//
//  MEClerkStatisticHeaderView.h
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEClerkStatisticHeaderViewHeight = 125;

@interface MEClerkStatisticHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *lblAllMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayMoney;

@end
