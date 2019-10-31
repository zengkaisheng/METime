//
//  MEMenuHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/10/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMenuHeaderView.h"
#import "UIButton+ImageTitleSpacing.h"

@interface MEMenuHeaderView ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) TapIndexBlock indexBlock;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic) MEMenuHeaderViewType headerType;

@end

@implementation MEMenuHeaderView

- (instancetype)initWithTitle:(NSArray *)titles
                        frame:(CGRect)frame
                         type:(MEMenuHeaderViewType)headerType
                tapIndexBlock:(void (^)(NSInteger index))tapIndexBlock {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.headerType = headerType;
        _titles = titles;
        _indexBlock = tapIndexBlock;
        [self addItems];
    }
    return self;
}

- (void)addItems {
    
    CGFloat Width = self.bounds.size.width;
    CGFloat Height = self.bounds.size.height;
    
    CGFloat otherButtonW = 52;
    if(self.headerType == MEMenuHeaderViewSimple){
        otherButtonW = 0;
    }
    
    NSUInteger titleCount = _titles.count;
    CGFloat buttonW = (Width - otherButtonW)/titleCount;
    CGFloat buttonH = Height;
    UIImage *downImg = [UIImage imageNamed:@"icon_downArrow"];
    UIImage *upImg = [UIImage imageNamed:@"icon_upArrow"];
    UIImage *mapImg = [UIImage imageNamed:@"icon_filter"];
    UIImage *selectImg = [UIImage imageNamed:@"icon_filter_pre"];
    for(int i = 0; i < titleCount; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW*i, 0, buttonW, buttonH)];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = 999+i;
        [button setImage:downImg forState:UIControlStateNormal];
        [button setImage:upImg forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#2ED9A4"] forState:UIControlStateSelected];
        [button.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [self addSubview:button];
        if (i != titleCount-1) {
            UIView *line = [self createLineViewWithFrame:CGRectMake(buttonW-0.5+buttonW*i, 10, 1, Height-20)];
            [self addSubview:line];
        }
        [self.buttons addObject:button];
    }
    
    if(self.headerType != MEMenuHeaderViewSimple){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(Width-otherButtonW-1, 12, 1, buttonH-24)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        [self addSubview:line];
        
        UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(Width-otherButtonW, 0, otherButtonW, buttonH)];
        [otherButton setImage:mapImg forState:UIControlStateNormal];
        [otherButton setImage:selectImg forState:UIControlStateSelected];
        [otherButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        otherButton.tag = 999 + titleCount;
        [otherButton addTarget:self
                        action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:otherButton];
        [self.buttons addObject:otherButton];
    }
}

- (UIView *)createLineViewWithFrame:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithHexString:@"#707070"];
    return line;
}

- (void)selectAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    _indexBlock(sender.tag - 999);
    [_buttons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        //取消其它按钮的选中状态
        if(btn.tag != sender.tag){
            btn.selected = NO;
        }
    }];
}

- (void)reset {
    if (self.resetTitles.count > 0) {
        for (int i = 0; i < self.resetTitles.count; i++) {
            UIButton *btn = self.buttons[i];
            [btn setTitle:self.resetTitles[i] forState:UIControlStateNormal];
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        }
    }
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelected:NO];
    }];
}

- (NSMutableArray *)buttons {
    if(!_buttons){
        _buttons = [NSMutableArray arrayWithCapacity:_titles.count + 1];
    }
    return _buttons;
}

@end
