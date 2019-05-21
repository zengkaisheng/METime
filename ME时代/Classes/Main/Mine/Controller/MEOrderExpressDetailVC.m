//
//  MEOrderExpressDetailVC.m
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEOrderExpressDetailVC.h"
#import "MEOrderExpressDetailCell.h"
#import "MEOrderDetailModel.h"
#import "ZLWebVC.h"

@interface MEOrderExpressDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    MEOrderDetailModel *_model;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MEOrderExpressDetailVC

- (instancetype)initWithModel:(MEOrderDetailModel *)mode{
    if(self = [super init]){
        _model = mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kMeUnArr(_model.express_detail).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEexpressDetailModel *model = kMeUnArr(_model.express_detail)[indexPath.row];
    MEOrderExpressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEOrderExpressDetailCell class]) forIndexPath:indexPath];
    [cell setUIWIthModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEexpressDetailModel *model = kMeUnArr(_model.express_detail)[indexPath.row];
    return [MEOrderExpressDetailCell getCellHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEexpressDetailModel *model = kMeUnArr(_model.express_detail)[indexPath.row];
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)kMeUnNilStr(model.express_url),(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    ZLWebVC *vc = [[ZLWebVC alloc]initWithUrl:encodedString];
    vc.title = @"物流信息";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEOrderExpressDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEOrderExpressDetailCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMEf4f4f4;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 40)];
        view.backgroundColor = [UIColor colorWithHexString:@"FEDEC3"];
        lbl.text = [NSString stringWithFormat:@"%@个包裹已发出",@(kMeUnArr(_model.express_detail).count).description];
        lbl.font = kMeFont(15);
        lbl.textColor =  [UIColor colorWithHexString:@"EEB55C"];
        [view addSubview:lbl];
        
        UILabel *lblAll = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
        lblAll.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        lblAll.textColor =  [UIColor colorWithHexString:@"666666"];
        lblAll.text = [NSString stringWithFormat:@"以下商品被拆成%@个包裹",@(kMeUnArr(_model.express_detail).count).description];
        lblAll.font = kMeFont(15);
        lblAll.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lblAll];
        _tableView.tableHeaderView = view;
    }
    return _tableView;
}


@end
