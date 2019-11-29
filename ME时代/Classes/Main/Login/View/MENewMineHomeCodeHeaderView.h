//
//  MENewMineHomeCodeHeaderView.h
//  志愿星
//
//  Created by gao lei on 2019/6/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMENewMineHomeCodeHeaderViewHeight = 314;

@interface MENewMineHomeCodeHeaderView : UIView

- (void)reloadUIWithUserInfo;
- (void)clearUIWithUserInfo;

@property (nonatomic, copy) kMeBasicBlock changeStatus;
@property (nonatomic, copy) kMeIndexBlock indexBlock;
@property (nonatomic, copy) kMeBasicBlock changeBlock;
@property (weak, nonatomic) IBOutlet UILabel *LblTel;
@property (nonatomic, strong) NSArray *orderList;

@end

NS_ASSUME_NONNULL_END
