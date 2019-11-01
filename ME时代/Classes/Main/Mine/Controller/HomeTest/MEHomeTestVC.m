//
//  MEHomeTestVC.m
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeTestVC.h"
#import "MEHomeTestCell.h"
#import "MEHomeAddTestDecVC.h"
#import "MEHomeTestTitleVC.h"

@interface MEHomeTestVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MEHomeTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试题库";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f6f5fa"];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEHomeTestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEHomeTestCell class]) forIndexPath:indexPath];
    [cell setUIWIithType:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case MEHomeTestCellCotentType:
        {
            MEHomeAddTestDecVC *vc = [[MEHomeAddTestDecVC alloc]init];
            vc.type = MEHomeAddTestDecTypeaddVC;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MEHomeTestListCell:
        {
            MEHomeTestTitleVC*vc = [[MEHomeTestTitleVC alloc]init];
            //平台测试库
            vc.isplatform = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
            break;
        case MEHomeTestHistoryCell:
        {
            //历史
            MEHomeTestTitleVC*vc = [[MEHomeTestTitleVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    
            break;
        default:
            break;
    }
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeTestCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEHomeTestCell class])];
        _tableView.rowHeight = kMEHomeTestCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f6f5fa"];
    }
    return _tableView;
}



@end
