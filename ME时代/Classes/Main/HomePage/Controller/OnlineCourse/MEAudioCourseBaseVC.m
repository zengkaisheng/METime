//
//  MEAudioCourseBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAudioCourseBaseVC.h"
#import "MEOnlineCourseHeaderView.h"
#import "MEOnlineCourseListCell.h"
#import "MEOnlineCourseListModel.h"
#import "MECourseListVC.h"

#import "MECourseDetailVC.h"

@interface MEAudioCourseBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
    NSInteger _index;
    NSArray *_arrDicParm;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEOnlineCourseHeaderView *headerView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MEAudioCourseBaseVC

- (instancetype)initWithType:(NSInteger)type index:(NSInteger)index materialArray:(NSArray *)materialArray{
    if (self = [super init]) {
        _type = type;
        _index = index;
        _arrDicParm = [materialArray copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_index == 0) {
        self.tableView.tableHeaderView = self.headerView;
        [self.headerView setUIWithArray:@[] type:1];
    }
    
    switch (_type) {
        case 0:
            self.title = @"在线视频";
            break;
        case 1:
            self.title = @"在线音频";
            break;
        case 2:
            self.title = @"收费频道";
            break;
        case 3:
            self.title = @"免费频道";
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.tableView];
    //    [self.refresh addRefreshView];
}
#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        if (_index == 0) {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.refresh.arrData.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MEOnlineCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseListCell class]) forIndexPath:indexPath];
    MEOnlineCourseListModel *model = [[MEOnlineCourseListModel alloc] init];
    [cell setUIWithModel:model isHomeVC:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEOnlineCourseListCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 17)];
    titleLbl.font = [UIFont systemFontOfSize:12];
    switch (_type) {
        case 0:
            titleLbl.text = @"在线视频";
            break;
        case 1:
            titleLbl.text = @"在线音频";
            break;
        case 2:
            titleLbl.text = @"收费频道";
            break;
        case 3:
            titleLbl.text = @"免费频道";
            break;
        default:
            break;
    }
    
    [headerView addSubview:titleLbl];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MECourseDetailVC *vc = [[MECourseDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
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
            NSInteger type = 0;
            switch (index) {
                case 102:
                {
                    if (strongSelf->_type == 0) {
                        type = 4;
                    }else if (strongSelf->_type == 1) {
                        type = 5;
                    }
                    MECourseListVC *vc = [[MECourseListVC alloc] initWithType:type];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 103:
                {
                    if (strongSelf->_type == 0) {
                        type = 6;
                    }else if (strongSelf->_type == 1) {
                        type = 7;
                    }
                    MECourseListVC *vc = [[MECourseListVC alloc] initWithType:type];
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
