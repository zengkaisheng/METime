//
//  MEBynamicPublishGridContentView.m
//  ME时代
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBynamicPublishGridContentView.h"
#import "MEBynamicPublishGridModel.h"

const static CGFloat kByContentVIewDelWH = 17;

@interface MEBynamicPublishGridContentView()


@property (nonatomic,strong)UIButton *btnDel;

@end

@implementation MEBynamicPublishGridContentView

- (instancetype)init{
    if(self = [super init]){
        [self setImageView];
    }
    return self;
}

- (void)setImageView{
    [self addSubview:self.imageVIew];
    [self addSubview:self.btnDel];
}

- (void)tapAction{
    kMeCallBlock(_block);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageVIew.frame = self.bounds;
    self.btnDel.frame = CGRectMake(self.width -kByContentVIewDelWH, 0, kByContentVIewDelWH, kByContentVIewDelWH);
}

- (void)setUIWithModel:(MEBynamicPublishGridModel*)model{
    self.imageVIew.image = model.image;
    self.btnDel.hidden = model.isAdd;
    if(model.isAdd){
        self.imageVIew.image = [UIImage imageNamed:@"icon_bynamicAdd"];
    }else{
        self.imageVIew.image = model.image;
    }
}

- (void)setUIWIthUrl:(NSString *)url{
    self.btnDel.hidden = YES;
    kSDLoadImg(self.imageVIew, kMeUnNilStr(url));
}

- (UIImageView *)imageVIew{
    if(!_imageVIew){
        _imageVIew =  [[UIImageView alloc]init];
        _imageVIew.contentMode = UIViewContentModeScaleAspectFill;
        _imageVIew.clipsToBounds = YES;
    }
    return _imageVIew;
}

- (UIButton *)btnDel{
    if(!_btnDel){
        _btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDel setImage:[UIImage imageNamed:@"icon_dydDel"] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDel;
}

@end
