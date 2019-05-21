//
//  MEPosterActiveVC.m
//  ME时代
//
//  Created by hank on 2019/1/6.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEPosterActiveVC.h"
#import "TDWebViewCell.h"
#import "MEActivePosterModel.h"
#import "MECreatePosterVC.h"

@interface MEPosterActiveVC ()<UITableViewDelegate,UITableViewDataSource>{
    MEActivePosterModel *_model;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (strong, nonatomic) TDWebViewCell                  *webCell;
@property (nonatomic, strong) UIButton *btnAppoint;
@end

@implementation MEPosterActiveVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (instancetype)initWithModel:(MEActivePosterModel *)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [self initWithSomeThing];
    kTDWebViewCellDidFinishLoadNotification
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WechatSuccess:) name:WX_PAY_RESULT object:nil];
    // Do any additional setup after loading the view.
}

kTDWebViewCellDidFinishLoadNotificationMethod

- (void)initWithSomeThing{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnAppoint];
    [self.btnAppoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(50));
        make.width.equalTo(@(self.view.width));
        make.top.equalTo(@(self.view.bottom-50));
    }];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(_model.intro)] baseURL:nil];
    [MBProgressHUD showMessage:@"获取详情中" toView:self.view];
}

#pragma mark - Acion

- (void)appointAction:(UIButton *)btn{
    MECreatePosterVC *vc = [[MECreatePosterVC alloc]initWithActiveModel:_model];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return self.webCell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - Set

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-k50WH) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIButton *)btnAppoint{
    if(!_btnAppoint){
        _btnAppoint = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAppoint.frame = CGRectMake(0, self.view.height - k50WH, SCREEN_WIDTH, k50WH);
        [_btnAppoint setTitle:@"立即分享" forState:UIControlStateNormal];
        [_btnAppoint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnAppoint.backgroundColor = kMEPink;
        [_btnAppoint addTarget:self action:@selector(appointAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAppoint;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

@end
