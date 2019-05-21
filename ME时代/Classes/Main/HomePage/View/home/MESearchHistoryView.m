//
//  MESearchHistoryView.m
//  ME时代
//
//  Created by hank on 2018/10/31.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESearchHistoryView.h"
#import "MESearchHistoryModel.h"

const static CGFloat kMESearchHistoryViewMagin = 7;
const static CGFloat kMESearchHistoryViewTitleHeight = 22;
const static CGFloat kMESearchHistoryViewSelectHeight = 30;

const static CGFloat KTapTag = 1000;

@interface MESearchHistoryView(){
    NSMutableArray *_arrBtn;
}

@property (nonatomic, strong) UILabel *lblTite;
@property (nonatomic, strong) UIImageView *imgDel;
@property (nonatomic, strong) UIButton *btnDel;

@end

@implementation MESearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _arrBtn = [NSMutableArray array];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lblTite];
    [self addSubview:self.imgDel];
    [self addSubview:self.btnDel];
}
- (void)reloaStoredData{
    [_arrBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_arrBtn removeAllObjects];
    NSArray *arrHistory = [MESearchHistoryModel arrSearchStoreHistory];
    CGFloat allHeight = (kMESearchHistoryViewMagin *2) +kMESearchHistoryViewTitleHeight;
    for (int i = 0; i < arrHistory.count; i ++){
        NSString *name = arrHistory[i];
        static UIButton *recordBtn =nil;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width -(kMESearchHistoryViewMagin * 2), kMESearchHistoryViewSelectHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        CGFloat BtnW = rect.size.width>80?(rect.size.width+30):80;
        BtnW = BtnW>(SCREEN_WIDTH - (kMESearchHistoryViewMagin *2))?(SCREEN_WIDTH - (kMESearchHistoryViewMagin *2)):BtnW;
        CGFloat BtnH = kMESearchHistoryViewSelectHeight;
        if (i == 0){
            btn.frame =CGRectMake(kMESearchHistoryViewMagin, allHeight, BtnW, BtnH);
        }else{
            //算出剩下的宽度
            CGFloat yuWidth = self.frame.size.width - (kMESearchHistoryViewMagin*2) -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= BtnW) {
                //如果大于就放在同一行
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + kMESearchHistoryViewMagin, recordBtn.frame.origin.y, BtnW, BtnH);
            }else{
                //如果不够就换行
                btn.frame =CGRectMake(kMESearchHistoryViewMagin, recordBtn.frame.origin.y+recordBtn.frame.size.height+kMESearchHistoryViewMagin, BtnW, BtnH);
            }
        }
        btn.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:kMEblack forState:UIControlStateNormal];
        [self addSubview:btn];
        [_arrBtn addObject:btn];
        NSLog(@"btn.frame.origin.y  %f", btn.frame.origin.y);
        self.frame = CGRectMake(self.x , self.y, [UIScreen mainScreen].bounds.size.width ,CGRectGetMaxY(btn.frame)+kMESearchHistoryViewMagin);
        recordBtn = btn;
        btn.tag = KTapTag + i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)reloadData{
    [_arrBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_arrBtn removeAllObjects];
    NSArray *arrHistory = [MESearchHistoryModel arrSearchHistory];
    CGFloat allHeight = (kMESearchHistoryViewMagin *2) +kMESearchHistoryViewTitleHeight;
    for (int i = 0; i < arrHistory.count; i ++){
        NSString *name = arrHistory[i];
        static UIButton *recordBtn =nil;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width -(kMESearchHistoryViewMagin * 2), kMESearchHistoryViewSelectHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        CGFloat BtnW = rect.size.width>80?(rect.size.width+30):80;
        BtnW = BtnW>(SCREEN_WIDTH - (kMESearchHistoryViewMagin *2))?(SCREEN_WIDTH - (kMESearchHistoryViewMagin *2)):BtnW;
        CGFloat BtnH = kMESearchHistoryViewSelectHeight;
        if (i == 0){
            btn.frame =CGRectMake(kMESearchHistoryViewMagin, allHeight, BtnW, BtnH);
        }else{
            //算出剩下的宽度
            CGFloat yuWidth = self.frame.size.width - (kMESearchHistoryViewMagin*2) -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= BtnW) {
                //如果大于就放在同一行
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + kMESearchHistoryViewMagin, recordBtn.frame.origin.y, BtnW, BtnH);
            }else{
                //如果不够就换行
                btn.frame =CGRectMake(kMESearchHistoryViewMagin, recordBtn.frame.origin.y+recordBtn.frame.size.height+kMESearchHistoryViewMagin, BtnW, BtnH);
            }
        }
        btn.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:kMEblack forState:UIControlStateNormal];
        [self addSubview:btn];
        [_arrBtn addObject:btn];
        NSLog(@"btn.frame.origin.y  %f", btn.frame.origin.y);
        self.frame = CGRectMake(self.x , self.y, [UIScreen mainScreen].bounds.size.width ,CGRectGetMaxY(btn.frame)+kMESearchHistoryViewMagin);
        recordBtn = btn;
        btn.tag = KTapTag + i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)BtnClick:(UIButton *)sender{
    kMeCallBlock(self.selectBlock,sender.titleLabel.text);
}

- (void)handleTapAction:(UITapGestureRecognizer *)tap{
    if(![tap.view isKindOfClass:[UILabel class]]){
        return;
    }
    UILabel *lblSelect = (UILabel *)tap.view;
    kMeCallBlock(self.selectBlock,lblSelect.text);
}

- (void)delAction:(UIButton *)btn{
    MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除历史记录?"];
    kMeWEAKSELF
    [aler addButtonWithTitle:@"确定" block:^{
        kMeSTRONGSELF
        kMeCallBlock(strongSelf->_delBlock);
    }];
    [aler addButtonWithTitle:@"取消"];
    [aler show];
}

- (UILabel *)lblTite{
    if(!_lblTite){
        _lblTite = [MEView lblWithFram:CGRectMake(kMESearchHistoryViewMagin, kMESearchHistoryViewMagin, 58, kMESearchHistoryViewTitleHeight) textColor:kMEblack str:@"最近搜索" font:[UIFont systemFontOfSize:14]];
    }
    return _lblTite;
}

- (UIImageView *)imgDel{
    if(!_imgDel){
        _imgDel = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 10, 15, 16)];
        _imgDel.image = kMeGetAssetImage(@"icon-mmbw");
    }
    return _imgDel;
}

- (UIButton *)btnDel{
    if(!_btnDel){
        _btnDel = [MEView btnWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 30) Img:nil title:@""];
        [_btnDel addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDel;
}

+ (BOOL)hasHStoreIstory{
    NSArray *arrHistory = [MESearchHistoryModel arrSearchStoreHistory];
    return [arrHistory count];
}

+ (CGFloat)getStoreViewHeight{
    NSArray *arrHistory = [MESearchHistoryModel arrSearchStoreHistory];
    CGFloat allHeight = (kMESearchHistoryViewMagin *2) +kMESearchHistoryViewTitleHeight;
    
    for (int i = 0; i < arrHistory.count; i ++){
        NSString *name = arrHistory[i];
        static UIButton *recordBtn =nil;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -(kMESearchHistoryViewMagin * 2), kMESearchHistoryViewSelectHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        CGFloat BtnW = rect.size.width>80?(rect.size.width+30):80;
        BtnW = BtnW>(SCREEN_WIDTH - (kMESearchHistoryViewMagin *2))?(SCREEN_WIDTH - (kMESearchHistoryViewMagin *2)):BtnW;
        CGFloat BtnH = kMESearchHistoryViewSelectHeight;//rect.size.height + 10;
        if (i == 0){
            btn.frame =CGRectMake(kMESearchHistoryViewMagin, allHeight, BtnW, BtnH);
        }else{
            CGFloat yuWidth = SCREEN_WIDTH - (kMESearchHistoryViewMagin*2) -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= BtnW) {
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + kMESearchHistoryViewMagin, recordBtn.frame.origin.y, BtnW, BtnH);
            }else{
                btn.frame =CGRectMake(kMESearchHistoryViewMagin, recordBtn.frame.origin.y+recordBtn.frame.size.height+kMESearchHistoryViewMagin, BtnW, BtnH);
            }
            
        }
        allHeight = CGRectGetMaxY(btn.frame)+kMESearchHistoryViewMagin;
        recordBtn = btn;
    }
    return allHeight;
}

+ (BOOL)hasHIstory{
    NSArray *arrHistory = [MESearchHistoryModel arrSearchHistory];
    return [arrHistory count];
}

+ (CGFloat)getViewHeight{
    NSArray *arrHistory = [MESearchHistoryModel arrSearchHistory];
    CGFloat allHeight = (kMESearchHistoryViewMagin *2) +kMESearchHistoryViewTitleHeight;
    
    for (int i = 0; i < arrHistory.count; i ++){
        NSString *name = arrHistory[i];
        static UIButton *recordBtn =nil;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -(kMESearchHistoryViewMagin * 2), kMESearchHistoryViewSelectHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        CGFloat BtnW = rect.size.width>80?(rect.size.width+30):80;
        BtnW = BtnW>(SCREEN_WIDTH - (kMESearchHistoryViewMagin *2))?(SCREEN_WIDTH - (kMESearchHistoryViewMagin *2)):BtnW;
        CGFloat BtnH = kMESearchHistoryViewSelectHeight;//rect.size.height + 10;
        if (i == 0){
            btn.frame =CGRectMake(kMESearchHistoryViewMagin, allHeight, BtnW, BtnH);
        }else{
            CGFloat yuWidth = SCREEN_WIDTH - (kMESearchHistoryViewMagin*2) -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= BtnW) {
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + kMESearchHistoryViewMagin, recordBtn.frame.origin.y, BtnW, BtnH);
            }else{
                btn.frame =CGRectMake(kMESearchHistoryViewMagin, recordBtn.frame.origin.y+recordBtn.frame.size.height+kMESearchHistoryViewMagin, BtnW, BtnH);
            }
            
        }
        allHeight = CGRectGetMaxY(btn.frame)+kMESearchHistoryViewMagin;
        recordBtn = btn;
    }
    return allHeight;
}

@end
