//
//  MEVisterSectionView.m
//  ME时代
//
//  Created by hank on 2018/11/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEVisterSectionView.h"

@interface MEVisterSectionView ()
{
    MyEnumkMEVisterSectionViewType _type;
    kMeIndexBlock _tapBlock;
}
@property (weak, nonatomic) IBOutlet UIButton *btnall;
@property (weak, nonatomic) IBOutlet UIButton *btnHope;
@property (weak, nonatomic) IBOutlet UIButton *btnVisitor;

@end

@implementation MEVisterSectionView

- (void)setTypeWithType:(MyEnumkMEVisterSectionViewType)type block:(kMeIndexBlock)block{
    _type = type;
    _tapBlock = block;
    [self setTypeWith:type];
}

- (IBAction)allAction:(UIButton *)sender {
    kMeCallBlock(_tapBlock,MyEnumkMEVisterSectionViewAllType);
}

- (IBAction)hopeAction:(UIButton *)sender {
   kMeCallBlock(_tapBlock,MyEnumkMEVisterSectionViewHopeType);
}

- (IBAction)visterAction:(UIButton *)sender {
    kMeCallBlock(_tapBlock,MyEnumkMEVisterSectionViewVisterType);
}

- (void)setTypeWith:(MyEnumkMEVisterSectionViewType)type{
    switch (type) {
        case MyEnumkMEVisterSectionViewAllType:{
            [_btnall setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            _btnall.borderColor = [UIColor colorWithHexString:@"333333"];
            
            [_btnHope setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            _btnHope.borderColor = [UIColor colorWithHexString:@"999999"];
            
            [_btnVisitor setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            _btnVisitor.borderColor = [UIColor colorWithHexString:@"999999"];
        }
            break;
        case MyEnumkMEVisterSectionViewHopeType:{
            [_btnHope setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            _btnHope.borderColor = [UIColor colorWithHexString:@"333333"];
            
            [_btnall setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            _btnall.borderColor = [UIColor colorWithHexString:@"999999"];
            
            [_btnVisitor setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            _btnVisitor.borderColor = [UIColor colorWithHexString:@"999999"];
        }
            break;
        case MyEnumkMEVisterSectionViewVisterType:{
            [_btnVisitor setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            _btnVisitor.borderColor = [UIColor colorWithHexString:@"333333"];
            
            [_btnall setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            _btnall.borderColor = [UIColor colorWithHexString:@"999999"];
            
            [_btnHope setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            _btnHope.borderColor = [UIColor colorWithHexString:@"999999"];
        }
            break;
        default:
            break;
    }
}

@end
