//
//  MEBynamicPublishGridView.m
//  ME时代
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBynamicPublishGridView.h"
#import "MEBynamicPublishGridModel.h"
#import "MEBynamicPublishGridContentView.h"


@interface MEBynamicPublishGridView (){
    NSArray *_arrModel;
    
}

@end

@implementation MEBynamicPublishGridView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setImageView];
    }
    return self;
}


- (void)setImageView{
    _arrImageView = [NSMutableArray array];
    for (NSInteger i=0; i<9; i++) {
        MEBynamicPublishGridContentView *img = [[MEBynamicPublishGridContentView alloc]init];
        img.userInteractionEnabled = YES;
        img.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [img addGestureRecognizer:tap];
        [_arrImageView addObject:img];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIImageView *view = (UIImageView *)tap.view;
    NSInteger index = view.tag;
    if(index>=0 && index<=8){
        MEBynamicPublishGridModel *model = _arrModel[index];
        model.selectIndex = index;
        kMeCallBlock(_selectBlock,model);
    }
}

- (void)setUIWithArr:(NSArray *)arr{
    for (UIImageView *img in self.subviews) {
        [img removeFromSuperview];
    }
    self.height = [MEBynamicPublishGridView getViewHeightWIth:arr];
    _arrModel = arr;
    CGFloat w = (SCREEN_WIDTH - (kMEBynamicPublishGridViewMagin *2) - (kMEBynamicPublishGridViewPadding *2))/3;
    kMeWEAKSELF
    for (NSInteger i = 0; i<arr.count; i++) {
        if(i>=9){
            break;
        }
        MEBynamicPublishGridModel *model = arr[i];
        MEBynamicPublishGridContentView *img = _arrImageView[i];
        img.block = ^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.delBlock,i);
        };
        [img setUIWithModel:model];
        NSInteger row = i/3;//行
        NSInteger col = i%3;//列
        CGFloat picX = ((w + kMEBynamicPublishGridViewPadding) * col)+kMEBynamicPublishGridViewMagin;
        CGFloat picY =((w + kMEBynamicPublishGridViewPadding) * row) +kMEBynamicPublishGridViewPadding;
        img.frame = CGRectMake(picX, picY, w, w);
        [self addSubview:img];
    }
}

+ (CGFloat)getViewHeightWIth:(NSArray *)arr{
    CGFloat height = 0;
    CGFloat cellheight = (SCREEN_WIDTH - (kMEBynamicPublishGridViewMagin *2) - (kMEBynamicPublishGridViewPadding *2))/3;
    switch (kMeUnArr(arr).count) {
        case 0:
            height = 0;
        case 1:case 2:case 3:{
            height +=(cellheight+(kMEBynamicPublishGridViewPadding *2));
        }
            break;
        case 4:case 5:case 6:{
            height +=((cellheight*2)+(kMEBynamicPublishGridViewPadding *3));
        }
            break;
        default:{
            height +=((cellheight*3)+(kMEBynamicPublishGridViewPadding *4));
        }
            break;
    }
    return height;
}

@end
