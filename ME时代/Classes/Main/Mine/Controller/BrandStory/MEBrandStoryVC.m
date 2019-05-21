//
//  MEBrandStoryVC.m
//  ME时代
//
//  Created by hank on 2019/4/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandStoryVC.h"
#import "MEBrandStoryHeaderView.h"
#import "MEBrandStoryModel.h"

@interface MEBrandStoryVC ()<UITableViewDelegate,UITableViewDataSource,MEBrandStoryHeaderViewDelegate>{
    MEBrandStoryModel *_model;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEBrandStoryHeaderView         *headerView;
@end

@implementation MEBrandStoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌故事";
    _model = [MEBrandStoryModel new];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

#pragma mark - MEBrandStoryHeaderViewDelegate
- (void)uploadVideo{
    
}
- (void)tapTimeAction{
    
}
- (void)tapTelAction{
    
}
- (void)tapAddressAction{
    
}
- (void)tapdetailAddressAction{
    
}

- (void)addActionWithType:(NSInteger)type{
    if(type == MEBrandStoryContentModelTXTType){
        
    }else if (type == MEBrandStoryContentModelVideoType){
        
    }else if (type == MEBrandStoryContentModelPicType){
        
    }
    [_model.arrdata addObject:@""];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.headerView clearSelect];
}


- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UITableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableHeaderView.backgroundColor = kMEPink;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (MEBrandStoryHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEBrandStoryHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, kMEBrandStoryHeaderViewHeight);
        _headerView.deleate = self;
    }
    return _headerView;
}

@end
