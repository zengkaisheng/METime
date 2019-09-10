//
//  MECustomInputView.m
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomInputView.h"
#import "METextView.h"

#define BGViewWidth (270*(kMeFrameScaleY()>1?kMeFrameScaleY():1))
#define BGViewHeight (210*(kMeFrameScaleY()>1?kMeFrameScaleY():1))

@interface MECustomInputView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) METextView *tv;
@property (nonatomic, strong) UIButton *chooseBtn;
//@property (nonatomic, copy) kMeTextBlock saveBlock;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;
@property (nonatomic, copy) kMeCustomerBlock saveBlock;

@end


@implementation MECustomInputView

- (void)dealloc{
    NSLog(@"MECustomInputView dealloc");
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        [self setUIWithTitle:title content:content];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title content:(NSString *)content{
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(28, 14, BGViewWidth-56, 21)];
    titleLbl.text = title.length>0?title:@"编辑内容";
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont systemFontOfSize:15];
    [self.bgView addSubview:titleLbl];
    
    METextView *tv = [[METextView alloc] initWithFrame:CGRectMake(28, 45, BGViewWidth-56, BGViewHeight-45-50)];
    tv.textView.font = [UIFont systemFontOfSize:15];
    tv.textView.textColor = [UIColor blackColor];
    __block METextView *textView = tv;
    tv.contenBlock = ^(NSString *str) {
        int maxCount = 20;
        if ([title isEqualToString:@"添加顾客分类"]) {
            maxCount = 15;
        }else if ([title isEqualToString:@"添加生活习惯"]) {
            maxCount = 15;
        }
        if (str.length > maxCount) {
            str = [str substringWithRange:NSMakeRange(0, maxCount)];
            textView.textView.text = str;
            [textView endEditing:YES];
        }
    };
    
    if (content.length > 0) {
        tv.placeholderTextView.hidden = YES;
        tv.textView.text = content;
        tv.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];;
    }else {
        tv.placeholderTextView.hidden = NO;
        tv.placeholderTextView.text = @"请输入...";
    }
    tv.placeholderTextView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.tv = tv;
    [self.bgView addSubview:tv];
    
    self.chooseBtn.frame = CGRectMake(10, CGRectGetMaxY(tv.frame) + 6, 60, 40);
    [self.chooseBtn setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:2];
    [self.bgView addSubview:self.chooseBtn];
    
    UIButton *saveBtn = [self createButtonWithTitle:@"保存"];
    saveBtn.frame = CGRectMake((BGViewWidth-120)/2, CGRectGetMaxY(tv.frame) + 9, 120, 32);
    [self.bgView addSubview:saveBtn];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (void)btnDidClick:(UIButton *)sender {
    if (self.tv.textView.text.length <= 0) {
        [MECommonTool showMessage:@"内容不能为空" view:kMeCurrentWindow];
        return;
    }
    kMeCallBlock(_saveBlock,self.tv.textView.text,self.chooseBtn.selected);
    [self hide];
}

- (void)chooseBtnDidClick:(UIButton *)sender {
    self.chooseBtn.selected = !self.chooseBtn.selected;
}

- (UIButton *)createButtonWithTitle:(NSString *)title  {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setBackgroundColor:kMEPink];
        btn.layer.cornerRadius = 16;
    }
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Settet And Getter
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.8;
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesmask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTap:)];
        [_maskView addGestureRecognizer:gesmask];
    }
    return _maskView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-BGViewWidth)/2, (SCREEN_HEIGHT-BGViewHeight)/2, BGViewWidth, BGViewHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
    }
    return _bgView;
}

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setTitle:@"是否多选" forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:[UIColor colorWithHexString:@"#393939"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"icon_delCollection_nor"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"icon_delCollection_sel"] forState:UIControlStateSelected];
        _chooseBtn.selected = YES;
        [_chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_chooseBtn addTarget:self action:@selector(chooseBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}

#pragma mark - Public API
+ (void)showCustomInputViewWithTitle:(NSString *)title content:(NSString *)content showChooseBtn:(BOOL)isShow isInput:(BOOL)isInput saveBlock:(kMeCustomerBlock)saveBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView {
    MECustomInputView *view = [[MECustomInputView alloc]initWithTitle:title content:content superView:superView];
    view.saveBlock = saveBlock;
    view.chooseBtn.hidden = !isShow;
    if (isShow) {
        if (isInput) {
            [view.chooseBtn setTitle:@"是否输入" forState:UIControlStateNormal];
            view.chooseBtn.selected = NO;
        }else {
            [view.chooseBtn setTitle:@"是否多选" forState:UIControlStateNormal];
            view.chooseBtn.selected = YES;
        }
    }
    
    view.cancelBlock = cancelBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
