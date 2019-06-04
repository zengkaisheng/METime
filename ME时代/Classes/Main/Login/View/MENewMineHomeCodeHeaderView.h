//
//  MENewMineHomeCodeHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/6/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMENewMineHomeCodeHeaderViewHeight = 313;

@interface MENewMineHomeCodeHeaderView : UIView

- (void)reloadUIWithUserInfo;
- (void)clearUIWithUserInfo;
@property (weak, nonatomic) IBOutlet UILabel *LblTel;

@end

NS_ASSUME_NONNULL_END
