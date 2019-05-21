//
//  MECustomActionSheet.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MECustomActionSheet.h"
#import "MEModelView.h"

@interface MECustomActionSheet (){
    NSArray *_arrTitles;
    NSString *_title;
    UILabel *_lblTitle;
    UIView *_actionView;
}

@end

@implementation MECustomActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitles:(NSArray *)arrTitles{
    return [self initWithTitle:nil btnTitles:arrTitles];
}

-(id)initWithTitle:(NSString *)title btnTitles:(NSArray *)arrTitles{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, kMeApplicationHeight)];
    if (self) {
        // Initialization code
        _arrTitles = arrTitles;
        _title = title;
        [self initialize];
        [self loadContent];
        
    }
    return self;
}

-(void)initialize{
    _margin_top = 0;
    _margin_bottom = 0;
    _margin_cancelBtn = 10;
    _margin_x = 0;
    _margin_betweenBtns = 0;
    _btnSize = CGSizeMake(SCREEN_WIDTH-_margin_x*2, 48);
}

-(void)loadContent{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    __block CGFloat y = _margin_top;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForBGView:)];
    [self addGestureRecognizer:tap];
    
    _actionView = [[UIView alloc] init];
    _actionView.backgroundColor = [UIColor colorWithHexString:@"#d6d6e0"];
    _actionView.userInteractionEnabled = YES;
    [self addSubview:_actionView];
    
    if ([_title isKindOfClass:[NSString class]]) {
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, y, _btnSize.width, _btnSize.height)];
        if([_title isEqualToString:@"删除"]){
            _lblTitle.textColor = [UIColor redColor];
        }else{
            _lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        }
        _lblTitle.font = [UIFont systemFontOfSize:14];
        _lblTitle.contentMode = NSTextAlignmentCenter;
        _lblTitle.text = _title;
        _lblTitle.backgroundColor = [UIColor whiteColor];
        [_actionView addSubview:_lblTitle];
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(_lblTitle.left, _lblTitle.bottom - 0.5, _lblTitle.width, 0.5)];
        viewLine.backgroundColor = [UIColor colorWithHexString:@"#c1c1c1"];
        [_actionView addSubview:viewLine];
        
        y += _btnSize.height;
    }
    
    [_arrTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = (CGRect){_margin_x,y,_btnSize};
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        if([obj isEqualToString:@"删除"]){
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        }
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:btn.size] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#eeeeee"] size:btn.size] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#eeeeee"] size:btn.size] forState:UIControlStateHighlighted];
        [_actionView addSubview:btn];
        
        if (idx < _arrTitles.count - 1) {
            UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(btn.left, btn.bottom - 0.5, btn.width, 0.5)];
            viewLine.backgroundColor = [UIColor colorWithHexString:@"#c1c1c1"];
            [_actionView addSubview:viewLine];
        }
        y += (_btnSize.height+_margin_betweenBtns);
        
    }];
    
    y -= _margin_betweenBtns;
    y += _margin_cancelBtn;
    

    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = (CGRect){_margin_x,y,_btnSize};
    [btnCancel setTitle:@"取消"  forState:UIControlStateNormal];
    btnCancel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnCancel addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [btnCancel setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:btnCancel.size] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#eeeeee"] size:btnCancel.size] forState:UIControlStateSelected];
    [btnCancel setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#eeeeee"] size:btnCancel.size] forState:UIControlStateHighlighted];
    [_actionView addSubview:btnCancel];
    
    y += _margin_bottom+_btnSize.height;
    _actionView.frame = CGRectMake(0, kMeApplicationHeight-y, SCREEN_WIDTH, y);
    
}


-(void)btnAction:(UIButton *)aBtn{
    if (_blockBtnTapHandle) {
        _blockBtnTapHandle(aBtn.tag);
    }
    [self btnCancelAction:nil];
}

-(void)btnCancelAction:(UIButton *)sender{
    [MEModelView closeModelViewWithContentView:self];
}

-(void)tapActionForBGView:(UITapGestureRecognizer *)sender{
    [self btnCancelAction:nil];
}

-(void)show{
    self.top = kMeApplicationHeight;
    [MEModelView showInView:kMeCurrentWindow contentVIew:self editBgViewHandle:^(MEModelBackGroudView *viewBg) {
        viewBg.blockCloseAnimate = ^{
            self.top = kMeApplicationHeight;
        };
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottom = kMeApplicationHeight;
    }];
    
}


@end
