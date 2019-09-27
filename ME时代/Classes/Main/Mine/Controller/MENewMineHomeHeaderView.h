//
//  MENewMineHomeHeaderView.h
//  ME时代
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMENewMineHomeHeaderViewHeight = 295;
@interface MENewMineHomeHeaderView : UIView

- (void)reloadUIWithUserInfo;
- (void)clearUIWithUserInfo;

@property (nonatomic, copy) kMeBasicBlock changeStatus;
@property (nonatomic, copy) kMeIndexBlock indexBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblTel;
@property (nonatomic, strong) NSArray *orderList;
@end

NS_ASSUME_NONNULL_END
