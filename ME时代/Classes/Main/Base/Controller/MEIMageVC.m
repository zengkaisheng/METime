//
//  MEIMageVC.m
//  ME时代
//
//  Created by hank on 2018/9/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEIMageVC.h"
#import "MEImageCell.h"

@interface MEIMageVC ()<UITableViewDelegate,UITableViewDataSource>{
    MEMainStyle _type;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MEIMageVC

- (instancetype)initWithType:(MEMainStyle)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_type == MEMainStoreStyle){
        return 40;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEImageCell class]) forIndexPath:indexPath];
    if(_type == MEMainStoreStyle){
        NSString *str = [NSString stringWithFormat:@"http://images.meshidai.com/store1_%02ld-min.png",indexPath.row+1];
        kSDLoadImg(cell.imagePic, str);
    }else{
         kSDLoadImg(cell.imagePic, @"http://images.meshidai.com/vvip-min.png");
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_type == MEMainStoreStyle){
        return MEImageCellHeight;
    }else{
        return MEImageMenberCellHeight;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEImageCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
@end
