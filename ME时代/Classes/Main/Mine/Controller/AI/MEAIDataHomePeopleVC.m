//
//  MEAIDataHomePeopleVC.m
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAIDataHomePeopleVC.h"
#import "MEAIDataHomeTimeCell.h"
#import "MEAIDataHomeTimeModel.h"
#import "MEAIDataHomeActiveHomeView.h"
#import "MEAiCustomerDetailVC.h"

@interface MEAIDataHomePeopleVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate>{
    MEAIDataHomeActiveHomeViewType _type;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
//@property (nonatomic , strong) MEAIDataHomeActiveHomeView *headerView;

@end

@implementation MEAIDataHomePeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = MEAIDataHomeActiveHomeViewAllType;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

- (NSDictionary *)requestParameter{
    NSString *typeStr = @"";
    switch (_type) {
        case MEAIDataHomeActiveHomeViewAllType:
            typeStr = @"all";
            break;
        case MEAIDataHomeActiveHomeViewtodayType:
            typeStr = @"day";
            break;
        case MEAIDataHomeActiveHomeViewsevenAllType:
            typeStr = @"week";
            break;
        case MEAIDataHomeActiveHomeViewmonthType:
            typeStr = @"mouth";
            break;
        default:
            break;
    }
    
    return @{@"token":kMeUnNilStr(kCurrentUser.token),@"type":typeStr};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEAIDataHomeTimeModel mj_objectArrayWithKeyValuesArray:data]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEAIDataHomeTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAIDataHomeTimeCell class]) forIndexPath:indexPath];
    MEAIDataHomeTimeModel *model = self.refresh.arrData[indexPath.row];
    [cell setPeopleUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEAIDataHomeTimeCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEAIDataHomeTimeModel *model = self.refresh.arrData[indexPath.row];
    MEAiCustomerDetailVC *vc = [[MEAiCustomerDetailVC alloc]initWithUserId:kMeUnNilStr(model.uid)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kMEAIDataHomeActiveHomeViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MEAIDataHomeActiveHomeView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEAIDataHomeActiveHomeView class])];
    [headview setUiWithType:_type];
    kMeWEAKSELF
    headview.selectBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        strongSelf->_type = index;
        [strongSelf.refresh reload];
    };
    return headview;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAIDataHomeTimeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAIDataHomeTimeCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAIDataHomeActiveHomeView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEAIDataHomeActiveHomeView class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor =[UIColor colorWithHexString:@"f4f4f4"];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonairadarcommunication)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.frame = CGRectMake(failView.x, failView.y+kMEAIDataHomeActiveHomeViewHeight, failView.width, failView.height);
            failView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
            failView.lblOfNodata.text = @"没有用户";
        }];
    }
    return _refresh;
}

@end
