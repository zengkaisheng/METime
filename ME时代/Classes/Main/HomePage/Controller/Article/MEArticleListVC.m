//
//  MEArticleListVC.m
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEArticleListVC.h"
#import "MEArticleCell.h"
#import "MEArticelSearchVC.h"
#import "MENavigationVC.h"
#import "MEArticelSearchDataVC.h"
#import "MEArticleDetailVC.h"
#import "MEArticelCategoryModel.h"
#import "MEArticelModel.h"

@interface MEArticleListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    MEArticelCategoryModel *_model;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;


@end

@implementation MEArticleListVC

- (instancetype)initWithModel:(MEArticelCategoryModel *)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"article_category_id":@(_model.idField)};
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
    [cell setUIWithModel:model];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEArticleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEArticleCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        view.backgroundColor = [UIColor colorWithHexString:@"f1f2f6"];
        _tableView.tableFooterView = view;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
