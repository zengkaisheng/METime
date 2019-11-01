//
//  MEPullDownListView.m
//  志愿星
//
//  Created by gao lei on 2019/10/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPullDownListView.h"

@interface MEPullDownListView ()

@property (nonatomic, strong) UIControl *background;
@property (nonatomic, strong) NSArray   *items;
@property (nonatomic, assign) BOOL      isMultiple;
@property (nonatomic, copy) TapIndexsBlock indexBlock;
@property (nonatomic) MEPulldownListViewType menuViewType;
@property (nonatomic, strong) NSMutableArray *tapIndexs;
@property (nonatomic, strong) NSMutableArray *selectButtons;
@property (nonatomic, strong) NSArray *selectItems;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MEPullDownListView

+ (instancetype)pulldownMenu {
    return [[[self class] alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)items originY:(CGFloat)originY
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        switch (self.menuViewType) {
            case MEPulldownListViewSudoku:
            {
                [self addItemsWithTitles:items];
            }
                break;
            case MEPulldownListViewRow:
            {
                CGRect frame = self.frame;
                if (items.count > 5) {
                    frame.size.height = 49*5;
                    self.frame = frame;
                }
                [self addRowsWithTitle:items];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

#pragma mark - UI
- (void)addItemsWithTitles:(NSArray *)titles {
    if(!titles.count) return;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat rPadding = 16; //左右边距
    CGFloat tPadding = 10; //上边距
    CGFloat spaceH = 10;   //水平间距
    CGFloat spaceV = 10;   //垂直间距
    
    NSInteger rowNum = 3;
    CGFloat button_W = (screenWidth - (rPadding*2 + spaceH * (rowNum-1)))/rowNum;
    CGFloat button_H = 33;
    CGFloat button_origin_Y = tPadding;
    NSInteger count = titles.count;
    
    for(int i = 0; i < count; i++) {
        
        UIButton *selectButton = [[UIButton alloc]
                                  initWithFrame:CGRectMake(rPadding + button_W*(i%rowNum) + spaceH*(i%rowNum),
                                                           button_origin_Y + i/rowNum*(button_H + spaceV),
                                                           button_W,
                                                           button_H)];
        [selectButton setTitle:titles[i] forState:UIControlStateNormal];
        [selectButton setTag:1000+i];
        selectButton.layer.cornerRadius = 33/2.0;;
        [selectButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if([self.selectItems containsObject:titles[i]]) {
            
            selectButton.selected = YES;
            [self.selectButtons addObject:selectButton];
            [selectButton setBackgroundColor:[UIColor colorWithHexString:@"#2ED9A4"]];
            [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else{
            
            selectButton.selected = NO;
            [self.selectButtons removeObject:selectButton];
            
            [selectButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            selectButton.layer.borderColor = [UIColor colorWithHexString:@"#F5F5F5"].CGColor;
            [selectButton setBackgroundColor:[UIColor whiteColor]];
            selectButton.layer.borderWidth = 1.0f;
        }
        
        [selectButton addTarget:self action:@selector(selectButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectButton];
    }
    
    if(self.isMultiple){
        
        UIButton *confirmBtn = [[UIButton alloc]
                                initWithFrame:CGRectMake(16,CGRectGetHeight(self.bounds)-16-44,
                                                         CGRectGetWidth(self.bounds)-32, 44)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.layer.cornerRadius = 20;;
        [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#2ED9A4"]];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
    }
    
}

- (void)addRowsWithTitle:(NSArray *)titles {
    //
    if(!titles.count) return;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //    CGFloat tPadding = 10; //上边距
    CGFloat button_H = 49;
    CGFloat rPadding = 16; //左右边距
    
    CGRect frame = self.frame;
    self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.scrollView.contentSize = CGSizeMake(frame.size.width, 49*titles.count);
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < titles.count; i++){
        CGFloat titleW = [titles[i] boundingRectWithSize:CGSizeMake(screenWidth - 26, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
        UIButton *selectButton = [[UIButton alloc]
                                  initWithFrame:CGRectMake(0, /*tPadding + */button_H*i, Screen_Width, button_H)];
        [selectButton setTitle:titles[i] forState:UIControlStateNormal];
        [selectButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        NSInteger tag = 1000 + i;
        [selectButton setTag:tag];
        selectButton.layer.borderColor = [UIColor colorWithHexString:@"#F5F5F5"].CGColor;
        [selectButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor colorWithHexString:@"#2ED9A4"] forState:UIControlStateSelected];
        //文字左偏移
        selectButton.titleEdgeInsets = UIEdgeInsetsMake(0, -((Screen_Width - titleW)/2 - 13), 0, ((Screen_Width - titleW)/2 - 13));
        [selectButton addTarget:self action:@selector(selectButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:selectButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(rPadding, selectButton.frame.origin.y + selectButton.frame.size.height - 1, Screen_Width-16, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [self.scrollView addSubview:line];
    }
}

- (void)showWithItems:(NSArray *)items
           isMultiple:(BOOL)isMutiple
              originY:(CGFloat)originY
 pulldownMenuViewType:(MEPulldownListViewType)type
        tapIndexBlock:(void (^)(NSArray *indexs))tapIndexBlock;{
    
    self.indexBlock = tapIndexBlock;
    self.menuViewType = type;
    self.isMultiple = isMutiple;
    self.items = [items copy];
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //height
    CGFloat downMenuH = 0;
    CGFloat topPadding = 16; //上边距
    CGFloat bottomPadding = 16; //下边距
    
    if(self.menuViewType == MEPulldownListViewSudoku){
        
        NSInteger rowNum = 3;
        
        CGFloat button_H = 33; //按钮高度
        CGFloat spaceV = 10;   //垂直间距
        NSInteger rows = (items.count % rowNum != 0) ? (items.count/3 + 1) : items.count/3;
        downMenuH = topPadding + rows * button_H + (rows-1)*spaceV + bottomPadding;
    }else{
        
        //类似Cell
        CGFloat button_H = 49; //按钮高度
        downMenuH = items.count * button_H;// + topPadding
    }
    //Confirm Button
    if(isMutiple){
        downMenuH += 64;
    }
    
    CGRect downMenuFrame = CGRectMake(0, originY, ScreenWidth, downMenuH);
    MEPullDownListView *downMenu = [self initWithFrame:downMenuFrame withItems:items originY:originY];
    _background = [[UIControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height + self.frame.origin.y,
                                                              ScreenWidth, ScreenHeight - self.frame.size.height + self.frame.origin.y)];
    _background.backgroundColor = [UIColor blackColor];
    _background.alpha = 0.6;
    [_background addSubview:downMenu];
    [_background addTarget:self action:@selector(tapAction)
          forControlEvents:UIControlEventTouchUpInside];
    
    self.isVisible = YES;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_background];
    [[[UIApplication sharedApplication] keyWindow] addSubview:downMenu];
    
    //animation
    self.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1.0f;
    }];
    
}

#pragma mark - Action
- (void)selectButtonPressed:(UIButton *)sender {
    
    NSString *tagStr = [NSString stringWithFormat:@"%ld", sender.tag - 1000];
    sender.selected = !sender.selected;
    if(![self.selectButtons containsObject:sender]){
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithHexString:@"#2ED9A4"]];
        [self.selectButtons addObject:sender];
        
    }else{
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [self.selectButtons removeObject:sender];
    }
    
    if(!self.isMultiple){
        if(self.indexBlock){
            self.indexBlock(@[tagStr]);
        }
        [self dismiss];
    }
}
- (void)confirmBtnPressed:(UIButton *)sender {
    
    [self.selectButtons enumerateObjectsUsingBlock:^(UIButton  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *tagStr = [NSString stringWithFormat:@"%ld", obj.tag - 1000];
        
        [self.tapIndexs addObject:tagStr];
    }];
    
    if(self.indexBlock){
        self.indexBlock(self.tapIndexs);
    }
    [self dismiss];
}

- (void)tapAction {
    if(self.indexBlock){
        self.indexBlock(@[]);
    }
    [self dismiss];
}

- (void)dismiss {
    self.isVisible = NO;
    [self.scrollView removeFromSuperview];
    [self removeFromSuperview];
    [_background removeFromSuperview];
    _background = nil;
}

- (NSMutableArray *)tapIndexs {
    if(!_tapIndexs){
        _tapIndexs = [[NSMutableArray alloc] init];
    }
    return _tapIndexs;
}

- (NSMutableArray *)selectButtons {
    
    if(!_selectButtons){
        _selectButtons = [[NSMutableArray alloc] init];
    }
    return _selectButtons;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

@end
