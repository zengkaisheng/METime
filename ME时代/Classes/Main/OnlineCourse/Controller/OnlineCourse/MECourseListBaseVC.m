//
//  MECourseListBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseListBaseVC.h"
#import "MEourseClassifyModel.h"
#import "MEOnlineCourseListCell.h"
#import "MECourseDetailVC.h"
#import "MEOnlineCourseListModel.h"

@interface MECourseListBaseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
    NSInteger _index;
    NSArray *_arrDicParm;
    NSInteger _is_charge;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MECourseListBaseVC

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
    switch (_type) {
        case 0:
            self.title = @"在线视频";
            break;
        case 1:
            self.title = @"在线音频";
            break;
        case 2:
            self.title = @"收费频道";
            self.tableView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight);
            break;
        case 3:
            self.title = @"免费频道";
            self.tableView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight);
            break;
        case 4:
        {
            self.title = @"视频收费频道";
            _is_charge = 1;
        }
            break;
        case 5:
        {
            self.title = @"音频收费频道";
            _is_charge = 1;
        }
            break;
        case 6:
        {
            self.title = @"视频免费频道";
            _is_charge = 2;
        }
            break;
        case 7:
        {
            self.title = @"音频免费频道";
            _is_charge = 2;
        }
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}
#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    MEourseClassifyModel *model = _arrDicParm[_index];
    if (_type == 1 || _type == 5 || _type == 7) {
        return @{@"token":kMeUnNilStr(kCurrentUser.token),
                 @"is_charge":@(_is_charge),
                 @"audio_type":@(model.idField)
                 };
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"is_charge":@(_is_charge),
             @"video_type":@(model.idField)
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 17)];
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
        case 4:
            titleLbl.text = @"视频收费频道";
            break;
        case 5:
            titleLbl.text = @"音频收费频道";
            break;
        case 6:
            titleLbl.text = @"视频免费频道";
            break;
        case 7:
            titleLbl.text = @"音频免费频道";
            break;
        default:
            break;
    }
    [headerView addSubview:titleLbl];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEOnlineCourseListModel *model = self.refresh.arrData[indexPath.row];
    MECourseDetailVC *vc = [[MECourseDetailVC alloc] initWithId:model.idField type:_type];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-(_arrDicParm.count<2?0.1:kCategoryViewHeight)) style:UITableViewStylePlain];
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
        if (_type == 0 || _type == 4 || _type == 6) {
            url = kGetApiWithUrl(MEIPcommonVideoList);
        }else if (_type == 1 || _type == 5 || _type == 7) {
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
