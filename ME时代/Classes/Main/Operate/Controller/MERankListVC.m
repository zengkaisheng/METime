//
//  MERankListVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERankListVC.h"
#import "MEOperationClerkRankModel.h"
#import "MEOperationObjectRankModel.h"
#import "MEOperationContentCell.h"

@interface MERankListVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) NSInteger type;

@end

@implementation MERankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"员工排名";
    self.type = 1;
    if (self.isObjectList) {
        self.title = @"服务项目排名";
    }
    [self.view addSubview:self.headView];
    
    if (self.isObjectList) {
        [self setUIWithObjectRanging];
    }else {
        [self setUIWithClerkRanging];
    }
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

- (void)setUIWithClerkRanging {
    NSArray *btns = @[@"业绩",@"服务",@"项目数"];
    CGFloat btnWidth = (SCREEN_WIDTH-32)/3;;
    for (int i = 0; i < btns.count; i++) {
        UIButton *btn = [self createBtnWithTitle:btns[i] frame:CGRectMake(btnWidth*i+16, 10, btnWidth, 25) tag:100+i];
        if (i == 0) {
            btn.selected = YES;
            btn.layer.borderWidth = 0.0;
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#B29FFF"]];
        }
        [self.headView addSubview:btn];
    }
}

- (void)btnDidClick:(UIButton *)sender {
    if (self.isObjectList) {
        
        for (id obj in self.headView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                btn.selected = NO;
            }else {
                UIView *view = (UIView *)obj;
                if (view.tag > 99) {
                    view.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
                }
            }
        }
        UIButton *selectedBtn = (UIButton *)sender;
        selectedBtn.selected = YES;
        for (id obj in self.headView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
            }else {
                UIView *view = (UIView *)obj;
                if (view.tag == selectedBtn.tag) {
                    view.backgroundColor =  [UIColor colorWithHexString:@"#B29FFF"];
                }
            }
        }
        self.type = selectedBtn.tag - 99;
    }else {
        for (UIButton *btn in self.headView.subviews) {
            btn.selected = NO;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        UIButton *selectedBtn = (UIButton *)sender;
        selectedBtn.selected = YES;
        selectedBtn.layer.borderWidth = 0.0;
        [selectedBtn setBackgroundColor:[UIColor colorWithHexString:@"#B29FFF"]];
        self.type = selectedBtn.tag - 99;
    }
    [self.refresh reload];
}

- (UIButton *)createBtnWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#1D1D1D"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.layer.borderWidth = 1.0;
    btn.frame = frame;
    btn.tag = tag;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)setUIWithObjectRanging {
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 19, SCREEN_WIDTH, 1)];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#707070"];
    [self.headView addSubview:lineV];
    
    NSArray *btns = @[@"日排行",@"周排行",@"月排行",@"年排行"];
    CGFloat btnWidth = SCREEN_WIDTH/4;
    for (int i = 0; i < btns.count; i++) {
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*i + (btnWidth-24)/2, 7, 24, 24)];
        circleView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        circleView.layer.cornerRadius = 12;
        circleView.tag = 100+i;
        [self.headView addSubview:circleView];
        
        UIButton *btn = [self createObjectRankBtnWithTitle:btns[i] frame:CGRectMake(btnWidth*i, 0, btnWidth, 52) tag:100+i];
        if (i == 0) {
            btn.selected = YES;
            circleView.backgroundColor = [UIColor colorWithHexString:@"#B29FFF"];
        }
        [self.headView addSubview:btn];
    }
}

- (UIButton *)createObjectRankBtnWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#1D1D1D"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    btn.frame = frame;
    btn.tag = tag;
    btn.titleEdgeInsets = UIEdgeInsetsMake(15, 0, -15, 0);
    
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if (self.isObjectList) {
        return @{@"token":kMeUnNilStr(kCurrentUser.token),
                 @"date_type":@(self.type)
                 };
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"type":@(self.type)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if (self.isObjectList) {
        [self.refresh.arrData addObjectsFromArray:[MEOperationObjectRankModel mj_objectArrayWithKeyValuesArray:data]];
    }else {
        [self.refresh.arrData addObjectsFromArray:[MEOperationClerkRankModel mj_objectArrayWithKeyValuesArray:data]];
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEOperationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOperationContentCell class]) forIndexPath:indexPath];
    
    NSDictionary *info = @{@"title":self.title,@"index":@(self.type-1),@"type":(self.isObjectList?@(7):@(6)),@"content":[self.refresh.arrData copy]};
    [cell setUIWithInfo:info];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52*self.refresh.arrData.count+20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isObjectList) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isObjectList) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
        nameLbl.text = @"项目名称";
        nameLbl.font = [UIFont systemFontOfSize:15];
        nameLbl.textAlignment = NSTextAlignmentCenter;
        [header addSubview:nameLbl];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-1)/2, 5, 1, 30)];
        line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [header addSubview:line];
        
        UILabel *amountLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-100, 0, 100, 40)];
        amountLbl.text = @"消费金额";
        amountLbl.font = [UIFont systemFontOfSize:15];
        amountLbl.textAlignment = NSTextAlignmentCenter;
        [header addSubview:amountLbl];
        return header;
    }
    return nil;
}


#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+(self.isObjectList?52:45), SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-(self.isObjectList?52:45)) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOperationContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOperationContentCell class])];
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
        NSString *url = kGetApiWithUrl(MEIPcommonExpenseClerkRanking);
        if (self.isObjectList) {
            url = kGetApiWithUrl(MEIPcommonExpenseObjectRanking);
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:url];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        kMeWEAKSELF
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            kMeSTRONGSELF
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无员工排名";
            if (strongSelf.isObjectList) {
                failView.lblOfNodata.text = @"暂无服务项目排名";
            }
        }];
    }
    return _refresh;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, self.isObjectList?52:45)];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

@end
