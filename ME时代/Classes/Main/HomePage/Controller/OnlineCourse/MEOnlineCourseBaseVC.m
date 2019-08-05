//
//  MEOnlineCourseBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineCourseBaseVC.h"
#import "MEOnlineCourseHeaderView.h"

#import "MEOnlineConsultCell.h"
#import "MEOnlineToolsCell.h"
#import "MEOnlineCourseListCell.h"

#import "MEAudioCourseVC.h"

@interface MEOnlineCourseBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
    NSArray *_arrDicParm;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEOnlineCourseHeaderView *headerView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MEOnlineCourseBaseVC

- (instancetype)initWithType:(NSInteger)type  materialArray:(NSArray *)materialArray{
    if (self = [super init]) {
        _type = type;
        _arrDicParm = [materialArray copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setUIWithModel:@{} type:0];
    [self.view addSubview:self.tableView];
//    [self.refresh addRefreshView];
}
#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        if (_type == 0) {
//            [self getNetWork];
        }
    }
//    NSDictionary *dic = _arrDicParm[_type];
//    return dic;
    return nil;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
//    [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.refresh.arrData.count;
    if (section == 2) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MEOnlineConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineConsultCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:@[]];
        return cell;
    }else if (indexPath.section == 1) {
        MEOnlineToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineToolsCell class]) forIndexPath:indexPath];
        cell.selectedBlock = ^(NSInteger index) {
            switch (index) {
                case 1:
                    NSLog(@"信息管理");
                    break;
                case 2:
                    NSLog(@"销售信息");
                    break;
                case 3:
                    NSLog(@"客户预约");
                    break;
                case 4:
                    NSLog(@"客户消费");
                    break;
                default:
                    break;
            }
        };
        return cell;
    }
    MEOnlineCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseListCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kMEOnlineConsultCellHeight;
    }else if (indexPath.section == 1) {
        return kMEOnlineToolsCellHeight;
    }
    return kMEOnlineCourseListCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 8.5, 60, 17)];
    titleLbl.font = [UIFont systemFontOfSize:12];
    switch (section) {
        case 0:
            titleLbl.text = @"在线咨询";
            break;
        case 1:
            titleLbl.text = @"管理工具";
            break;
        case 2:
            titleLbl.text = @"在线课程";
            break;
        default:
            break;
    }
    [headerView addSubview:titleLbl];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineConsultCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineConsultCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineToolsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineToolsCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOnlineCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOnlineCourseListCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommongetDynamicList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有内容";
        }];
    }
    return _refresh;
}

- (MEOnlineCourseHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEOnlineCourseHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEOnlineCourseHeaderViewHeight);
        kMeWEAKSELF
        _headerView.selectedBlock = ^(NSInteger index) {
            kMeSTRONGSELF
//            MEAdModel *model = strongSelf.banners[index];
//            [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            switch (index) {
                case 100:
                {
                    MEAudioCourseVC *vc = [[MEAudioCourseVC alloc] init];
                    vc.title = @"视频";
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 101:
                {
                    MEAudioCourseVC *vc = [[MEAudioCourseVC alloc] init];
                    vc.title = @"音频";
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 102:
                {
                    MEAudioCourseVC *vc = [[MEAudioCourseVC alloc] init];
                    vc.title = @"收费";
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 103:
                {
                    MEAudioCourseVC *vc = [[MEAudioCourseVC alloc] init];
                    vc.title = @"免费";
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _headerView;
}

@end
