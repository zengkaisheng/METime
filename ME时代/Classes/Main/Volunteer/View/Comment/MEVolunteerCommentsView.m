//
//  MEVolunteerCommentsView.m
//  ME时代
//
//  Created by gao lei on 2019/11/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEVolunteerCommentsView.h"
#import "MERecruitDetailModel.h"
#import "MEVolunteerCommentCell.h"
#import "MECommentInputView.h"

@interface MEVolunteerCommentsView ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UIControl *background;     //背景蒙版
@property (nonatomic, strong) UIView *bgView;            //底层View
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;
@property (nonatomic, strong) MECommentInputView *inputView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *showId;

@end

@implementation MEVolunteerCommentsView

- (void)dealloc{
    NSLog(@"MEVolunteerCommentsView dealloc");
}

#pragma mark - 界面初始化
- (instancetype)initWithActivityId:(NSString *)activityId {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        //半透明背景蒙版
        _background = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _background.backgroundColor = [UIColor blackColor];
        _background.alpha = 0.0;
        [_background addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_background];
        self.index = -1;
        self.activityId = activityId;
        
        [self setupUI];
        
        [self pushView];
    }
    return self;
}

- (instancetype)initWithShowId:(NSString *)showId {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        //半透明背景蒙版
        _background = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _background.backgroundColor = [UIColor blackColor];
        _background.alpha = 0.0;
        [_background addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_background];
        self.index = -1;
        self.showId = showId;
        
        [self setupUI];
        
        [self pushView];
    }
    return self;
}

#pragma mark -- UI
- (void)setupUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.viewHeight ? self.viewHeight : 496)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 14;
    [self addSubview:self.bgView];
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(19, 16, 70, 22);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = kMeUnNilStr(self.showId).length>0?@"评论":@"留言咨询";
    titleLabel.textColor = [UIColor blackColor];
    [self.bgView addSubview:titleLabel];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.frame = CGRectMake(self.frame.size.width-24-56, 8, 56, 28);
    [cancelBtn setImage:[UIImage imageNamed:@"icon_downArrow"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancelBtn];
    
    //数据
    self.tableView.frame = CGRectMake(0, 44, self.bgView.frame.size.width, self.bgView.frame.size.height-44-19-34-10);
    [self.bgView addSubview:self.tableView];
    [self.refresh addRefreshView];
    [self.bgView addSubview:self.inputView];
    [self.bgView addSubview:self.commentBtn];
    kMeWEAKSELF
    self.inputView.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (strongSelf.index == -1) {
            //            NSLog(@"留言");
            if (kMeUnNilStr(self.showId).length>0) {
                [strongSelf commentPublicShowWithContent:kMeUnNilStr(str)];
            }else {
                [strongSelf commentRecruitActivityWithContent:kMeUnNilStr(str)];
            }
        }else {
            MERecruitCommentModel *model = strongSelf.refresh.arrData[strongSelf.index];
            [strongSelf commentBackRecruitActivityWithContent:str commentId:[NSString stringWithFormat:@"%@",@(model.idField)]];
//            NSLog(@"回复:%@",model.name);
        }
    };
}

//招募活动留言
- (void)commentRecruitActivityWithContent:(NSString *)content {
    [MEPublicNetWorkTool postCommentRecruitActivityWithActivityId:kMeUnNilStr(self.activityId) content:content successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            [MECommonTool showMessage:@"留言成功" view:kMeCurrentWindow];
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                MERecruitCommentModel *model = [MERecruitCommentModel mj_objectWithKeyValues:responseObject.data];
                [strongSelf.refresh.arrData insertObject:model atIndex:0];
                [strongSelf.tableView reloadData];
            }else {
                [strongSelf.refresh reload];
            }
            kMeCallBlock(strongSelf.reloadBlock);
        }
    } failure:^(id object) {
        
    }];
}
//活动留言回复
- (void)commentBackRecruitActivityWithContent:(NSString *)content commentId:(NSString *)commentId{
    [MEPublicNetWorkTool postCommentBackRecruitActivityWithCommentId:commentId content:content successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            [MECommonTool showMessage:@"回复成功" view:kMeCurrentWindow];
            [strongSelf.refresh reload];
            kMeCallBlock(strongSelf.reloadBlock);
        }
    } failure:^(id object) {
        
    }];
}

//公益秀评论
- (void)commentPublicShowWithContent:(NSString *)content {
    [MEPublicNetWorkTool postCommentPublicShowWithShowId:kMeUnNilStr(self.showId) content:content successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            [MECommonTool showMessage:@"留言成功" view:kMeCurrentWindow];
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                MERecruitCommentModel *model = [MERecruitCommentModel mj_objectWithKeyValues:responseObject.data];
                [strongSelf.refresh.arrData insertObject:model atIndex:0];
                [strongSelf.tableView reloadData];
            }else {
                [strongSelf.refresh reload];
            }
            kMeCallBlock(strongSelf.reloadBlock);
        }
    } failure:^(id object) {
        
    }];
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if (kMeUnNilStr(self.showId).length>0) {
        return @{@"token":kMeUnNilStr(kCurrentUser.token),
                 @"id":kMeUnNilStr(self.showId)
                 };
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token),
             @"activity_id":kMeUnNilStr(self.activityId)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MERecruitCommentModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEVolunteerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEVolunteerCommentCell class]) forIndexPath:indexPath];
    MERecruitCommentModel *model = self.refresh.arrData[indexPath.row];
    kMeWEAKSELF
    cell.answerBlock = ^(NSString *str) {
        kMeSTRONGSELF
//        NSLog(@"str:%@",str);
//        kMeCallBlock(strongSelf->_tapBlock,str,indexPath.row);
        strongSelf.index = indexPath.row;
        [strongSelf.inputView.textView.textView becomeFirstResponder];
        strongSelf.commentBtn.hidden = NO;
    };
    [cell setListUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MERecruitCommentModel *model = self.refresh.arrData[indexPath.row];
    return model.contentHeight;
}

#pragma mark --- Action
- (void)commentBtnAction {
    if (!self.commentBtn.hidden) {
        self.commentBtn.hidden = YES;
    }
    self.index = -1;
    [self.inputView.textView.textView becomeFirstResponder];
}
//出现
- (void)pushView {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT - (self.viewHeight ? self.viewHeight : 496), SCREEN_WIDTH, self.viewHeight ? self.viewHeight : 496);
        self.background.alpha = 0.1;
    }];
}

- (void)dismissDatePicker {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, (self.viewHeight ? self.viewHeight : 496));
        weakSelf.background.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.bgView removeFromSuperview];
        [weakSelf.tableView removeFromSuperview];
        [weakSelf.background removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)cancelBtnClick {
    [self dismissDatePicker];
}

- (void)setViewHeight:(CGFloat)viewHeight {
    _viewHeight = viewHeight;
    CGRect frame = self.bgView.frame;
    frame.size.height = viewHeight;
    frame.origin.y = SCREEN_HEIGHT - viewHeight;
    self.bgView.frame = frame;
    
    frame = self.tableView.frame;
    frame.size.height = viewHeight-44-19-34-10;
    self.tableView.frame = frame;
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEVolunteerCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEVolunteerCommentCell class])];
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
        NSString *url = kGetApiWithUrl(MEIPcommonRecruitActivityComment);
        if (kMeUnNilStr(self.showId).length>0) {
            url = kGetApiWithUrl(MEIPcommonUsefulactivityCommentList);
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:url];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        kMeWEAKSELF
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            kMeSTRONGSELF
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关留言";
            if (kMeUnNilStr(strongSelf.showId).length>0) {
                failView.lblOfNodata.text = @"暂无相关评论";
            }
        }];
    }
    return _refresh;
}

- (MECommentInputView *)inputView {
    if (!_inputView) {
        _inputView = [[MECommentInputView alloc] initWithFrame:CGRectMake(0, self.bgView.frame.size.height-34-20, self.bgView.frame.size.width, 34+20)];
        kMeWEAKSELF
        _inputView.cancelBlock = ^{
            kMeSTRONGSELF
            strongSelf.commentBtn.hidden = NO;
//            strongSelf->_inputView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 34+20);
        };
    }
    return _inputView;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(0, self.bgView.frame.size.height-34-20, self.bgView.frame.size.width-70, 34+20);
        [_commentBtn setTitle:@"" forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

@end
