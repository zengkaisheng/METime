//
//  MEFindView.m
//  ME时代
//
//  Created by hank on 2019/5/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEFindView.h"

@interface MEFindView ()

@property (weak, nonatomic) IBOutlet UIView *viewPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblV;
@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@end

@implementation MEFindView

- (void)awakeFromNib{
    [super awakeFromNib];
}


- (IBAction)upAction:(UIButton *)sender {
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",kMEAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

+ (MEFindView *)getViewWithV:(NSString *)v content:(NSString*)content isShowCancel:(BOOL)isShowCancel{
    MEFindView *view = [[[NSBundle mainBundle]loadNibNamed:@"MEFindView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [view setUIWithV:v content:content isShowCancel:isShowCancel];
    return view;
}

- (void)setUIWithV:(NSString *)v content:(NSString*)content isShowCancel:(BOOL)isShowCancel{
    _lblV.text = [NSString stringWithFormat:@"v%@",kMeUnNilStr(v)];
    _tvContent.text = kMeUnNilStr(content);
    _btnCancel.hidden = !isShowCancel;
}

- (void)show{
    [kMeCurrentWindow addSubview:self];
    _viewPhone.alpha = 0.5;
    kMeWEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        kMeSTRONGSELF
        strongSelf->_viewPhone.alpha = 1;
    }];
}

- (void)hide{
    [self removeFromSuperview];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self hide];
}



@end
