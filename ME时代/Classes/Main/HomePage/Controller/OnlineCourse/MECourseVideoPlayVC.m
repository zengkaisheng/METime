//
//  MECourseVideoPlayVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseVideoPlayVC.h"
#import "XMPlayer.h"
#import "AppDelegate.h"
#import "MEVideoCourseDetailCell.h"

@interface MECourseVideoPlayVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) XMPlayerView *playerView;

@end

@implementation MECourseVideoPlayVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 支持 横屏 竖屏
    AppDelegateOrientationMaskLandscape
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView quite];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    
    CGFloat palyerW = [UIScreen mainScreen].bounds.size.width;
    XMPlayerView *playerView = [[XMPlayerView alloc] init];
    playerView.frame = CGRectMake(0, 20, palyerW, 210*kMeFrameScaleY());
    playerView.playerViewType = XMPlayerViewAiqiyiVideoType;
    playerView.videoURL = [NSURL URLWithString:@"https://www.xingyi888.com/xingyi/upload/video/201806/cbc13a1ed0309138ce559dfad8de42b8ca26234c.mp4"];
//                           @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
    playerView.isAllowCyclePlay = NO;
    playerView.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:playerView];
    [playerView show];
    self.playerView = playerView;
    
    // 监听屏幕旋转方向
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationHandler)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
}

/** 隐藏状态栏 */
- (BOOL)prefersStatusBarHidden{
    return YES;
}

// 屏幕旋转处理
- (void)orientationHandler {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        PopGestureRecognizerCancel
    }else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        PopGestureRecognizerOpen
    }
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEVideoCourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVideoCourseDetailCell class]) forIndexPath:indexPath];
    cell.selectBlock = ^(NSInteger index) {
        NSLog(@"inde:%ld",index);
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

#pragma mark -- Action
- (void)bottomBtnDidClick:(UIButton *)sender {
    
}

- (UIButton *)createButtonWithTitle:(NSString *)title normalImage:(NSString *)normalImage tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#393939"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    btn.tag = tag;
    [btn addTarget:self action:@selector(bottomBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20+210*kMeFrameScaleY(), SCREEN_WIDTH, SCREEN_HEIGHT-20-210*kMeFrameScaleY()-50) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVideoCourseDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVideoCourseDetailCell class])];
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#707070"];
        [_bottomView addSubview:line];
        NSArray *btns = @[@{@"title":@"分享",@"image":@"icon_share"},@{@"title":@"收藏",@"image":@"icon_courseLike"},@{@"title":@"咨询",@"image":@"icon_consult_white"}];
        CGFloat btnHeight = 49;
        CGFloat btnWidth = 60;
        for (int i = 0; i < btns.count; i++) {
            NSDictionary *dict = btns[i];
            UIButton *btn = [self createButtonWithTitle:dict[@"title"] normalImage:dict[@"image"] tag:100+i];
            btn.frame = CGRectMake((SCREEN_WIDTH-btnWidth)/2*i, 0, btnWidth, btnHeight);
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-8, 10, 8, -10)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(12, -10, -12, 10)];
            [_bottomView addSubview:btn];
        }
    }
    return _bottomView;
}

@end
