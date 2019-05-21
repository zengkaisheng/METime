//
//  MEMineExchangeRudeSectionView.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineExchangeRudeSectionView.h"

@interface MEMineExchangeRudeSectionView (){
    kMeBOOLBlock _expandBlock;
    BOOL _isExpand;
}

//@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;

@end

@implementation MEMineExchangeRudeSectionView

- (void)setUIWihtStr:(NSString *)title isExpand:(BOOL)isExpand ExpandBlock:(kMeBOOLBlock)expandBlock{
    _btnExpand.selected = isExpand;
    _expandBlock = expandBlock;
    _isExpand = isExpand;
    _lblTitle.text = kMeUnNilStr(title);
    _imgIcon.transform = isExpand?CGAffineTransformMakeRotation(M_PI/2):CGAffineTransformIdentity;
}

- (IBAction)expandAction:(UIButton *)sender {
    _btnExpand.selected = !_btnExpand.selected;
    BOOL isExpand = _btnExpand.selected;
    kMeWEAKSELF
    if(isExpand){
        [UIView animateWithDuration:0.2f animations:^{
            kMeSTRONGSELF
            strongSelf->_imgIcon.transform = CGAffineTransformMakeRotation(M_PI/2);
        } completion:^(BOOL finished) {
            kMeSTRONGSELF
            kMeCallBlock(strongSelf->_expandBlock,isExpand);
        }];
    }else{
        [UIView animateWithDuration:0.2f animations:^{
            kMeSTRONGSELF
            strongSelf->_imgIcon.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            kMeSTRONGSELF
            kMeCallBlock(strongSelf->_expandBlock,isExpand);
        }];
    }
   
}
@end
