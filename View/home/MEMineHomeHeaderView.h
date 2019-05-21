//
//  MEMineHomeHeaderView.h
//  ME时代
//
//  Created by Hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEMineHomeHeaderViewHeight = 280;
@interface MEMineHomeHeaderView : UIView

- (void)reloadUIWithUserInfo;
- (void)clearUIWithUserInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (nonatomic, copy) kMeBasicBlock addPhoneBlock;

@end
