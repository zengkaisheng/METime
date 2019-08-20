//
//  MECourseChargeOrFreeBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseChargeOrFreeBaseVC.h"
#import "MEOnlineCourseListCell.h"
#import "MECourseDetailVC.h"
#import "MEOnlineCourseListModel.h"

@interface MECourseChargeOrFreeBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isFree;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MECourseChargeOrFreeBaseVC

- (instancetype)initWithType:(NSInteger)type isFree:(BOOL)isFree {
    if (self = [super init]) {
        _type = type;
        _isFree = isFree;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"is_charge":@(self.isFree?2:1),
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEOnlineCourseListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEOnlineCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOnlineCourseListCell class]) forIndexPath:indexPath];
    MEOnlineCourseListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model isHomeVC:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEOnlineCourseListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEOnlineCourseListModel *model = self.refresh.arrData[indexPath.row];
    MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:_type];
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
        NSString *url = @"";
        if (self.type == 0) {
            url = kGetApiWithUrl(MEIPcommonVideoList);
        }else {
            url = kGetApiWithUrl(MEIPcommonAudioList);
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:url];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关课程";
        }];
    }
    return _refresh;
}

@end
