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

#import "MECourseListVC.h"

@interface MEAudioCourseBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
    NSArray *_arrDicParm;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEOnlineCourseHeaderView *headerView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MEAudioCourseBaseVC

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
    [self.headerView setUIWithModel:@{} type:1];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.refresh.arrData.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MEOnlineCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseListCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    titleLbl.text = @"在线课程";
    [headerView addSubview:titleLbl];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
            switch (index) {
                case 102:
                {
                    MECourseListVC *vc = [[MECourseListVC alloc] init];
                    vc.title = [NSString stringWithFormat:@"%@收费",strongSelf.title];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 103:
                {
                    MECourseListVC *vc = [[MECourseListVC alloc] init];
                    vc.title = [NSString stringWithFormat:@"%@免费",strongSelf.title];
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
