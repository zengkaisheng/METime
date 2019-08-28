//
//  MECustomerAppointmentVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerAppointmentVC.h"
#import "MEAppointmentDateModel.h"
#import "MEAppointmentListCell.h"
#import "MEAppointmentListModel.h"
#import "MEAddAppointmentVC.h"

@interface MECustomerAppointmentVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dateList;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@property (nonatomic, strong) UIScrollView *topView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) NSString *appointment_date;
@property (nonatomic, strong) NSString *appointment_time;

@end

@implementation MECustomerAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客预约";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];
//    [self.refresh addRefreshView];
    [self getAppointmentDates];
}

- (void)reloadUI {
    CGFloat width = 72;
    CGFloat margin = 10;
    for (int i = 0; i < self.dateList.count; i++) {
        MEAppointmentDateModel *dateModel = self.dateList[i];
        UIButton *btn = [self createBtnWithTitle:[NSString stringWithFormat:@"%@ %@",kMeUnNilStr(dateModel.day),kMeUnNilStr(dateModel.date)] frame:CGRectMake((width+margin)*i, 10, width, 24) tag:100+i];
        
        int compare = [self compareDate:kMeUnNilStr(dateModel.appointment_date)];
        if (dateModel.has == 1) {
            UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, 4, 4)];
            pointView.layer.cornerRadius = 2;
            pointView.tag = 88;
            if (compare == 1) {
                pointView.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
            }else if (compare == 0) {
                pointView.backgroundColor = kMEPink;
            }else if (compare == -1) {
                pointView.backgroundColor = kMEPink;
            }
            [btn addSubview:pointView];
        }
        if (compare == 0) {
            btn.selected = YES;
            btn.backgroundColor = kMEPink;
            btn.layer.borderColor = kMEPink.CGColor;
            self.appointment_date = dateModel.appointment_date;
//            self.appointment_time = dateModel.day;
            for (UIView *view in btn.subviews) {
                if (view.tag == 88) {
                    view.backgroundColor = [UIColor whiteColor];
                }
            }
            CGFloat offsetX = btn.center.x-SCREEN_WIDTH/2;
            if (offsetX > 0) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.topView.contentOffset = CGPointMake(offsetX, 0);
                }];
            }
            [self.refresh addRefreshView];
        }
        [self.topView addSubview:btn];
    }
    self.topView.contentSize = CGSizeMake((width+margin)*self.dateList.count-10, 54);
}

/// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date];
   
    NSDate *todayDate = [[NSDate alloc] init];
    NSString *today = [[todayDate getNowDateFormatterString] componentsSeparatedByString:@" "].firstObject;
     dt2 = [df dateFromString:today];
    
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1;break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}

#pragma mark -- Networking
- (void)getAppointmentDates {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetAppointmentDateListWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
           strongSelf.dateList = [MEAppointmentDateModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        }else {
            strongSelf.dateList = [NSArray new];
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.dateList = [NSArray new];
    }];
}
//取消预约
- (void)cancelCustomerAppointmentWithAppointmentId:(NSString *)appointmentId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postCancelAppointmentWithAppointmentId:appointmentId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            [MECommonTool showMessage:@"取消预约成功" view:kMeCurrentWindow];
        }
        [strongSelf.refresh reload];
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.dateList = [NSArray new];
    }];
}
//确认预约
- (void)confirmCustomerAppointmentWithAppointmentId:(NSString *)appointmentId {
    kMeWEAKSELF
    [MEPublicNetWorkTool postConfirmAppointmentWithAppointmentId:appointmentId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            [MECommonTool showMessage:@"确认预约成功" view:kMeCurrentWindow];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.refresh reload];
        });
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.dateList = [NSArray new];
    }];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"appointment_date":self.appointment_date
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEAppointmentListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEAppointmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAppointmentListCell class]) forIndexPath:indexPath];
    MEAppointmentListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.tapBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        switch (index) {
            case 0:
            {
                if (model.is_confirm == 0) {
                    [strongSelf confirmCustomerAppointmentWithAppointmentId:[NSString stringWithFormat:@"%@",@(model.idField)]];
                }
            }
                break;
            case 1:
            {
                MEAddAppointmentVC *vc = [[MEAddAppointmentVC alloc] initWithAppointmentId:model.idField];
                vc.finishBlock = ^{
                    [strongSelf.refresh reload];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                [strongSelf cancelCustomerAppointmentWithAppointmentId:[NSString stringWithFormat:@"%@",@(model.idField)]];
            }
                break;
            default:
                break;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEAppointmentListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -- Action
- (void)topBtnDidClick:(UIButton *)sender {
    for (UIButton *btn in self.topView.subviews) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        btn.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        
        MEAppointmentDateModel *dateModel = self.dateList[btn.tag-100];
        int compare = [self compareDate:kMeUnNilStr(dateModel.appointment_date)];
        if (dateModel.has == 1) {
            for (UIView *view in btn.subviews) {
                if (view.tag == 88) {
                    if (compare == 1) {
                        view.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
                    }else if (compare == 0) {
                        view.backgroundColor = kMEPink;
                    }else if (compare == -1) {
                        view.backgroundColor = kMEPink;
                    }
                }
            }
        }
    }
    UIButton *selectedBtn = (UIButton *)sender;
    selectedBtn.selected = YES;
    selectedBtn.backgroundColor = kMEPink;
    selectedBtn.layer.borderColor = kMEPink.CGColor;
    MEAppointmentDateModel *dateModel = self.dateList[selectedBtn.tag-100];
    self.appointment_date = dateModel.appointment_date;
//    self.appointment_time = dateModel.day;
    if (dateModel.has == 1) {
        for (UIView *view in selectedBtn.subviews) {
            if (view.tag == 88) {
                view.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    CGFloat offsetX = selectedBtn.center.x-SCREEN_WIDTH/2;
    if (offsetX > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.topView.contentOffset = CGPointMake(offsetX, 0);
        }];
    }
    [self.refresh reload];
}

- (void)bottomBtnAction {
    MEAddAppointmentVC *vc = [[MEAddAppointmentVC alloc] init];
    kMeWEAKSELF
    vc.finishBlock = ^{
        kMeSTRONGSELF
        [strongSelf.refresh reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)createBtnWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kME333333 forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    btn.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    btn.layer.cornerRadius = frame.size.height/2.0;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
    [btn addTarget:self action:@selector(topBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+54, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-54-70) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointmentListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAppointmentListCell class])];
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

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonCustomerAppointmentList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无预约信息";
        }];
    }
    return _refresh;
}

- (UIScrollView *)topView {
    if (!_topView) {
        _topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, 54)];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.showsVerticalScrollIndicator = NO;
        _topView.showsHorizontalScrollIndicator = NO;
    }
    return _topView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.bottomBtn];
    }
    return _footerView;
}

- (UIButton *)bottomBtn {
    if(!_bottomBtn){
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_bottomBtn setBackgroundColor:kMEPink];
        _bottomBtn.frame = CGRectMake(40, 15, SCREEN_WIDTH-80, 40);
        _bottomBtn.layer.cornerRadius = 20.0;
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end
