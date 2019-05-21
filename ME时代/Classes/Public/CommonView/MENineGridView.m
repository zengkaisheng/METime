//
//  MENineGridView.m
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MENineGridView.h"

const static CGFloat kMENineGridViewMagin = 10;
const static CGFloat kMENineGridViewpadding = 3;

@interface MENineGridView ()



@end

@implementation MENineGridView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setImageView];
    }
    return self;
}

- (void)setImageView{
    _arrImageView = [NSMutableArray array];
    for (NSInteger i=0; i<9; i++) {
        UIImageView *img = [[UIImageView alloc]init];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        img.userInteractionEnabled = YES;
        img.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [img addGestureRecognizer:tap];
        [_arrImageView addObject:img];
    }
}

- (void)setImageViewWithArr:(NSArray *)arr{
    for (UIImageView *img in self.subviews) {
         [img removeFromSuperview];
    }
    if(kMeUnArr(arr).count == 1){
        UIImageView *img = _arrImageView[0];
        CGFloat w = (SCREEN_WIDTH - (kMENineGridViewMagin*2) - kMENineGridViewpadding)/2;
        img.frame = CGRectMake(kMENineGridViewpadding, 0, w, w);
        kSDLoadImg(img, kMeUnNilStr(arr[0]));
        [self addSubview:img];
    } else if(kMeUnArr(arr).count == 2){
        UIImageView *img = _arrImageView[0];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        CGFloat w = (SCREEN_WIDTH - (kMENineGridViewMagin*2) - kMENineGridViewpadding)/2;
        img.frame = CGRectMake(kMENineGridViewpadding, 0, w, w);
        [self addSubview:img];
        kSDLoadImg(img, kMeUnNilStr(arr[0]));
        UIImageView *imgOne = _arrImageView[1];
        imgOne.frame = CGRectMake(kMENineGridViewpadding+w+kMENineGridViewpadding, 0, w, w);
        [self addSubview:imgOne];
        kSDLoadImg(imgOne, kMeUnNilStr(arr[1]));
    }else{
        CGFloat w = (SCREEN_WIDTH - (kMENineGridViewMagin*2) - (kMENineGridViewpadding*2))/3;
        for (NSInteger i = 0; i<arr.count; i++) {
            NSString *str = arr[i];
            UIImageView *img = _arrImageView[i];
            NSInteger row = i/3;//行
            NSInteger col = i%3;//列
            CGFloat picX = kMENineGridViewpadding + (w + kMENineGridViewpadding) * col;
            CGFloat picY = kMeUnArr(arr).count==3?0:kMENineGridViewpadding + (w + kMENineGridViewpadding) * row;
            img.frame = CGRectMake(picX, picY, w, w);
            [self addSubview:img];
            kSDLoadImg(img, kMeUnNilStr(str));
        }
    }
}

- (void)setImageDymamicViewWithArr:(NSArray *)arr{
    CGFloat allW = SCREEN_WIDTH - 10 -36-10-10;
    for (UIImageView *img in self.subviews) {
        [img removeFromSuperview];
    }
    if(kMeUnArr(arr).count == 1){
        UIImageView *img = _arrImageView[0];
        CGFloat w = (allW - (kMENineGridViewMagin*2) - kMENineGridViewpadding)/2;
        img.frame = CGRectMake(kMENineGridViewpadding, 0, w, w);
        kSDLoadImg(img, kMeUnNilStr(arr[0]));
        [self addSubview:img];
    } else if(kMeUnArr(arr).count == 2){
        UIImageView *img = _arrImageView[0];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        CGFloat w = (allW - (kMENineGridViewMagin*2) - kMENineGridViewpadding)/2;
        img.frame = CGRectMake(kMENineGridViewpadding, 0, w, w);
        [self addSubview:img];
        kSDLoadImg(img, kMeUnNilStr(arr[0]));
        UIImageView *imgOne = _arrImageView[1];
        imgOne.frame = CGRectMake(kMENineGridViewpadding+w+kMENineGridViewpadding, 0, w, w);
        [self addSubview:imgOne];
        kSDLoadImg(imgOne, kMeUnNilStr(arr[1]));
    }else{
        CGFloat w = (allW - (kMENineGridViewMagin*2) - (kMENineGridViewpadding*2))/3;
        for (NSInteger i = 0; i<arr.count; i++) {
            UIImageView *img = _arrImageView[i];
            NSInteger row = i/3;//行
            NSInteger col = i%3;//列
            CGFloat picX = kMENineGridViewpadding + (w + kMENineGridViewpadding) * col;
            CGFloat picY = kMeUnArr(arr).count==3?0:kMENineGridViewpadding + (w + kMENineGridViewpadding) * row;
            img.frame = CGRectMake(picX, picY, w, w);
            [self addSubview:img];
            NSString *str  = arr[i];
            kSDLoadImg(img, kMeUnNilStr(str));
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIImageView *view = (UIImageView *)tap.view;
    NSInteger index = view.tag;
    if(index>=0 && index<=8){
        kMeCallBlock(_selectBlock,index);
    }
}

+ (CGFloat)getViewHeightWIth:(NSArray *)arr{
    switch (kMeUnArr(arr).count) {
        case 0:
            return 0;
        case 1:case 2:
            return (SCREEN_WIDTH - (kMENineGridViewMagin*2) - kMENineGridViewpadding)/2;
        case 3:
            return (SCREEN_WIDTH - (kMENineGridViewMagin*2) - (kMENineGridViewpadding*2))/3;
        case 4:case 5:case 6:
            return (((SCREEN_WIDTH - (kMENineGridViewMagin*2) - (kMENineGridViewpadding*2))/3)*2)+(kMENineGridViewpadding*3);
        case 7:case 8:case 9:
            return (((SCREEN_WIDTH - (kMENineGridViewMagin*2) - (kMENineGridViewpadding*2))/3)*3)+(kMENineGridViewpadding*4);
        default:
            return 0;
    }
}


+ (CGFloat)getDymmaincViewHeightWIth:(NSArray *)arr{
    CGFloat allW = SCREEN_WIDTH - 10 -36-10-10;
    switch (kMeUnArr(arr).count) {
        case 0:
            return 0;
        case 1:case 2:
            return (allW - (kMENineGridViewMagin*2) - kMENineGridViewpadding)/2;
        case 3:
            return (allW - (kMENineGridViewMagin*2) - (kMENineGridViewpadding*2))/3;
        case 4:case 5:case 6:
            return (((allW - (kMENineGridViewMagin*2) - (kMENineGridViewpadding*2))/3)*2)+(kMENineGridViewpadding*3);
        case 7:case 8:case 9:
            return (((allW - (kMENineGridViewMagin*2) - (kMENineGridViewpadding*2))/3)*3)+(kMENineGridViewpadding*4);
        default:
            return 0;
    }
}


@end
