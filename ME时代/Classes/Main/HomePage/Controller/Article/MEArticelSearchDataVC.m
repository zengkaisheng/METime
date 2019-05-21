//
//  MEArticleListVC.m
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEArticelSearchDataVC.h"
#import "MEArticleCell.h"
#import "ZLRefreshTool.h"
#import "MEArticleDetailVC.h"
#import "MEArticelModel.h"

@interface MEArticelSearchDataVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    NSString *_key;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEArticelSearchDataVC

- (instancetype)initWithKey:(NSString *)key{
    if(self = [super init]){
        _key = kMeUnNilStr(key);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"搜索%@",_key];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"keyword":_key};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEArticelModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEArticelModel *model = self.refresh.arrData[indexPath.row];
    MEArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEArticleCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model withKey:_key];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEArticleCellheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEArticelModel *model = self.refresh.arrData[indexPath.row];
    MEArticleDetailVC *detailVC  = [[MEArticleDetailVC alloc]initWithModel:model];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEArticleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEArticleCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        view.backgroundColor = [UIColor colorWithHexString:@"f1f2f6"];
        _tableView.tableFooterView = view;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f1f2f6"];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonGetArticle)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有文章";
        }];
    }
    return _refresh;
}


@end
