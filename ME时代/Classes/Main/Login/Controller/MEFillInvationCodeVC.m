//
//  MEFillInvationCodeVC.m
//  志愿星
//
//  Created by gao lei on 2019/6/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFillInvationCodeVC.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface MEFillInvationCodeVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *invationCodeTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtnConsTop;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation MEFillInvationCodeVC

+ (void)presentFillInvationCodeVCWithSuccessHandler:(kMeObjBlock)blockSuccess failHandler:(kMeObjBlock)blockFail{
    MEFillInvationCodeVC *codevc = [[MEFillInvationCodeVC alloc]init];
    codevc.blockSuccess = blockSuccess;
    codevc.blockFail = blockFail;
    [MECommonTool presentViewController:codevc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBarHidden = YES;
    _headerView.hidden = YES;
    _invationCodeTF.delegate = self;
    _confirmBtn.enabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    _invationCodeTF.keyboardType = UIKeyboardTypeASCIICapable;
    [_invationCodeTF addTarget:self action:@selector(invationCodeTFCodeTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (CAGradientLayer *)getLayerWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors locations:(NSArray *)locations frame:(CGRect)frame {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = startPoint;//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = endPoint;//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = colors;
    layer.locations = locations;//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = frame;
    return layer;
}

#pragma mark - UITextFieldDelegate Action13168734537
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // text field 上实际字符长度
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    return [string isEqualToString:filtered] && (strLength <= 6);
}

- (void)invationCodeTFCodeTextDidChange:(UITextField *)textField{
    if(textField.text.length > kLimitVerficationNum){
        textField.text = [textField.text substringWithRange:NSMakeRange(0,kLimitVerficationNum + 1)];
        //18816766199
        kMeWEAKSELF
        [MEPublicNetWorkTool postGetCodeMsgWithInvitationCode:textField.text successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = (NSDictionary *)responseObject.data;
                if ([data[@"status"] integerValue] == 1) {
                    strongSelf->_lineView.backgroundColor = [UIColor colorWithHexString:@"#FF88A4"];
                    
                    CAGradientLayer *btnLayer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:255/255.0 green:135/255.0 blue:163/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:24/255.0 blue:78/255.0 alpha:1.0].CGColor] locations:@[@(0.0),@(1.0)] frame:strongSelf->_confirmBtn.layer.bounds];
                    [strongSelf->_confirmBtn.layer insertSublayer:btnLayer atIndex:0];
                    
                    strongSelf->_headerView.hidden = NO;
                    strongSelf->_confirmBtn.enabled = YES;
                    kSDLoadImg(strongSelf->_headerImgV, kMeUnNilStr(data[@"header_pic"]));
                    strongSelf->_nameLbl.text = kMeUnNilStr(data[@"name"]);
                    strongSelf->_confirmBtnConsTop.constant = 26+24;
                    [strongSelf->_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
                }else {
                    [MECommonTool showMessage:kMeUnNilStr(responseObject.message) view:kMeCurrentWindow];
                }
            }else {
                [strongSelf->_confirmBtn.layer.sublayers.firstObject removeFromSuperlayer];
                
                strongSelf->_lineView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
                strongSelf->_confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
                strongSelf->_headerView.hidden = YES;
                strongSelf->_confirmBtn.enabled = NO;
                strongSelf->_confirmBtnConsTop.constant = 26;
                [strongSelf->_confirmBtn setTitle:@"请输入正确的邀请码" forState:UIControlStateNormal];
            }
        } failure:^(id object) {
            
        }];
    }else {
        if (textField.text.length == 5) {
            if (_confirmBtn.layer.sublayers.count > 1) {
                [_confirmBtn.layer.sublayers.firstObject removeFromSuperlayer];
            }
        }
        
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        _headerView.hidden = YES;
        _confirmBtnConsTop.constant = 26;
        _confirmBtn.enabled = NO;
        _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        [_confirmBtn setTitle:@"请输入正确的邀请码" forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self invationCodeTFCodeTextDidChange:_invationCodeTF];
    return YES;
}

- (void)tapAction {
    [self.view endEditing:YES];
}

- (IBAction)codeAction:(id)sender {
    _invationCodeTF.text = @"000000";
    [self.view endEditing:YES];
    [self invationCodeTFCodeTextDidChange:_invationCodeTF];
}

- (IBAction)sureAction:(id)sender {
    if ([self.invationCodeTF.text length] <= 0) {
        [MEShowViewTool showMessage:@"请输入邀请码" view:kMeCurrentWindow];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetBindingParentWithInvitationCode:self.invationCodeTF.text successBlock:^(ZLRequestResponse *responseObject) {
        //绑定手机号成功 保存到本地
//        kMeSTRONGSELF
        [MECommonTool showMessage:kMeUnNilStr(responseObject.message) view:kMeCurrentWindow];
        [MECommonTool dismissViewControllerAnimated:YES completion:^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.blockSuccess,nil);
        }];
    } failure:^(id object) {

    }];
}
- (IBAction)backAction:(id)sender {
    kMeWEAKSELF
    [MECommonTool dismissViewControllerAnimated:YES completion:^{
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.blockFail,nil);
    }];
}

@end
