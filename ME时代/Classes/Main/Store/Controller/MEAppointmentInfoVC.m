//
//  MEAppointmentInfoVC.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentInfoVC.h"
#import "MEAppointmentDateMainCell.h"
#import "MEAppointmentTimeMainCell.h"
#import "MEAppointmentMakeOrderVC.h"
#import "MEAppointAttrModel.h"
#import "MEStoreDetailModel.h"

const static CGFloat kBtnAppointHeight = 50;

@interface MEAppointmentInfoVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _currentWeekIndex;
    NSInteger _currentTimeIndex;
    NSArray *_arrWeek;
    NSArray *_arrTime;
    MEServiceDetailsModel *_serviceDetailModel;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) UIButton           *btnAppoint;
@property (nonatomic, strong) MEAppointAttrModel              *attrModel;

@end

@implementation MEAppointmentInfoVC


- (instancetype)initWithAttrModel:(MEAppointAttrModel *)attrmodel serviceDetailModel:(MEServiceDetailsModel *)serviceDetailModel{
    if(self = [super init]){
        self.attrModel = attrmodel;
        _serviceDetailModel = serviceDetailModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentWeekIndex = 0;
    _currentTimeIndex = -1;
    _arrWeek = [METimeTool latelyWeekTime];
    _arrTime = [METimeTool getTime];
    self.title = @"预约时间";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnAppoint];
}

- (void)toAppoint:(UIButton *)btn{
    
    if(_currentTimeIndex==-1){
        kMeAlter(@"提示", @"请选择时间");
        return;
    }
    
    
    
    METimeModel *wmodel = _arrWeek[_currentWeekIndex];
    METimeModel *tmodel = _arrTime[_currentTimeIndex];
    METimeModel *model = [METimeModel new];
    model.time = tmodel.time;
    model.yearAndMonth = wmodel.yearAndMonth;
    
    NSString *selectTime = [NSString stringWithFormat:@"%@ %@",wmodel.yearAndMonth,tmodel.time];
    if([MECommonTool compareOneDay:[MECommonTool getCurrentTimesWithFormat:@"Y-M-d HH:mm"] withAnotherDay:kMeUnNilStr(selectTime)]){
        kMeAlter(@"提示", @"时间已过时");
        return;
    }
    
    
    if(_block){
        kMeCallBlock(_block,model);
    }else{
        self.attrModel.arrive_time = [NSString stringWithFormat:@"%@ %@",model.yearAndMonth,model.time];
        MEAppointmentMakeOrderVC *appVC = [[MEAppointmentMakeOrderVC alloc]initWithAttrModel:self.attrModel serviceDetailModel:_serviceDetailModel];
        [self.navigationController pushViewController:appVC animated:YES];
    }
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        MEAppointmentDateMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAppointmentDateMainCell class]) forIndexPath:indexPath];
        [cell setUIWithArr:_arrWeek currentIndex:_currentWeekIndex];
        kMeWEAKSELF
        cell.selectBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            strongSelf->_currentWeekIndex = index;
        };
        return cell;
    }else if(indexPath.section == 1){
        MEAppointmentTimeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAppointmentTimeMainCell class]) forIndexPath:indexPath];
        [cell setUIWithArr:_arrTime currentIndex:_currentTimeIndex];
        kMeWEAKSELF
        cell.selectBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            strongSelf->_currentTimeIndex = index;
        };
        return cell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return kMEAppointmentDateMainCellHeight;
    }else if(indexPath.section == 1){
        return [MEAppointmentTimeMainCell getCellHeightWithArr:_arrTime];
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);

}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kBtnAppointHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointmentDateMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAppointmentDateMainCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointmentTimeMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAppointmentTimeMainCell class])];
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
        _btnAppoint.frame = CGRectMake(0, SCREEN_HEIGHT - kBtnAppointHeight, SCREEN_WIDTH, kBtnAppointHeight);
        [_btnAppoint setTitle:@"提交预约" forState:UIControlStateNormal];
        _btnAppoint.titleLabel.font = kMeFont(15);
        [_btnAppoint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnAppoint setBackgroundColor:kMEHexColor(@"cc9e69")];
        [_btnAppoint addTarget:self action:@selector(toAppoint:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAppoint;
}



@end
