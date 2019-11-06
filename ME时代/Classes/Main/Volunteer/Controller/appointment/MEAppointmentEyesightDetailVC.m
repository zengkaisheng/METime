//
//  MEAppointmentEyesightDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAppointmentEyesightDetailVC.h"
#import "MEEyesightDetailTopCell.h"
#import "MEEyesightStoreCell.h"
#import "MEEyesightBottomCell.h"
#import "TDWebViewCell.h"
#import "MEServiceDetailsModel.h"
#import "MEAppointAttrModel.h"
#import "UIButton+ImageTitleSpacing.h"

#import "MEAppointmentInfoVC.h"

@interface MEAppointmentEyesightDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) TDWebViewCell *webCell;
@property (nonatomic, strong) MEServiceDetailsModel *model;
@property (nonatomic, strong) MEAppointAttrModel *attrModel;
@property (nonatomic, strong) NSMutableArray *mapsArray;

@end

@implementation MEAppointmentEyesightDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视力预约";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,@""] baseURL:nil];
    
    [self requestAppointmentDetailWithNetWork];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-56, SCREEN_WIDTH, 56)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *appointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [appointmentBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [appointmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appointmentBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    appointmentBtn.backgroundColor = [UIColor colorWithHexString:@"#2DD9A4"];
    appointmentBtn.frame = CGRectMake(SCREEN_WIDTH-15-115, 5, 115, 46);
    appointmentBtn.layer.cornerRadius = 8.0;
    [appointmentBtn addTarget:self action:@selector(appointmentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:appointmentBtn];
    
    NSArray *btns = @[@{@"title":@"首页",@"image":@"icon_toHome"},@{@"title":@"好友",@"image":@"icon_toFriends"},@{@"title":@"朋友圈",@"image":@"icon_toPengYouQuan"}];
    CGFloat itemW = (SCREEN_WIDTH-15-115-20)/btns.count;
    for (int i = 0; i < btns.count; i++) {
        NSDictionary *dict = btns[i];
        UIButton *btn = [self createBtnWithTitle:dict[@"title"] image:dict[@"image"] frame:CGRectMake(10+itemW*i, 0, itemW, 56) tag:100+i];
        [bottomView addSubview:btn];
    }
}

- (UIButton *)createBtnWithTitle:(NSString *)title image:(NSString *)image frame:(CGRect)frame tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    btn.frame = frame;
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)reloadUI {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(self.model.serviceDetail.content).length>0?kMeUnNilStr(self.model.serviceDetail.content):@"<p>暂无活动详情</p>"] baseURL:nil];
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark -- Action
- (void)btnDidClick:(UIButton *)sender {
    switch (sender.tag - 100) {
        case 0:
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.navigationController.tabBarController.selectedIndex = 0;
            break;
        case 1:
            NSLog(@"分享给好友");
            break;
        case 2:
            NSLog(@"分享给朋友圈");
            break;
        default:
            break;
    }
}

- (void)appointmentBtnAction {
    self.attrModel.storeName = self.model.serviceDetail.company_name;
    self.attrModel.product_id = self.model.serviceDetail.product_id;
    self.attrModel.isFromStroe = NO;
    MEAppointmentInfoVC *infoVC = [[MEAppointmentInfoVC alloc]initWithAttrModel:self.attrModel serviceDetailModel:self.model];
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark -- Networking
//视力预约详情
- (void)requestAppointmentDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetVolunteerReserveDetailWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEServiceDetailsModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MEEyesightDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEEyesightDetailTopCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.model.serviceDetail];
        return cell;
    }else if (indexPath.row == 1) {
        MEEyesightStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEEyesightStoreCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.model.serviceDetail];
        kMeWEAKSELF
        cell.pilotBlock = ^{
            kMeSTRONGSELF
            [MECommonTool doNavigationWithEndLocation:@[kMeUnNilStr(strongSelf.model.serviceDetail.company_latitude),kMeUnNilStr(strongSelf.model.serviceDetail.company_longitude)]];
        };
        return cell;
    }
    else if (indexPath.row == 2) {
        MEEyesightBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEEyesightBottomCell class]) forIndexPath:indexPath];
        [cell setUIWithContent:kMeUnNilStr(self.model.serviceDetail.content)];
        return cell;
    }
    return self.webCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90+324*kMeFrameScaleX();
    }else if (indexPath.row == 1) {
        return 118;
    }else if (indexPath.row == 2) {
        return [MEEyesightBottomCell getHeightWithContentHeight:[[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue]];
    }
    if(!_webCell){
        return 0;
    }
    return 0;
}

#pragma setter && getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-56) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEEyesightDetailTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEEyesightDetailTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEEyesightStoreCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEEyesightStoreCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEEyesightBottomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEEyesightBottomCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

- (NSMutableArray *)mapsArray {
    if (!_mapsArray) {
        _mapsArray = [[NSMutableArray alloc] init];
    }
    return _mapsArray;
}

- (MEAppointAttrModel *)attrModel{
    if(!_attrModel){
        _attrModel = [[MEAppointAttrModel alloc] initAttr];
    }
    return _attrModel;
}

@end
