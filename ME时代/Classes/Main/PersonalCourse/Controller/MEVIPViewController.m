//
//  MEVIPViewController.m
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEVIPViewController.h"
#import "MEOpenVIPView.h"
#import "MECourseVIPModel.h"

#import "MEPayStatusVC.h"
#import "MEMyVIPVC.h"
#import "MEPersionalCourseDetailVC.h"

#import "TDWebViewCell.h"
#import "MEMyCourseVIPModel.h"
#import "MECourseDetailVC.h"

@interface MEVIPViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *_order_sn;
    NSString *_order_amount;
    BOOL _isPayError;//防止跳2次错误页面
}

@property (nonatomic, strong) MEOpenVIPView *vipView;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) MECourseVIPModel *model;

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) TDWebViewCell *webCell;

@property (nonatomic, strong) MEMyCourseVIPDetailModel *vipModel;

@end

@implementation MEVIPViewController

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通VIP";
    if (self.vipModel.is_vip == 1) {
        self.title = @"续费VIP";
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.vipView];
    
//    [self requestVIPDetailWithNetWork];
    [self reloadUI];
    kMeWEAKSELF
    self.vipView.finishBlock = ^{
        kMeSTRONGSELF
        [strongSelf createVIPOrder];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WechatSuccess:) name:WX_PAY_RESULT object:nil];
}

- (instancetype)initWithVIPModel:(MEMyCourseVIPDetailModel *)model {
    if (self = [super init]) {
        self.vipModel = model;
    }
    return self;
}

- (void)reloadUI {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 146;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(self.vipModel.vip_rule)] baseURL:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        self.tableView.hidden = YES;
        
        self.vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEOpenVIPView getViewHeightWithRuleHeight:height]);
        self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, [MEOpenVIPView getViewHeightWithRuleHeight:height]);
//        [self.vipView setUIWithModel:self.model];
        [self.vipView setUIWithVIPModel:self.vipModel];
    });
}

#pragma mark -- Networking
//VIP会员课程套餐
- (void)requestVIPDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetCourseVIPDetailWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MECourseVIPModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//支付VIP
- (void)createVIPOrder {
    kMeWEAKSELF
    NSString *type = @"4";
    if (self.vipModel.vip_type == 2) {
        type = @"5";
    }
    [MEPublicNetWorkTool postCreateVIPOrderWithCourseId:[NSString stringWithFormat:@"%ld",self.vipModel.idField] orderType:type successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_order_sn = responseObject.data[@"order_sn"];
        strongSelf->_order_amount = responseObject.data[@"order_amount"];
        [MEPublicNetWorkTool postPayOnlineOrderWithOrderSn:strongSelf->_order_sn successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            PAYPRE
            strongSelf->_isPayError = NO;
            MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
            
            BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_order_amount];
            if(!isSucess){
                [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
            }
        } failure:^(id object) {
            
        }];
    } failure:^(id object) {
        
    }];
}
#pragma mark - Pay
- (void)WechatSuccess:(NSNotification *)noti{
    [self payResultWithNoti:[noti object] result:WXPAY_SUCCESSED];
}

- (void)payResultWithNoti:(NSString *)noti result:(NSString *)result{
    PAYJUDGE
    kMeWEAKSELF
    if ([noti isEqualToString:result]) {
        if(_isPayError){
            [self.navigationController popViewControllerAnimated:NO];
        }
        MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithSucessConfireBlock:^{
            kMeSTRONGSELF
            if (strongSelf.vipModel.vip_type == 1) {
                MEPersionalCourseDetailVC *vc = (MEPersionalCourseDetailVC *)[MECommonTool getClassWtihClassName:[MEPersionalCourseDetailVC class] targetVC:strongSelf];
                [vc reloadUI];
                if(vc){
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }else{
                    kMeCallBlock(strongSelf.finishBlock);
                    [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                }
            }else if (strongSelf.vipModel.vip_type == 2) {
                MECourseDetailVC *vc = (MECourseDetailVC *)[MECommonTool getClassWtihClassName:[MECourseDetailVC class] targetVC:strongSelf];
                [vc reloadData];
                if(vc){
                    [strongSelf.navigationController popToViewController:vc animated:YES];
                }else{
                    kMeCallBlock(strongSelf.finishBlock);
                    [strongSelf.navigationController popToViewController:strongSelf animated:YES];
                }
            }
        }];
        [self.navigationController pushViewController:svc animated:YES];
        NSLog(@"支付成功");
        _isPayError = NO;
    }else{
        if(!_isPayError){
            kMeWEAKSELF
            MEPayStatusVC *svc = [[MEPayStatusVC alloc]initWithFailRePayBlock:^{
                kMeSTRONGSELF
                [MEPublicNetWorkTool postPayOnlineOrderWithOrderSn:strongSelf->_order_sn successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    MEPayModel *model = [MEPayModel mj_objectWithKeyValues:responseObject.data];
                    
                    BOOL isSucess =  [LVWxPay wxPayWithPayModel:model VC:strongSelf price:strongSelf->_order_amount];
                    if(!isSucess){
                        [MEShowViewTool showMessage:@"支付错误" view:kMeCurrentWindow];
                    }
                } failure:^(id object) {
                    
                }];
            } CheckOrderBlock:^{
                kMeSTRONGSELF
                MEMyVIPVC *vc = [[MEMyVIPVC alloc]init];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }];
            [self.navigationController pushViewController:svc animated:YES];
        }
        NSLog(@"支付失败");
        _isPayError = YES;
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.webCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_webCell){
        return 0;
    }
    return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
}

#pragma mark -- setter&&getter
- (UIScrollView *)scrollerView{
    if(!_scrollerView){
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
        _scrollerView.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, [MEOpenVIPView getViewHeightWithRuleHeight:0]);
        _scrollerView.bounces = YES;
        _scrollerView.showsVerticalScrollIndicator =NO;
        _scrollerView.delegate = self;
        _scrollerView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollerView;
}

- (MEOpenVIPView *)vipView {
    if (!_vipView) {
        _vipView = [[[NSBundle mainBundle]loadNibNamed:@"MEOpenVIPView" owner:nil options:nil] lastObject];
        _vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEOpenVIPView getViewHeightWithRuleHeight:0]);
    }
    return _vipView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(73, 0, SCREEN_WIDTH-146, 100) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

@end
