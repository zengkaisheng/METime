//
//  MEPersonalCourseSearchNavView.m
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersonalCourseSearchNavView.h"

@interface MEPersonalCourseSearchNavView (){
    CGFloat _top;
}

@property (nonatomic, strong)UIView *viewForSearch;
@property (nonatomic, strong)UIImageView *imageForSearch;
@property (nonatomic, strong)UILabel *placeholderLbl;

@end

@implementation MEPersonalCourseSearchNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubUIView];
    }
    return self;
}

- (void)addSubUIView{
    self.userInteractionEnabled = YES;
    _top = ((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 52 : 28);
    
    [self addSubview:self.viewForSearch];
//    [self.viewForSearch addSubview:self.imageForSearch];
    [self.viewForSearch addSubview:self.placeholderLbl];
}

- (void)searchProduct{
    kMeCallBlock(_searchBlock);
}

- (UIView *)viewForSearch{
    if(!_viewForSearch){
        _viewForSearch = [[UIView alloc]initWithFrame:CGRectMake(37, _top, self.width-74, 29)];
        _viewForSearch.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _viewForSearch.cornerRadius = 29/2;
        _viewForSearch.clipsToBounds = YES;
        UITapGestureRecognizer *search = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchProduct)];
        _viewForSearch.userInteractionEnabled = YES;
        [_viewForSearch addGestureRecognizer:search];
    }
    return _viewForSearch;
}

- (UIImageView *)imageForSearch{
    if(!_imageForSearch){
        _imageForSearch = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchHome"]];
        _imageForSearch.contentMode = UIViewContentModeScaleAspectFit;
        _imageForSearch.frame = CGRectMake(10, 9.5, 16, 16);
    }
    return _imageForSearch;
}

- (UILabel *)placeholderLbl {
    if (!_placeholderLbl) {
        _placeholderLbl = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 40, 29)];
        _placeholderLbl.text = @"搜索";
        _placeholderLbl.textColor = [UIColor colorWithHexString:@"#707070"];
        _placeholderLbl.font = [UIFont systemFontOfSize:15];
    }
    return _placeholderLbl;
}

@end
