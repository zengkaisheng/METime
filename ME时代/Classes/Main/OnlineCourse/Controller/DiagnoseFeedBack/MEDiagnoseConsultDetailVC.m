//
//  MEDiagnoseConsultDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseConsultDetailVC.h"
#import "MEDiagnoseConsultModel.h"

@interface MEDiagnoseConsultDetailVC ()

@property (nonatomic, strong) MEDiagnoseConsultModel *model;
@property (nonatomic, assign) NSInteger consultId;

@end

@implementation MEDiagnoseConsultDetailVC

- (instancetype)initWithModel:(MEDiagnoseConsultModel *)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (instancetype)initWithConsultId:(NSInteger )consultId {
    if (self = [super init]) {
        self.consultId = consultId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问题反馈";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    
    if (self.consultId > 0) {
        [self requestConsultDetail];
    }else {
        if (_model) {
            [self loadUI];
        }
    }
}

- (void)loadUI {
    //问题描述
    CGFloat problemHeight = [self getLabelHeightWithContent:kMeUnNilStr(self.model.problem)];
    CGFloat problemViewHeight = [self getBGViewHeightWithContentHeight:problemHeight images:kMeUnArr(self.model.images)];
    
    UIView *problemView = [self createBGViewWithTitle:@"问题描述" content:kMeUnNilStr(self.model.problem) contentHeight:problemHeight images:kMeUnArr(self.model.images) frame:CGRectMake(15, kMeNavBarHeight + 10, SCREEN_WIDTH-30, problemViewHeight)];
    problemView.backgroundColor = [UIColor colorWithHexString:@"#FFD5D5"];
    [self.view addSubview:problemView];
    
    //问题回答
    CGFloat answerHeight = [self getLabelHeightWithContent:kMeUnNilStr(self.model.answer)];
    CGFloat answerViewHeight = [self getBGViewHeightWithContentHeight:answerHeight images:kMeUnArr(self.model.answer_images)];
    
    UIView *answerView = [self createBGViewWithTitle:@"问题回答" content:kMeUnNilStr(self.model.answer) contentHeight:answerHeight images:kMeUnArr(self.model.answer_images) frame:CGRectMake(15, CGRectGetMaxY(problemView.frame)+30, SCREEN_WIDTH-30, answerViewHeight)];
    answerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:answerView];
}

#pragma mark -- Networking
- (void)requestConsultDetail {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetConsultDetailWithConsultId:[NSString stringWithFormat:@"%@",@(self.consultId)] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.model = [MEDiagnoseConsultModel mj_objectWithKeyValues:responseObject.data];
        }else {
            strongSelf.model = [[MEDiagnoseConsultModel alloc] init];
        }
        [strongSelf loadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma --- Helper
- (UIView *)createBGViewWithTitle:(NSString *)title content:(NSString *)content contentHeight:(CGFloat)contentHeight images:(NSArray *)images frame:(CGRect)frame{
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.layer.cornerRadius = 10.0;
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, frame.size.width-40, 21)];
    titleLbl.text = title;
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:titleLbl];
    //内容
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 46, SCREEN_WIDTH-70, contentHeight)];
    contentLbl.text = content;
    contentLbl.textColor = kME333333;
    contentLbl.font = [UIFont systemFontOfSize:15];
    contentLbl.numberOfLines = 0;
    [bgView addSubview:contentLbl];
    //图片
    if (images.count > 0) {
        CGFloat itemWith = 75;
        CGFloat itemHeight = 70;
        for (int i = 0; i < images.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(itemWith+40)*i, frame.size.height-10-itemHeight, itemWith, itemHeight)];
            kSDLoadImg(imgView, kMeUnNilStr(images[i]));
            [bgView addSubview:imgView];
        }
    }
    
    return bgView;
}

- (CGFloat)getLabelHeightWithContent:(NSString *)content {
    CGFloat height = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    return height;
}

- (CGFloat)getBGViewHeightWithContentHeight:(CGFloat)contentHeight images:(NSArray *)images{
    CGFloat height = 15 + 21 + 10 + contentHeight + 10;
    if (images.count > 0) {
        height += 70 + 10;
    }
    return height>176?height:176;
}

@end
