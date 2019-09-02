//
//  MEOperationRankCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOperationRankCell.h"
#import "MEOperationClerkRankModel.h"
#import "MEOperationObjectRankModel.h"

@interface MEOperationRankCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *topNumLbl;

@property (weak, nonatomic) IBOutlet UILabel *centerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *centerNumLbl;

@property (weak, nonatomic) IBOutlet UILabel *bottomNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomNumLbl;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *firsetNumLbl;
@property (weak, nonatomic) IBOutlet UIImageView *goldImgV;

@property (weak, nonatomic) IBOutlet UILabel *secondNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondNumLbl;
@property (weak, nonatomic) IBOutlet UIImageView *silverImgV;

@property (weak, nonatomic) IBOutlet UILabel *thirdNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *thirdNumLbl;
@property (weak, nonatomic) IBOutlet UIImageView *brassImgV;

@property (weak, nonatomic) IBOutlet UIView *noDatasView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noDataViewConsTop;

@end

@implementation MEOperationRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.hidden = YES;
    self.noDatasView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUpUIWithArry:(NSArray *)array type:(NSInteger)type index:(NSInteger)index{
    if (type == 4) {
        for (id obj in _topView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                [obj removeFromSuperview];
            }
        }
        NSArray *btns = @[@"业绩",@"消耗",@"项目数",@"客次数"];
        CGFloat btnWidth = 50;
        for (int i = 0; i < btns.count; i++) {
            UIButton *btn = [self createBtnWithTitle:btns[i] frame:CGRectMake(btnWidth*i, 0, btnWidth, 24) tag:102+i];
            
            if (index == i) {
                btn.selected = YES;
                btn.layer.borderWidth = 0.0;
                [btn setBackgroundColor:[UIColor colorWithHexString:@"#B29FFF"]];
            }
            [_topView addSubview:btn];
        }
        
        self.bgView.hidden = YES;
        _topNameLbl.text = _topNumLbl.text = _centerNameLbl.text = _centerNumLbl.text = _bottomNameLbl.text = _bottomNumLbl.text = @" ";
        if (array.count <= 0) {
            _noDatasView.hidden = NO;
            _noDataViewConsTop.constant = 50.0;
        }else {
            _noDatasView.hidden = YES;
        }
        for (int i = 0; i < array.count; i++) {
            MEOperationClerkRankModel *model = array[i];
            if (i == 0) {
                _topNameLbl.text = kMeUnNilStr(model.name);
                _topNumLbl.text = [NSString stringWithFormat:@"%@",@(model.money)];
//                if (index == 0 || index == 1) {
//                    _topNumLbl.text = [NSString stringWithFormat:@"%@",@(model.money)];
//                }
            }else if (i == 1) {
                _centerNameLbl.text = kMeUnNilStr(model.name);
                _centerNumLbl.text = [NSString stringWithFormat:@"%@",@(model.money)];
//                if (index == 0 || index == 1) {
//                    _topNumLbl.text = [NSString stringWithFormat:@"%@",@(model.money)];
//                }
            }else if (i == 2) {
                _bottomNameLbl.text = kMeUnNilStr(model.name);
                _bottomNumLbl.text = [NSString stringWithFormat:@"%@",@(model.money)];
//                if (index == 0 || index == 1) {
//                    _topNumLbl.text = [NSString stringWithFormat:@"%@",@(model.money)];
//                }
            }
        }
    }else if (type == 5) {
        self.bgView.hidden = NO;
        if (array.count <= 0) {
            _goldImgV.hidden = YES;
            _silverImgV.hidden = YES;
            _brassImgV.hidden = YES;
            _noDatasView.hidden = NO;
            _noDataViewConsTop.constant = 24.0;
        }else {
            _noDatasView.hidden = YES;
        }
        _firstNameLbl.text = _firsetNumLbl.text = _secondNameLbl.text = _secondNumLbl.text = _thirdNameLbl.text = _thirdNumLbl.text = @" ";
        for (int i = 0; i < array.count; i++) {
            MEOperationObjectRankModel *model = array[i];
            if (i == 0) {
                _goldImgV.hidden = NO;
                _firstNameLbl.text = kMeUnNilStr(model.name);
                _firsetNumLbl.text = [NSString stringWithFormat:@"%@",@(model.total_money)];
            }else if (i == 1) {
                _silverImgV.hidden = NO;
                _secondNameLbl.text = kMeUnNilStr(model.name);
                _secondNumLbl.text = [NSString stringWithFormat:@"%@",@(model.total_money)];
            }else if (i == 2) {
                _brassImgV.hidden = NO;
                _thirdNameLbl.text = kMeUnNilStr(model.name);
                _thirdNumLbl.text = [NSString stringWithFormat:@"%@",@(model.total_money)];
            }
        }
    }
}

- (void)btnDidClick:(UIButton *)sender {
    for (UIButton *btn in _topView.subviews) {
        btn.selected = NO;
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    UIButton *selectedBtn = (UIButton *)sender;
    selectedBtn.selected = YES;
     selectedBtn.layer.borderWidth = 0.0;
    [selectedBtn setBackgroundColor:[UIColor colorWithHexString:@"#B29FFF"]];
    kMeCallBlock(self.indexBlock,selectedBtn.tag - 100);
}

- (UIButton *)createBtnWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#1D1D1D"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.layer.borderWidth = 1.0;
    btn.frame = frame;
    btn.tag = tag;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
