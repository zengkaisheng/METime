//
//  MECourseAudioListVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseAudioListVC.h"
#import "MEOnlineCourseListModel.h"
#import "MEOnlineCourseListCell.h"
#import "MECourseDetailVC.h"

@interface MECourseAudioListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _categoryId;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, strong) NSString *listType;

@end

@implementation MECourseAudioListVC

- (instancetype)initWithCategoryId:(NSInteger)categoryId listType:(NSString *)listType{
    if (self = [super init]) {
        _categoryId = categoryId;
        self.listType = listType;
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
    if (kMeUnNilStr(self.listType).length > 0) {
        return @{@"token":kMeUnNilStr(kCurrentUser.token),
//                 @"audio_type":@(_categoryId),
                 self.listType:@"1"
                 };
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"audio_type":@(_categoryId)
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
    [cell setUIWithModel:model isHomeVC:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEOnlineCourseListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEOnlineCourseListModel *model = self.refresh.arrData[indexPath.row];
    MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:0];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
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
        NSString *url = kGetApiWithUrl(MEIPcommonAudioList);
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
