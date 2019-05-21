//
//  MEDynamicGoodApplyNineGridCell.m
//  SunSum
//
//  Created by hank on 2019/3/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEDynamicGoodApplyNineGridCell.h"
#import "MEBynamicPublishGridContentView.h"
#import "MEBynamicPublishGridModel.h"

@interface MEDynamicGoodApplyNineGridCell (){
    BOOL _isShow;
}

@property (nonatomic, strong) NSMutableArray *arrImageModel;

@end

@implementation MEDynamicGoodApplyNineGridCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
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
        if(_isShow){
//            NMEtring *model = _arrImageModel[index];
            kMeCallBlock(_selectIndexBlock,index);
        }else{
            MEBynamicPublishGridModel *model = _arrImageModel[index];
            model.selectIndex = index;
            kMeCallBlock(_selectBlock,model);
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithUrlArr:(NSMutableArray *)arrModel{
    _arrImageModel = arrModel;
    _isShow = YES;
    CGFloat w = (SCREEN_WIDTH - (kMEGridViewMagin *2) - (kMEGridViewPadding *2))/3;
    for (NSInteger i = 0; i<arrModel.count; i++) {
        if(i>=9){
            break;
        }
        NSString *model = arrModel[i];
        MEBynamicPublishGridContentView *img = _arrImageView[i];
        [img setUIWIthUrl:model];
        NSInteger row = i/3;//行
        NSInteger col = i%3;//列
        CGFloat picX = ((w + kMEGridViewPadding) * col)+kMEGridViewMagin;
        CGFloat picY =((w + kMEGridViewPadding) * row) +kMEGridViewPadding +48;
        img.frame = CGRectMake(picX, picY, w, w);
        [self addSubview:img];
    }
}

- (void)setUIWithArr:(NSMutableArray *)arrModel{
    for (UIImageView *img in _arrImageView) {
        [img removeFromSuperview];
    }
    _isShow = NO;

    _arrImageModel = arrModel;
    CGFloat w = (SCREEN_WIDTH - (kMEGridViewMagin *2) - (kMEGridViewPadding *2))/3;
    kMeWEAKSELF
    for (NSInteger i = 0; i<arrModel.count; i++) {
        if(i>=9){
            break;
        }
        MEBynamicPublishGridModel *model = arrModel[i];
        MEBynamicPublishGridContentView *img = _arrImageView[i];
        img.block = ^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.delBlock,i);
        };
        [img setUIWithModel:model];
        NSInteger row = i/3;//行
        NSInteger col = i%3;//列
        CGFloat picX = ((w + kMEGridViewPadding) * col)+kMEGridViewMagin;
        CGFloat picY =((w + kMEGridViewPadding) * row) +kMEGridViewPadding +48;
        img.frame = CGRectMake(picX, picY, w, w);
        [self addSubview:img];
    }
}

+ (CGFloat)getCellHeightWithArr:(NSMutableArray *)arrModel{
    CGFloat height = 58;
    CGFloat cellheight = (SCREEN_WIDTH - (kMEGridViewMagin *2) - (kMEGridViewPadding *2))/3;
    switch (kMeUnArr(arrModel).count) {
        case 0:
            height = 48;
        case 1:case 2:case 3:{
            height +=(cellheight+(kMEGridViewPadding *2));
        }
            break;
        case 4:case 5:case 6:{
            height +=((cellheight*2)+(kMEGridViewPadding *3));
        }
            break;
        default:{
            height +=((cellheight*3)+(kMEGridViewPadding *4));
        }
            break;
    }
    return height;
}
@end
