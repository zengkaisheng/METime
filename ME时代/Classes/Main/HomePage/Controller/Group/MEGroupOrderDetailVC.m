//
//  MEGroupOrderDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/7/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupOrderDetailVC.h"
#import "MEGroupOrderDetailModel.h"

@interface MEGroupOrderDetailVC ()

@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, strong) MEGroupOrderDetailModel *model;

@end

@implementation MEGroupOrderDetailVC

- (instancetype)initWithOrderSn:(NSString *)orderSn {
    if (self = [super init]) {
        self.order_sn = orderSn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    
    [self requestNetWorkWithGroupOrderDetail];
}

#pragma mark -- networking
- (void)requestNetWorkWithGroupOrderDetail{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGroupOrderDetailWithOrderSn:kMeUnNilStr(self.order_sn) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEGroupOrderDetailModel mj_objectWithKeyValues:responseObject.data];
        }else {
            strongSelf.model = nil;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end
