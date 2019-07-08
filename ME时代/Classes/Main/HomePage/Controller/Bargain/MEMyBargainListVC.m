//
//  MEMyBargainListVC.m
//  ME时代
//
//  Created by gao lei on 2019/7/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyBargainListVC.h"
#import "MEBargainLisCell.h"
#import "MEMyBargainListModel.h"
#import "MEBargainDetailVC.h"
#import "MEBargainRuleView.h"
#import "MENewMineHomeVC.h"

@interface MEMyBargainListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, copy) NSString *bargin_rule;

@end

@implementation MEMyBargainListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    self.title = @"我的砍价";
    self.bargin_rule = @"";
    
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    }
    NSDictionary *info = (NSDictionary *)data;
    self.bargin_rule = kMeUnNilStr(info[@"bargin_rule"]);
    MENetListModel *nlModel = [MENetListModel mj_objectWithKeyValues:info];
    [self.refresh.arrData addObjectsFromArray:[MEMyBargainListModel mj_objectArrayWithKeyValuesArray:nlModel.data]];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBargainLisCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBargainLisCell class]) forIndexPath:indexPath];
    MEMyBargainListModel *model = self.refresh.arrData[indexPath.row];
    [cell setMyBargainUIWithModel:model];
    kMeWEAKSELF
    cell.tapBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        if (index == 1) {
            [strongSelf.navigationController popViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kMeCallBlock(strongSelf.callBackBlock);
            });
        }else {
            MEBargainDetailVC *vc = [[MEBargainDetailVC alloc] initWithBargainId:model.bargin_id  myList:YES];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEBargainLisCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSString *fstr = [NSString stringWithFormat:@"我的砍价(%ld个)",(long)self.refresh.arrData.count];
    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
    NSUInteger secondLoc = [[faString string] rangeOfString:@"("].location;
    
    NSRange range = NSMakeRange(secondLoc, fstr.length - secondLoc);
    [faString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:range];
    [faString addAttribute:NSForegroundColorAttributeName value:kME666666 range:range];
    CGFloat width = [fstr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 100, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, width, 44)];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textColor = kME333333;
    titleLbl.attributedText = faString;
    [headerView addSubview:titleLbl];
    
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.frame = CGRectMake(SCREEN_WIDTH - 90, 0, 90, 44);
    [ruleBtn setTitle:@"使用规则" forState:UIControlStateNormal];
    [ruleBtn setTitleColor:kME333333 forState:UIControlStateNormal];
    [ruleBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [ruleBtn setImage:[UIImage imageNamed:@"icon_rule"] forState:UIControlStateNormal];
    [ruleBtn setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:3];
    [ruleBtn addTarget:self action:@selector(ruleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:ruleBtn];
    
    UIView *line = [self createLineView];
    line.frame = CGRectMake(0, 43, SCREEN_WIDTH, 1);
    [headerView addSubview:line];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEMyBargainListModel *model = self.refresh.arrData[indexPath.row];
    MEBargainDetailVC *vc = [[MEBargainDetailVC alloc] initWithBargainId:model.bargin_id  myList:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)createLineView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    return line;
}

- (void)ruleBtnAction {
    [MEBargainRuleView showBargainRuleViewWithTitle:self.bargin_rule cancelBlock:^{
    } superView:kMeCurrentWindow];
}

#pragma setter&&getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBargainLisCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBargainLisCell class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kMEf5f4f4;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonGetMyBarginList)];
        _refresh.delegate = self;
        _refresh.isBargain = YES;
        //        _refresh.showFailView = NO;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有砍价商品";
        }];
    }
    return _refresh;
}

@end
