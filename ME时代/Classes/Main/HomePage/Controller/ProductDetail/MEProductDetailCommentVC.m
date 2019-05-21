//
//  MEProductDetailCommentVC.m
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEProductDetailCommentVC.h"
#import "MEProductDetailCommentCell.h"
#import "METhridProductCommentHeaderView.h"
#import "MEGoodDetailModel.h"
#import "MEGoodsCommentModel.h"

@interface MEProductDetailCommentVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>{
    MEGoodDetailModel *_model;
    METhridProductCommentHeaderViewType _type;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) METhridProductCommentHeaderView *headerView;;
@end

@implementation MEProductDetailCommentVC

- (instancetype)initWithModel:(MEGoodDetailModel *)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = METhridProductCommentHeaderViewAllType;
    self.title = @"评论";
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setUIWithModel:_model type:_type];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

- (NSDictionary *)requestParameter{
    return @{@"product_id":@(_model.product_id),@"comment_type":@(_type)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEGoodsCommentModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodsCommentModel *model = self.refresh.arrData[indexPath.row];
    MEProductDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEProductDetailCommentCell class]) forIndexPath:indexPath];
    [cell setUiWIthModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodsCommentModel *model = self.refresh.arrData[indexPath.row];
    return [MEProductDetailCommentCell getCellHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEProductDetailCommentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (METhridProductCommentHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"METhridProductCommentHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kMEThridProductCommentHeaderViewHeight);
        kMeWEAKSELF
        _headerView.selectBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            strongSelf->_type = index;
            [strongSelf.refresh reload];
        };
    }
    return _headerView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPRecommenGetGoodsComment)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.lblOfNodata.text = @"没有评论";
        }];
    }
    return _refresh;
}

@end
