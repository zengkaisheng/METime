//
//  MEHomeTestAddContentVC.m
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeTestAddContentVC.h"
#import "MEHomeTestAddContentCell.h"
#import "MEHomeAddTestDecModel.h"

const static CGFloat kMECBootomHeight = 67;

@interface MEHomeTestAddContentVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MEHomeTestAddContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加内容";
    if(!self.model){
        self.model = [MEHomeAddTestDecContentModel new];
    }
    [self.view addSubview:self.tableView];
    UIView *viewForBottom = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kMECBootomHeight, SCREEN_WIDTH, kMECBootomHeight)];
    _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAdd.frame = CGRectMake(16, 10, SCREEN_WIDTH-32, 47);
    _btnAdd.backgroundColor = kMEPink;
    [_btnAdd setTitle:@"确定提交" forState:UIControlStateNormal];
    _btnAdd.cornerRadius = 2;
    _btnAdd.clipsToBounds = YES;
    [_btnAdd addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewForBottom addSubview:_btnAdd];
    [self.view addSubview:viewForBottom];
    
}

- (void)addAction:(UIButton *)btn{
#warning --
//    if(!kMeUnNilStr(_model.content).length){
//        [SSShowViewTool showMessage:@"请先输入题目" view:self.view];
//        return;
//    }
//    if(!kMeUnNilStr(_model.option1).length){
//        [SSShowViewTool showMessage:@"请输入选项A内容" view:self.view];
//        return;
//    }
//    if(!kMeUnNilStr(_model.option2).length){
//        [SSShowViewTool showMessage:@"请输入选项B内容" view:self.view];
//        return;
//    }
//    if(!kMeUnNilStr(_model.option3).length){
//        [SSShowViewTool showMessage:@"请输入选项C内容" view:self.view];
//        return;
//    }
//    if(!kMeUnNilStr(_model.option4).length){
//        [SSShowViewTool showMessage:@"请输入选项D内容" view:self.view];
//        return;
//    }
    kMeCallBlock(_block,_model);
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEHomeTestAddContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEHomeTestAddContentCell class]) forIndexPath:indexPath];
    [cell setUiWithModel:self.model];
    return cell;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMECBootomHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeTestAddContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEHomeTestAddContentCell class])];
        _tableView.rowHeight = kMEHomeTestAddContentCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];;
    }
    return _tableView;
}
@end
