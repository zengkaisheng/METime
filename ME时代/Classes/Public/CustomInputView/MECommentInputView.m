//
//  MECommentInputView.m
//  ME时代
//
//  Created by gao lei on 2019/11/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommentInputView.h"

@interface MECommentInputView ()

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation MECommentInputView

- (void)dealloc{
    NSLog(@"MECommentInputView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.textView];
    kMeWEAKSELF
    self.textView.cancelBlock = ^{
        kMeSTRONGSELF
        strongSelf.textView.textView.text = @"";
        strongSelf.textView.textView.backgroundColor = [UIColor clearColor];
        strongSelf.textView.placeholderTextView.hidden = NO;
        kMeCallBlock(strongSelf.cancelBlock);
//        NSLog(@"结束编辑");
    };
    self.textView.doneBlock = ^(NSString *str) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.contentBlock,str);
        strongSelf.textView.textView.text = @"";
        strongSelf.textView.textView.backgroundColor = [UIColor clearColor];
        strongSelf.textView.placeholderTextView.hidden = NO;
    };
    [self addSubview:self.sendBtn];
}

- (void)senderBtnClick {
//    NSLog(@"点击了发送按钮");
    [self.textView.textView resignFirstResponder];
    kMeCallBlock(self.contentBlock,[self.textView.textView.text trimSpace]);
    self.textView.textView.text = @"";
    self.textView.textView.backgroundColor = [UIColor clearColor];
    self.textView.placeholderTextView.hidden = NO;
}

#pragma mark -- setter&&getter
- (METextView *)textView {
    if (!_textView) {
        _textView = [[METextView alloc]initWithFrame:CGRectMake(24, 2, SCREEN_WIDTH-24-70, 34)];
        _textView.placeholderTextView.text = @"输入你的评论";
        _textView.textView.font = kMeFont(13);
        _textView.textView.textColor = kMEblack;
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _textView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(CGRectGetMaxX(_textView.frame)+7, 1, 56, 34);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor whiteColor]];
        [_sendBtn setTitleColor:kMEPink forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(senderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
