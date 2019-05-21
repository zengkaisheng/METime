//
//  MEMineNewShareView.m
//  ME时代
//
//  Created by hank on 2018/12/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineNewShareView.h"

@interface MEMineNewShareView (){
 
}

//code WH
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgCodeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgCodeH;
//headerpic wh
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consLevTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consCodeR;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHeaderL;

//展示图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consbIMgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSubViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UIImageView *imgCode;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@end

@implementation MEMineNewShareView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    
    _consSubViewHeight.constant = 140 * kMeFrameScaleX();
    _consbIMgHeight.constant = (1053 * SCREEN_WIDTH)/750;

    _consImgCodeW.constant = 110 * kMeFrameScaleX();
    _consImgCodeH.constant = 110 * kMeFrameScaleX();
    _consHw.constant = 50* kMeFrameScaleX();
    _conHh.constant = 50* kMeFrameScaleX();
    _imgHeader.cornerRadius = (50* kMeFrameScaleX())/2;
    _imgHeader.clipsToBounds = YES;
    _consNameTop.constant = 50* kMeFrameScaleX();
    _consLevTop.constant = 10* kMeFrameScaleX();
    if(kMeFrameScaleX()<1){
        _consCodeR.constant = 5;
        _consHeaderL.constant = 5;
    }else{
        _consCodeR.constant = 20* kMeFrameScaleX();
        _consHeaderL.constant = 20* kMeFrameScaleX();
    }

}

- (void)setCode:(NSString *)codeStr levStr:(NSString*)levStr{
    _imgPic.image = [UIImage imageNamed:@"codeb"];
    kSDLoadImg(_imgCode, kMeUnNilStr(codeStr));
    kSDLoadImg(_imgHeader, kMeUnNilStr(kCurrentUser.header_pic));
    _lblName.text = kMeUnNilStr(kCurrentUser.name);
    _lblLevel.text = kMeUnNilStr(levStr);
}

+ (CGFloat)getViewHeight{
    CGFloat height = 140 * kMeFrameScaleX();
    CGFloat imgH = (1053 * SCREEN_WIDTH)/750;
    return height + imgH;
}



@end
