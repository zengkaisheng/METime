//
//  MEQuestionDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEQuestionDetailVC.h"

@interface MEQuestionDetailVC ()

@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation MEQuestionDetailVC

- (instancetype)initWithQuestionId:(NSInteger)questionId {
    if (self = [super init]) {
        _questionId = questionId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createImageViewWithImage:@"icon_question" frame:CGRectMake(15, kMeNavBarHeight + 25, 18, 18)];
    [self createImageViewWithImage:@"icon_answer" frame:CGRectMake(15, kMeNavBarHeight + 75, 18, 18)];
    
    [self.view addSubview:self.titleLbl];
    [self.view addSubview:self.contentTextView];
    [self requestNetWork];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.rightBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.rightBtn) {
        [self.rightBtn removeFromSuperview];
        self.rightBtn = nil;
    }
}


#pragma mark -- networking
- (void)requestNetWork{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetQuestionDetailWithQuestionId:self.questionId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject.data;
            strongSelf.titleLbl.text = dic[@"title"];
            strongSelf.contentTextView.text = dic[@"content"];
        }
    } failure:^(id object) {
//        kMeSTRONGSELF
//        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)reloadData {
    [self requestNetWork];
}

- (void)createImageViewWithImage:(NSString *)image frame:(CGRect)frame {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    imgV.frame = frame;
    [self.view addSubview:imgV];
}

#pragma setter && getter
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"icon_refresh"] forState:UIControlStateNormal];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 44, 44);
        [_rightBtn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(43, kMeNavBarHeight + 25, SCREEN_WIDTH - 50, 18)];
        _titleLbl.font = [UIFont systemFontOfSize:17];
    }
    return _titleLbl;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(43, kMeNavBarHeight + 67, SCREEN_WIDTH - 43 - 19, SCREEN_HEIGHT - 75)];
        _contentTextView.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
        _contentTextView.font = [UIFont systemFontOfSize:15];
        _contentTextView.editable = NO;
    }
    return _contentTextView;
}


@end
