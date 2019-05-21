//
//  METextView.m
//  ME时代
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METextView.h"

@interface METextView ()<UITextViewDelegate,UITextFieldDelegate>



@end

@implementation METextView

#pragma mark - --- init 视图初始化 ---

+ (instancetype )placeholderTextView{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.placeholderTextView];
    [self addSubview:self.textView];
}
#pragma mark - --- delegate 视图委托 ---

/**
 * 这个方法专门用来布局子控件，一般在这里设置子控件的frame
 * 当控件本身的尺寸发生改变的时候，系统会自动调用这个方法
 *
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat textViewW = self.frame.size.width;
    CGFloat textViewH = self.frame.size.height;
    self.textView.frame = CGRectMake(0, 0, textViewW, textViewH );
    self.placeholderTextView.frame  = CGRectMake(0, 0, textViewW, textViewH );
    
}
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length == 0 && range.location == 0) {
        self.placeholderTextView.hidden = NO;
    }else{
        self.placeholderTextView.hidden =YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

/*由于联想输入的时候，函数textView:shouldChangeTextInRange:replacementText:无法判断字数，
 因此使用textViewDidChange对TextView里面的字数进行判断
 */
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholderTextView.hidden = NO;
    }else{
        self.placeholderTextView.hidden =YES;
    }
    kMeCallBlock(self.contenBlock,[textView.text trimSpace]);
//    //该判断用于联想输入
//    if (textView.text.length > MAX_WORD_LIMIT)
//    {
//        textView.text = [textView.text substringToIndex:MAX_WORD_LIMIT];
//    }
}


#pragma mark - --- event response 事件相应 ---

#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 —--
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor clearColor];
//        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _textView.layer.borderWidth = 0.5;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.delegate = self;
    }
    
    return _textView;
}
- (UITextView *)placeholderTextView{
    if (!_placeholderTextView) {
        _placeholderTextView = [[UITextView alloc]init];
        _placeholderTextView.font = kMeFont(17);
        _placeholderTextView.textColor = kME999999;
    }
    return _placeholderTextView;
}

@end
