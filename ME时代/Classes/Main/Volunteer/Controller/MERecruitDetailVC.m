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

#import "IQKeyboardManager.h"
#import "MECommentInputView.h"
#import "MEVolunteerCommentsView.h"
#import <CoreLocation/CoreLocation.h>

@interface MERecruitDetailVC ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

@property (nonatomic, assign) NSInteger recruitId;
@property (nonatomic, strong) NSString * latitude;       //纬度
@property (nonatomic, strong) NSString * longitude;      //经度
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MERecruitDetailModel *model;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UIButton *signUpBtn;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) MECommentInputView *inputView;

@property (nonatomic, strong) CLLocationManager *locationManager;  //定位管理器

@end

@implementation MERecruitDetailVC

- (instancetype)initWithRecruitId:(NSInteger)recruitId {
    if (self = [super init]) {
        self.recruitId = recruitId;
        
    }
    return self;
}

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
    self.index = -1;
    [self.view addSubview:self.tableView];
    if (kMeUnNilStr(self.latitude).length <= 0 ||kMeUnNilStr(self.longitude).length <= 0) {
        [self getCurrentLocation];
    }else {
        [self requestRecruitDetailWithNetWork];
    }
    [self.view addSubview:self.commentBtn];
    [self.view addSubview:self.attentionBtn];
    [self.view addSubview:self.signUpBtn];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self.view addSubview:self.inputView];
    kMeWEAKSELF
    self.inputView.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (strongSelf.index == -1) {
            [strongSelf commentRecruitActivityWithContent:kMeUnNilStr(str)];
        }else {
            MERecruitCommentModel *model = strongSelf.model.comment[strongSelf.index];
            [strongSelf commentBackRecruitActivityWithContent:str commentId:[NSString stringWithFormat:@"%@",@(model.idField)]];
        }
    };
}

- (void)getCurrentLocation {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager startUpdatingLocation];
        [MECommonTool showMessage:@"获取定位中..." view:kMeCurrentWindow];
    }
}

#pragma mark -- CLLocationManagerDelegate
/*定位失败则执行此代理方法*/
/*定位失败弹出提示窗，点击打开定位按钮 按钮，会打开系统设置，提示打开定位服务*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    /*设置提示提示用户打开定位服务*/
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok =[UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /*打开定位设置*/
        NSURL * settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingsURL];
    }];
    UIAlertAction * cacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ok];
    [alert addAction:cacel];
    [self presentViewController:alert animated:YES completion:nil];
}
/*定位成功后则执行此代理方法*/
#pragma mark 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    /*旧值*/
    CLLocation * currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    /*打印当前经纬度*/
    NSLog(@"%f%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    self.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    [self requestRecruitDetailWithNetWork];
    [_locationManager stopUpdatingLocation];
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
//留言
- (void)commentRecruitActivityWithContent:(NSString *)content {
    [MEPublicNetWorkTool postCommentRecruitActivityWithActivityId:[NSString stringWithFormat:@"%@",@(self.model.idField)] content:content successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            [MECommonTool showMessage:@"留言成功" view:kMeCurrentWindow];
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                MERecruitCommentModel *model = [MERecruitCommentModel mj_objectWithKeyValues:responseObject.data];
                NSMutableArray *comment = [NSMutableArray arrayWithArray:strongSelf.model.comment];
                [comment insertObject:model atIndex:0];
                strongSelf.model.comment = [comment copy];
                NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            }else {
                [strongSelf requestRecruitDetailWithNetWork];
            }
        }
    } failure:^(id object) {
        
    }];
}
//活动留言回复
- (void)commentBackRecruitActivityWithContent:(NSString *)content commentId:(NSString *)commentId{
    [MEPublicNetWorkTool postCommentBackRecruitActivityWithCommentId:commentId content:content successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            [MECommonTool showMessage:@"回复成功" view:kMeCurrentWindow];
            [strongSelf requestRecruitDetailWithNetWork];
        }
    } failure:^(id object) {
        
    }];
}

#pragma mark -- Action
- (void)commentBtnAction {
    //评论
//    self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-20-34, SCREEN_WIDTH, 34+20);
    self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-34-20-200, SCREEN_WIDTH, 34+20);
    [self.inputView.textView.textView becomeFirstResponder];
    self.index = -1;
}

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
    return 4;
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
        MERecruitCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecruitCommentCell class]) forIndexPath:indexPath];
        [cell setUIWithArray:kMeUnArr(self.model.comment)];
        kMeWEAKSELF
        cell.tapBlock = ^(NSString * str, NSInteger index) {
            kMeSTRONGSELF
            strongSelf.index = index;
            if ([str isEqualToString:@"回复"]) {
//                strongSelf.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-20-34, SCREEN_WIDTH, 34+20);
                strongSelf.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-34-20-200, SCREEN_WIDTH, 34+20);
                [strongSelf.inputView.textView.textView becomeFirstResponder];
            }
        };
        return cell;
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
        CGFloat height = 44+8+22;
        for (MERecruitCommentModel *model in self.model.comment) {
            height += model.contentHeight;
        }
        return height;
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
        MEVolunteerCommentsView *commentView = [[MEVolunteerCommentsView alloc] initWithActivityId:[NSString stringWithFormat:@"%@",@(self.model.idField)]];
        kMeWEAKSELF
        commentView.reloadBlock = ^{
           kMeSTRONGSELF
            [strongSelf requestRecruitDetailWithNetWork];
        };
        [self.view addSubview:commentView];
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

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, (SCREEN_WIDTH-141)/2, 49)];
        _commentBtn.backgroundColor = [UIColor whiteColor];
        [_commentBtn setTitle:@"留言" forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"icon_recruit_comment_nor"] forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_commentBtn addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-141)/2, SCREEN_HEIGHT-49, (SCREEN_WIDTH-141)/2, 49)];
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
        _signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-141, SCREEN_HEIGHT-49, 141, 49)];
        _signUpBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [_signUpBtn setTitle:@"我要报名" forState:UIControlStateNormal];
        [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signUpBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
         [_signUpBtn setTitle:@"取消报名" forState:UIControlStateSelected];
        
        [_signUpBtn addTarget:self action:@selector(signUpBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpBtn;
}

- (MECommentInputView *)inputView {
    if (!_inputView) {
        _inputView = [[MECommentInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 34+20)];
        kMeWEAKSELF
        _inputView.cancelBlock = ^{
            kMeSTRONGSELF
            strongSelf->_inputView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 34+20);
        };
    }
    return _inputView;
}

@end
