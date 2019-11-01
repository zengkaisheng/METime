//
//  MEShowGroupUserListView.m
//  志愿星
//
//  Created by gao lei on 2019/7/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEShowGroupUserListView.h"
#import "MEGroupUserListCell.h"
#import "MEGroupUserContentModel.h"

#define BGViewWidth (290*(kMeFrameScaleY()>1?kMeFrameScaleY():1))
#define BGViewHeight (405*(kMeFrameScaleY()>1?kMeFrameScaleY():1))

@interface MEShowGroupUserListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) kMeIndexBlock selectedBlock;
@property (nonatomic, copy) kMeBasicBlock cancelBlock;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation MEShowGroupUserListView

- (void)dealloc{
    NSLog(@"MEShowGroupUserListView dealloc");
}

- (instancetype)initWithArray:(NSArray *)array superView:(UIView*)superView{
    if(self = [super init]){
        self.frame = superView.bounds;
        self.dataSource = [NSArray arrayWithArray:array];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 17, BGViewWidth-26, 16)];
    titleLbl.text = @"正在拼团";
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont systemFontOfSize:17];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:titleLbl];
    
    UIView *line = [self createLineView];
    line.frame = CGRectMake(0, 50, BGViewWidth, 1);
    [self.bgView addSubview:line];
    
    UIButton *cancelBtn = [self createButtonWithImage:@"stortdel"];
    cancelBtn.frame = CGRectMake(BGViewWidth-24, 0, 24, 24);
    [self.bgView addSubview:cancelBtn];
    
    [self.bgView addSubview:self.tableView];
    
    UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, BGViewHeight-13-11, BGViewWidth-26, 11)];
    tipLbl.text = @"仅显示10个正在拼单的人";
    tipLbl.textColor = [UIColor colorWithHexString:@"#58595B"];
    tipLbl.font = [UIFont systemFontOfSize:11];
    tipLbl.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:tipLbl];
}

#pragma mark -- UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGroupUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGroupUserListCell class]) forIndexPath:indexPath];
    MEGroupUserContentModel *model = self.dataSource[indexPath.row];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.groupBlock = ^{
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.selectedBlock,indexPath.row);
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kMeCallBlock(self.selectedBlock,indexPath.row);
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hideTap:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (void)btnDidClick {
    kMeCallBlock(_cancelBlock);
    [self hide];
}

- (UIView *)createLineView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    return line;
}

- (UIButton *)createButtonWithImage:(NSString *)image  {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Settet And Getter
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.8;
        _maskView.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *gesmask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTap:)];
        //        [_maskView addGestureRecognizer:gesmask];
    }
    return _maskView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-BGViewWidth)/2, (SCREEN_HEIGHT-BGViewHeight)/2, BGViewWidth, BGViewHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
    }
    return _bgView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 51, BGViewWidth, BGViewHeight-51-35) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGroupUserListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGroupUserListCell class])];
//        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kMEf5f4f4;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

#pragma mark - Public API
+ (void)showGroupUserListViewWithArray:(NSArray *)array selectedBlock:(kMeIndexBlock)selectedBlock cancelBlock:(kMeBasicBlock)cancelBlock superView:(UIView*)superView{
    MEShowGroupUserListView *view = [[MEShowGroupUserListView alloc]initWithArray:array superView:superView];
    view.cancelBlock = cancelBlock;
    view.selectedBlock = selectedBlock;
    view.superView = superView;
    [superView addSubview:view];
}

@end
