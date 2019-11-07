//
//  MERecruitDetailVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecruitDetailVC.h"
#import "MERecruitDetailModel.h"
#import "MERecruitInfoCell.h"
#import "MERecruitDetailCell.h"
#import "MERecruitJoinUsersCell.h"
#import "MERecruitCommentCell.h"
#import "MEJoinusersListVC.h"

@interface MERecruitDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger recruitId;
@property (nonatomic, strong) NSString * latitude;       //纬度
@property (nonatomic, strong) NSString * longitude;      //经度
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MERecruitDetailModel *model;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UIButton *signUpBtn;

@end

@implementation MERecruitDetailVC

- (instancetype)initWithRecruitId:(NSInteger)recruitId latitude:(NSString *)latitude longitude:(NSString *)longitude {
    if (self = [super init]) {
        self.recruitId = recruitId;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动招募详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self requestRecruitDetailWithNetWork];
    [self.view addSubview:self.attentionBtn];
    [self.view addSubview:self.signUpBtn];
}

#pragma mark -- Networking
//活动招募详情
- (void)requestRecruitDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetRecruitDetailWithRecruitId:self.recruitId latitude:kMeUnNilStr(self.latitude) longitude:kMeUnNilStr(self.longitude) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MERecruitDetailModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        strongSelf.attentionBtn.selected = strongSelf.model.attention_status;
        strongSelf.signUpBtn.selected = strongSelf.model.join_status;
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

//点赞/取消点赞
- (void)praiseRecruitActivity{
    [MEPublicNetWorkTool postPraiseRecruitWithRecruitId:self.model.idField status:self.model.attention_status==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            if (strongSelf.model.attention_status == 0) {
                [MECommonTool showMessage:@"点赞成功" view:kMeCurrentWindow];
                strongSelf.model.attention_status = 1;
            }else {
                [MECommonTool showMessage:@"取消点赞成功" view:kMeCurrentWindow];
                strongSelf.model.attention_status = 0;
            }
            strongSelf.attentionBtn.selected = strongSelf.model.attention_status;
        }
    } failure:^(id object) {
        
    }];
}

//报名/取消报名
- (void)joinRecruitActivity{
    [MEPublicNetWorkTool postJoinRecruitWithRecruitId:self.model.idField status:self.model.join_status==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            if (strongSelf.model.join_status == 0) {
                [MECommonTool showMessage:@"报名成功" view:kMeCurrentWindow];
                strongSelf.model.join_status = 1;
            }else {
                [MECommonTool showMessage:@"取消报名成功" view:kMeCurrentWindow];
                strongSelf.model.join_status = 0;
            }
            strongSelf.signUpBtn.selected = strongSelf.model.join_status;
        }
    } failure:^(id object) {
        
    }];
}

#pragma mark -- Action
- (void)attentionBtnAction {
    //关注
    [self praiseRecruitActivity];
}

- (void)signUpBtnAction {
    //报名
    [self joinRecruitActivity];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MERecruitInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecruitInfoCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.model];
        return cell;
    }else if (indexPath.row == 1) {
        MERecruitDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecruitDetailCell class]) forIndexPath:indexPath];
        [cell setUIWithContent:kMeUnNilStr(self.model.detail)];
        return cell;
    }else if (indexPath.row == 3) {
//        MERecruitCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecruitCommentCell class]) forIndexPath:indexPath];
//        [cell setUIWithArray:kMeUnArr(self.model.comment)];
//        return cell;
    }
    MERecruitJoinUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecruitJoinUsersCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:self.model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 382-168+168*kMeFrameScaleX();
    }else if (indexPath.row == 1) {
        [MERecruitDetailCell getCellHeightWithContent:kMeUnNilStr(self.model.detail)];
    }else if (indexPath.row == 3) {
//        CGFloat height = 44+8+16;
//        for (MERecruitCommentModel *model in self.model.comment) {
//            height += model.contentHeight;
//        }
//        return height;
#warning 暂时隐藏
    }
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        MEBaseVC *vc = [[MEBaseVC alloc] init];
        vc.title = @"活动详情";
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
        CGFloat width = [UIScreen mainScreen].bounds.size.width-15;
        NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
        [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(self.model.detail)] baseURL:nil];
        [vc.view addSubview:webView];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        MEJoinusersListVC *vc = [[MEJoinusersListVC alloc] initWithRecruitId:self.model.idField];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3) {
        
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-49) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERecruitInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERecruitInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERecruitDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERecruitDetailCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERecruitJoinUsersCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERecruitJoinUsersCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERecruitCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERecruitCommentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH/2, 49)];
        _attentionBtn.backgroundColor = [UIColor whiteColor];
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionBtn setImage:[UIImage imageNamed:@"icon_recruit_attention_nor"] forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_attentionBtn setImage:[UIImage imageNamed:@"icon_recruit_attention_sel"] forState:UIControlStateSelected];
        [_attentionBtn setTitleColor:[UIColor colorWithHexString:@"#2ED9A4"] forState:UIControlStateSelected];
        _attentionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _attentionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_attentionBtn addTarget:self action:@selector(attentionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

- (UIButton *)signUpBtn {
    if (!_signUpBtn) {
        _signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-49, SCREEN_WIDTH/2, 49)];
        _signUpBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [_signUpBtn setTitle:@"我要报名" forState:UIControlStateNormal];
        [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signUpBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
         [_signUpBtn setTitle:@"取消报名" forState:UIControlStateSelected];
        
        [_signUpBtn addTarget:self action:@selector(signUpBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpBtn;
}

@end
