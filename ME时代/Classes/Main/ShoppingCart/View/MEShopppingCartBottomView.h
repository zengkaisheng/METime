//
//  MEShopppingCartBottomView.h
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEShopppingCartBottomViewHeight = 50;

@interface MEShopppingCartBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (nonatomic, assign) BOOL isClick; 

@property (nonatomic, copy) kMeBOOLBlock AllClickBlock;
@property (nonatomic, copy) kMeBasicBlock AccountBlock;
@property (nonatomic, copy) kMeBasicBlock DelBlock;

- (void)clearData;
@end
