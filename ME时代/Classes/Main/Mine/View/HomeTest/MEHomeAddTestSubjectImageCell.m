//
//  MEHomeAddTestSubjectImageCell.m
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeAddTestSubjectImageCell.h"
#import "MEHomeAddTestDecModel.h"
#import "MEPickerDayView.h"

@interface MEHomeAddTestSubjectImageCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnFor;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgMainPic;
@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;
@property (weak, nonatomic) IBOutlet UIButton *btnD;
@property (nonatomic,strong) MEHomeAddTestDecContentModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewHeight;

@property (weak, nonatomic) IBOutlet UIView *viewForPhoto;
@property (weak, nonatomic) IBOutlet UIView *viewForSelect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSelectHeight;
@end

@implementation MEHomeAddTestSubjectImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _consSelectHeight.constant = 140 * kMeFrameScaleX();
    _consViewHeight.constant = 197 * kMeFrameScaleX();
}

- (void)setUIWithModel:(MEHomeAddTestDecContentModel*)model index:(NSInteger)index type:(MEHomeAddTestDecTypeVC)type{
    if(type == MEHomeAddTestDecTypelplatVC){
        _viewForPhoto.userInteractionEnabled = NO;
        _viewForSelect.userInteractionEnabled = NO;
        _btnAddPhoto.hidden = YES;
    }else{
        _viewForPhoto.userInteractionEnabled = YES;
        _viewForSelect.userInteractionEnabled = YES;
        _btnAddPhoto.hidden = NO;
    }
    _model = model;
    _btnFor.userInteractionEnabled = index!=0;
    if(kMeUnNilStr(model.image).length){
        kSDLoadImg(_imgMainPic, MELoadQiniuImagesWithUrl(model.image));
    }else{
        _imgMainPic.image = nil;
    }
    [_btnA setTitle:kMeUnNilStr(model.score_a).length?[kMeUnNilStr(model.score_a) stringByAppendingString:@"分"]:@"请选择" forState:UIControlStateNormal];
    [_btnB setTitle:kMeUnNilStr(model.score_b).length?[kMeUnNilStr(model.score_b)stringByAppendingString:@"分"]:@"请选择" forState:UIControlStateNormal];
    [_btnC setTitle:kMeUnNilStr(model.score_c).length?[kMeUnNilStr(model.score_c)stringByAppendingString:@"分"]:@"请选择" forState:UIControlStateNormal];
    [_btnD setTitle:kMeUnNilStr(model.score_d).length?[kMeUnNilStr(model.score_d)stringByAppendingString:@"分"]:@"请选择" forState:UIControlStateNormal];
}

- (IBAction)forAction:(UIButton *)sender {
    kMeCallBlock(_forBlock);
}

- (IBAction)nextAction:(UIButton *)sender {
    if(!kMeUnNilStr(_model.image).length){
        [MEShowViewTool showMessage:@"请先上传图片" view:self];
        return;
    }
    if(!kMeUnNilStr(_model.score_a).length){
        [MEShowViewTool showMessage:@"请先选择A答案的分数" view:self];
        return;
    }
    if(!kMeUnNilStr(_model.score_b).length){
        [MEShowViewTool showMessage:@"请先选择B答案的分数" view:self];
        return;
    }
    if(!kMeUnNilStr(_model.score_c).length){
        [MEShowViewTool showMessage:@"请先选择C答案的分数" view:self];
        return;
    }
    if(!kMeUnNilStr(_model.score_d).length){
        [MEShowViewTool showMessage:@"请先选择D答案的分数" view:self];
        return;
    }
    kMeCallBlock(_nextBlock);
}
- (IBAction)addPhotoAction:(UIButton *)sender {
    kMeCallBlock(_addPhotoBlock);
}

- (IBAction)AAction:(UIButton *)sender {
    kMeWEAKSELF
    MEPickerDayView *view = [[MEPickerDayView alloc]initWithSelectedDate:^(NSString *str) {
        kMeSTRONGSELF
        [strongSelf->_btnA setTitle:[str stringByAppendingString:@"分"] forState:UIControlStateNormal];
        strongSelf->_model.score_a = kMeUnNilStr(str);
    } arrDay:@[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"]];
    [kMeCurrentWindow endEditing:YES];
    [kMeCurrentWindow addSubview:view];
}

- (IBAction)BAction:(UIButton *)sender {
    kMeWEAKSELF
    
    MEPickerDayView *view = [[MEPickerDayView alloc]initWithSelectedDate:^(NSString *str) {
        kMeSTRONGSELF
        [strongSelf->_btnB setTitle:[str stringByAppendingString:@"分"] forState:UIControlStateNormal];
        strongSelf->_model.score_b = kMeUnNilStr(str);
    } arrDay:@[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"]];
    [kMeCurrentWindow endEditing:YES];
    [kMeCurrentWindow addSubview:view];
}

- (IBAction)CAction:(UIButton *)sender {
    kMeWEAKSELF
    
    MEPickerDayView *view = [[MEPickerDayView alloc]initWithSelectedDate:^(NSString *str) {
        kMeSTRONGSELF
        [strongSelf->_btnC setTitle:[str stringByAppendingString:@"分"] forState:UIControlStateNormal];
        strongSelf->_model.score_c = kMeUnNilStr(str);
    } arrDay:@[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"]];
    [kMeCurrentWindow endEditing:YES];
    [kMeCurrentWindow addSubview:view];
}

- (IBAction)DAction:(UIButton *)sender {
    kMeWEAKSELF
    
    MEPickerDayView *view = [[MEPickerDayView alloc]initWithSelectedDate:^(NSString *str) {
        kMeSTRONGSELF
        [strongSelf->_btnD setTitle:[str stringByAppendingString:@"分"] forState:UIControlStateNormal];
        strongSelf->_model.score_d = kMeUnNilStr(str);
    } arrDay:@[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"]];
    [kMeCurrentWindow endEditing:YES];
    [kMeCurrentWindow addSubview:view];
}


@end
