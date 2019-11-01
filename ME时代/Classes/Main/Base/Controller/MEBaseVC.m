//
//  MEBaseVC.m
//  志愿星
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEBaseVC ()

@property (nonatomic, strong) UIButton  *backButton;

@end

@implementation MEBaseVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self.navigationItem.backBarButtonItem setCustomView:[UIView new]];
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:self.navBarHidden animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
//    [self initBackButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    if(self.navigationController.viewControllers.count == 1) {
        if(_backButton){
            [_backButton removeFromSuperview];
            _backButton = nil;
        }
    }
}

//- (void)initBackButton {
//    if([self.navigationController.viewControllers count] == 2){
//        [self.navigationController.navigationBar addSubview:self.backButton];
//    }
//}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveClickRecordsWithType:(NSString *)type params:(NSDictionary *)params {
    NSDate *date = [[NSDate alloc] init];
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [tempDic setObject:[date getNowDateFormatterString] forKey:@"created_at"];
    
    NSString *paramsStr = [NSString convertToJsonData:[tempDic copy]];
    NSMutableArray *records = [[NSMutableArray alloc] init];
    if ([kMeUserDefaults objectForKey:kMEGetClickRecord]) {
        [records addObjectsFromArray:(NSArray *)[kMeUserDefaults objectForKey:kMEGetClickRecord]];
    }
    
    [records addObject:@{@"type":kMeUnNilStr(type),@"parameter":paramsStr}];
    [kMeUserDefaults setObject:records forKey:kMEGetClickRecord];
    [kMeUserDefaults synchronize];
}

#pragma mark - Getter/Setter
//- (UIButton *)backButton {
//    if(!_backButton) {
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(0, 0, 44, 44);
//        [backButton setImage:[UIImage imageNamed:@"inc-xz"] forState:UIControlStateNormal];
//        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 0);
//        [backButton addTarget:self action:@selector(backButtonPressed)
//             forControlEvents:UIControlEventTouchUpInside];
//        _backButton = backButton;
//    }
//    return _backButton;
//}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
