//
//  MEEditFollowsVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEditFollowsVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MECustomerFilesInfoModel.h"
#import "MECustomerFollowTypeModel.h"
#import "MECustomerContentCell.h"

@interface MEEditFollowsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger customerId;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, assign) NSInteger type;

@end

@implementation MEEditFollowsVC

- (instancetype)initWithInfo:(NSDictionary *)info customerId:(NSInteger)customerId{
    if (self = [super init]) {
        self.title = kMeUnNilStr(info[@"title"]);
        self.type = [info[@"type"] integerValue];
        [self.dataSource addObject:info];
        self.customerId = customerId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-70);
    self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 70);
    [self.view addSubview:self.footerView];
}

- (void)addFollowDatas {
    NSDictionary *info = self.dataSource.firstObject;
    NSArray *content = info[@"content"];
    MECustomerInfoFollowModel *followModel = content.firstObject;
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    
    for (id obj in followModel.followList) {
        if ([obj isKindOfClass:[MECustomerFollowTypeModel class]]) {
            MECustomerFollowTypeModel *typeModel = (MECustomerFollowTypeModel *)obj;
            if (typeModel.isSelected) {
                [tempStr appendFormat:@"%ld,",typeModel.idField];
            }
        }else if ([obj isKindOfClass:[MEAddCustomerInfoModel class]]) {
            MEAddCustomerInfoModel *model = (MEAddCustomerInfoModel *)obj;
            if (model.value.length < 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else if ([model.title isEqualToString:@"项目"]) {
                followModel.project = model.value;
            }else if ([model.title isEqualToString:@"跟进时间"]) {
                followModel.follow_time = model.value;
            }else if ([model.title isEqualToString:@"跟进结果"]) {
                followModel.result = model.value;
            }
        }
    }
    
    NSString *followType = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postAddCustomerFollowInfoWithFileId:self.customerId project:followModel.project followTime:followModel.follow_time followType:followType result:followModel.result successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"添加跟进记录成功" view:kMeCurrentWindow];
        kMeCallBlock(strongSelf.finishBlock,followModel);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id object) {
    }];
}

- (void)editFollowDatas {
    NSDictionary *info = self.dataSource.firstObject;
    NSArray *content = info[@"content"];
    MECustomerInfoFollowModel *followModel = content.firstObject;
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    
    for (id obj in followModel.followList) {
        if ([obj isKindOfClass:[MECustomerFollowTypeModel class]]) {
            MECustomerFollowTypeModel *typeModel = (MECustomerFollowTypeModel *)obj;
            if (typeModel.isSelected) {
                [tempStr appendFormat:@"%ld,",typeModel.idField];
            }
        }else if ([obj isKindOfClass:[MEAddCustomerInfoModel class]]) {
            MEAddCustomerInfoModel *model = (MEAddCustomerInfoModel *)obj;
            if (model.value.length < 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else if ([model.title isEqualToString:@"项目"]) {
                followModel.project = model.value;
            }else if ([model.title isEqualToString:@"跟进时间"]) {
                followModel.follow_time = model.value;
            }else if ([model.title isEqualToString:@"跟进结果"]) {
                followModel.result = model.value;
            }
        }
    }
    
    NSString *followType = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
    kMeWEAKSELF
    [MEPublicNetWorkTool postEditCustomerFollowInfoWithFileId:self.customerId followId:followModel.idField project:followModel.project followTime:followModel.follow_time followType:followType result:followModel.result successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [MECommonTool showMessage:@"修改跟进记录成功" view:kMeCurrentWindow];
        kMeCallBlock(strongSelf.finishBlock,followModel);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id object) {
    }];
}

#pragma mark -- Action
- (void)bottomBtnAction {
    switch (self.type) {
        case 1:

            break;
        case 2:
            
            break;
        case 3:

            break;
        case 4:
        {
            if (self.isEdit) {
                [self editFollowDatas];
            }else {
                [self addFollowDatas];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MECustomerContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECustomerContentCell class]) forIndexPath:indexPath];
    NSDictionary *info = self.dataSource[indexPath.section];
    [cell setUIWithInfo:info isAdd:NO isEdit:YES];
    //    kMeWEAKSELF
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.dataSource[indexPath.section];
    return [MECustomerContentCell getCellHeightWithInfo:info];
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECustomerContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECustomerContentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.bottomBtn];
    }
    return _footerView;
}

- (UIButton *)bottomBtn {
    if(!_bottomBtn){
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_bottomBtn setBackgroundColor:kMEPink];
        _bottomBtn.frame = CGRectMake(40, 15, SCREEN_WIDTH-80, 40);
        _bottomBtn.layer.cornerRadius = 20.0;
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end
