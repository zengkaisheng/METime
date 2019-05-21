//
//  MEBrandStoryHeaderView.m
//  ME时代
//
//  Created by hank on 2019/4/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandStoryHeaderView.h"
#import "MEBrandStoryModel.h"

@interface MEBrandStoryHeaderView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTel;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCount;

@property (weak, nonatomic) IBOutlet UIView *viewforSelect;
@property (weak, nonatomic) IBOutlet UIView *viewforMask;

@end

@implementation MEBrandStoryHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_tfTitle addTarget:self action:@selector(tfCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tfTitle addTarget:self action:@selector(tfVerficationTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    _tfTitle.delegate = self;
    _viewforSelect.hidden = YES;
    _viewforMask.hidden = YES;
    _viewforMask.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_viewforMask addGestureRecognizer:ges];
    
}

- (void)tap{
    _viewforSelect.hidden = YES;
    _viewforMask.hidden = YES;
}

- (void)tfCodeTextDidChange:(UITextField *)textField{
    if(textField.text.length> 20){
        textField.text = [textField.text substringWithRange:NSMakeRange(0,20)];
          _lblTitleCount.text = [NSString stringWithFormat:@"20/20"];
    }
    _lblTitleCount.text = [NSString stringWithFormat:@"%@/20",@(textField.text.length)];
}

- (void)tfVerficationTextDidChange:(UITextField *)textField{
    if(textField.text.length> 20){
        textField.text = [textField.text substringWithRange:NSMakeRange(0,20)];
        _lblTitleCount.text = [NSString stringWithFormat:@"20/20"];
    }
    _lblTitleCount.text = [NSString stringWithFormat:@"%@/20",@(textField.text.length)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

- (IBAction)timeAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(tapTimeAction)]) {
        [_deleate tapTimeAction];
    }
}

- (IBAction)telAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(tapTelAction)]) {
        [_deleate tapTelAction];
    }
}

- (IBAction)addressAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(tapAddressAction)]) {
        [_deleate tapAddressAction];
    }
}

- (IBAction)detailAddressAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(tapdetailAddressAction)]) {
        [_deleate tapdetailAddressAction];
    }
}

- (IBAction)upLoadVideoAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(uploadVideo)]) {
        [_deleate uploadVideo];
    }
}
- (IBAction)addAction:(UIButton *)sender {
    _viewforSelect.hidden = NO;
    _viewforMask.hidden = NO;
}

- (IBAction)addpicAction:(UIButton *)sender {
    _viewforSelect.hidden = YES;
    _viewforMask.hidden = YES;
    if ([_deleate respondsToSelector:@selector(addActionWithType:)]) {
        [_deleate addActionWithType:MEBrandStoryContentModelPicType];
    }
}

- (IBAction)addvideocAction:(UIButton *)sender {
    _viewforSelect.hidden = YES;
    _viewforMask.hidden = YES;
    if ([_deleate respondsToSelector:@selector(addActionWithType:)]) {
        [_deleate addActionWithType:MEBrandStoryContentModelVideoType];
    }
}

- (IBAction)addtextAction:(UIButton *)sender {
    _viewforSelect.hidden = YES;
    _viewforMask.hidden = YES;
    if ([_deleate respondsToSelector:@selector(addActionWithType:)]) {
        [_deleate addActionWithType:MEBrandStoryContentModelTXTType];
    }
}

- (void)clearSelect{
    _viewforSelect.hidden = YES;
    _viewforMask.hidden = YES;
}

@end
