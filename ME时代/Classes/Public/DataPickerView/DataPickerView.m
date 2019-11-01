//
//  DataPickerView.m
//  志愿星
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "DataPickerView.h"
#import "DataPickerViewCell.h"

@interface DataPickerView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIControl *background;     //背景蒙版
@property (nonatomic, strong) UIView *bgView;            //底层View
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;       //标题
@property (nonatomic, strong) UIButton *cancelBtn;       //取消按钮
@end

@implementation DataPickerView

#pragma mark - 界面初始化
- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //半透明背景蒙版
        _background = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _background.backgroundColor = [UIColor blackColor];
        _background.alpha = 0.0;
        [_background addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_background];
        
        [self setupUI];
        
        [self pushDataPicker];
    }
    return self;
}

#pragma mark -- UI
- (void)setupUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.pickerHeight ? self.pickerHeight : 208)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    //                                   colorWithHex:@"#f2f4fa"];
    [self addSubview:self.bgView];
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0, 0, self.bgView.frame.size.width, 52);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.titleLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 51, self.bgView.frame.size.width, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.titleLabel addSubview:line1];
    
    //数据
    self.tableView.frame = CGRectMake(0, 52, self.bgView.frame.size.width, self.bgView.frame.size.height - 104);
    [self.bgView addSubview:self.tableView];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.frame = CGRectMake(0, self.bgView.frame.size.height - 52, self.bgView.frame.size.width, 52);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    [self.bgView addSubview:cancelBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.frame.size.width, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.cancelBtn addSubview:line2];
}

#pragma mark -- UITableViewDelegate&&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pickerCellID"];
    DataPickerViewModel *model = self.dataSource[indexPath.row];
    [cell fullCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    for (DataPickerViewModel *model in self.dataSource) {
        model.isSelected = NO;
    }
    DataPickerViewModel *model = self.dataSource[indexPath.row];
    model.isSelected = YES;
    [self.tableView reloadData];
    kMeWEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.selectBlock) {
            weakSelf.selectBlock(model.name,model.value);
        }
        [weakSelf dismissDatePicker];
    });
}

#pragma mark --- Action
//出现
- (void)pushDataPicker {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT - (self.pickerHeight ? self.pickerHeight : 208), SCREEN_WIDTH, self.pickerHeight ? self.pickerHeight : 208);
        self.background.alpha = 0.5;
    }];
}

- (void)dismissDatePicker {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, (self.pickerHeight ? self.pickerHeight : 208));
        weakSelf.background.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.bgView removeFromSuperview];
        [weakSelf.tableView removeFromSuperview];
        [weakSelf.background removeFromSuperview];
        [weakSelf.titleLabel removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)cancelBtnClick {
    [self dismissDatePicker];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setPickerHeight:(CGFloat)pickerHeight {
    _pickerHeight = pickerHeight;
    CGRect frame = self.bgView.frame;
    frame.size.height = pickerHeight;
    frame.origin.y = SCREEN_HEIGHT - pickerHeight;
    self.bgView.frame = frame;
    
    frame = self.tableView.frame;
    frame.size.height = pickerHeight - 104;
    self.tableView.frame = frame;
    
    frame = self.cancelBtn.frame;
    frame.origin.y = pickerHeight - 52;
    self.cancelBtn.frame = frame;
}

- (void)setDataSource:(NSArray *)dataSource {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataSource.count; i++) {
        NSDictionary *dict = dataSource[i];
        DataPickerViewModel *model = [[DataPickerViewModel alloc] init];
        [model mj_setKeyValues:dict];
        model.isSelected = NO;
        [tempArray addObject:model];
    }
    _dataSource = [tempArray mutableCopy];
    [self.tableView reloadData];
}

- (void)setSelectedData:(NSString *)selectedData {
    _selectedData = selectedData;
    
    kMeWEAKSELF
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DataPickerViewModel *model = (DataPickerViewModel *)obj;
        if ([model.name isEqualToString:selectedData] || [model.value isEqualToString:selectedData]) {
            NSNumber *num = [NSNumber numberWithUnsignedInteger:idx];
            model.isSelected = YES;
            NSInteger index = [num integerValue];
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
            *stop = YES;
        }
    }];
}

#pragma mark -- getter&&setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setSeparatorColor:[UIColor lightGrayColor]];
        [_tableView registerClass:[DataPickerViewCell class] forCellReuseIdentifier:@"pickerCellID"];
    }
    return _tableView;
}

@end
