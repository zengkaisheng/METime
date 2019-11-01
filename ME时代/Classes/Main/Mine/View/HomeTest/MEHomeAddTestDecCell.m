//
//  MEHomeAddTestDecCell.m
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeAddTestDecCell.h"
#import "MEBlockTextField.h"
#import "MEBlockTextView.h"
#import "MEHomeAddTestDecModel.h"

@interface MEHomeAddTestDecCell ()

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfTitle;
@property (weak, nonatomic) IBOutlet MEBlockTextView *tvContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@property (strong, nonatomic) MEHomeAddTestDecModel *model;
@end

@implementation MEHomeAddTestDecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;

}

- (void)setUIWIthModel:(MEHomeAddTestDecModel *)model{
    kMeWEAKSELF
    _model = model;
    _tfTitle.text = kMeUnNilStr(model.title);
    _tfTitle.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.title = kMeUnNilStr(str);
    };
    _tvContent.text = kMeUnNilStr(model.desc);
    _tvContent.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.desc = kMeUnNilStr(str);
    };
    if(kMeUnNilStr(model.image).length){
        kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(model.image));
    }
}

- (IBAction)addPhoto:(UIButton *)sender {
    kMeCallBlock(_addPhotoBlcok);
}

@end
