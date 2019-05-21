//
//  MEBankTransferAccountsCell.h
//  ME时代
//
//  Created by hank on 2018/10/9.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kZLBankTransferAccountsCellHeight = 585.5;

@interface MEBankTransferAccountsCell : UITableViewCell

@property (nonatomic,copy)kMeBasicBlock tfAcoountBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;

+ (CGFloat)getCellHeigh;

@end
