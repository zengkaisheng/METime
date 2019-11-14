//
//  MEPublicShowDetailVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublicShowDetailVC.h"
#import "MEPublicShowDetailModel.h"
#import "MEPublicShowContentCell.h"
#import "MERecruitCommentCell.h"

#import "IQKeyboardManager.h"
#import "MECommentInputView.h"
#import "MEVolunteerCommentsView.h"

@interface MEPublicShowDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger showId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEPublicShowDetailModel *model;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) MECommentInputView *inputView;

@end

@implementation MEPublicShowDetailVC

- (instancetype)initWithShowId:(NSInteger)showId {
    if (self = [super init]) {
        _showId = showId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公益秀";
    self.view.backgroundColor = [UIColor whiteColor];
    self.index = -1;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self.view addSubview:self.tableView];
    [self requestPublicShowDetailWithNetWork];
    
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.commentBtn];
    kMeWEAKSELF
    self.inputView.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (strongSelf.index == -1) {
            [strongSelf commentPublicShowWithContent:kMeUnNilStr(str)];
        }else {
            MERecruitCommentModel *model = strongSelf.model.comment[strongSelf.index];
            [strongSelf commentBackPublicShowWithContent:str commentId:[NSString stringWithFormat:@"%@",@(model.idField)]];
        }
    };
}

#pragma mark -- Networking
//公益秀详情
- (void)requestPublicShowDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetPublicShowDetailWithShowId:_showId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEPublicShowDetailModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf.tableView reloadData];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

//点赞/取消点赞
- (void)praiseShowDetail{
    [MEPublicNetWorkTool postPraiseShowWithShowId:self.model.idField status:self.model.is_praise==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            if (strongSelf.model.is_praise == 0) {
                [MECommonTool showMessage:@"点赞成功" view:kMeCurrentWindow];
                strongSelf.model.is_praise = 1;
            }else {
                [MECommonTool showMessage:@"取消点赞成功" view:kMeCurrentWindow];
                strongSelf.model.is_praise = 0;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            kMeCallBlock(self.praiseBlock,strongSelf.model.is_praise);
        }
    } failure:^(id object) {
        
    }];
}

//评论
- (void)commentPublicShowWithContent:(NSString *)content {
    [MEPublicNetWorkTool postCommentPublicShowWithShowId:[NSString stringWithFormat:@"%@",@(self.model.idField)] content:content successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            [MECommonTool showMessage:@"留言成功" view:kMeCurrentWindow];
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                MERecruitCommentModel *model = [MERecruitCommentModel mj_objectWithKeyValues:responseObject.data];
                NSMutableArray *comment = [NSMutableArray arrayWithArray:strongSelf.model.comment];
                [comment insertObject:model atIndex:0];
                strongSelf.model.comment = [comment copy];
                NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            }else {
                [strongSelf requestPublicShowDetailWithNetWork];
            }
        }
    } failure:^(id object) {
        
    }];
}
//活动留言回复
- (void)commentBackPublicShowWithContent:(NSString *)content commentId:(NSString *)commentId{
    [MEPublicNetWorkTool postCommentBackRecruitActivityWithCommentId:commentId content:content successBlock:^(ZLRequestResponse *responseObject) {
        kMeWEAKSELF
        if ([responseObject.status_code integerValue] == 200) {
            kMeSTRONGSELF
            [MECommonTool showMessage:@"回复成功" view:kMeCurrentWindow];
            [strongSelf requestPublicShowDetailWithNetWork];
        }
    } failure:^(id object) {
        
    }];
}
#pragma mark -- Action
- (void)commentBtnAction {
    if (!self.commentBtn.hidden) {
        self.commentBtn.hidden = YES;
    }
    self.index = -1;
    self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-34-20-200, SCREEN_WIDTH, 34+20);
    [self.inputView.textView.textView becomeFirstResponder];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MEPublicShowContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEPublicShowContentCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.model];
        kMeWEAKSELF
        cell.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            [strongSelf praiseShowDetail];
        };
        return cell;
    }
    MERecruitCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERecruitCommentCell class]) forIndexPath:indexPath];
    [cell setShowUIWithArray:kMeUnArr(self.model.comment)];
    kMeWEAKSELF
    cell.tapBlock = ^(NSString * str, NSInteger index) {
        kMeSTRONGSELF
        strongSelf.index = index;
        if ([str isEqualToString:@"回复"]) {
            strongSelf.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-34-20-200, SCREEN_WIDTH, 34+20);
            [strongSelf.inputView.textView.textView becomeFirstResponder];
            strongSelf.commentBtn.hidden = NO;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [MEPublicShowContentCell getCellHeightithModel:self.model];
    }
    CGFloat height = 44+8+22;
    for (MERecruitCommentModel *model in self.model.comment) {
        height += model.contentHeight;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        MEVolunteerCommentsView *commentView = [[MEVolunteerCommentsView alloc] initWithShowId:[NSString stringWithFormat:@"%@",@(self.model.idField)]];
        kMeWEAKSELF
        commentView.reloadBlock = ^{
            kMeSTRONGSELF
            [strongSelf requestPublicShowDetailWithNetWork];
        };
        [self.view addSubview:commentView];
    }
}

#pragma setter&&getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-34-20) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEPublicShowContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEPublicShowContentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERecruitCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERecruitCommentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MECommentInputView *)inputView {
    if (!_inputView) {
        _inputView = [[MECommentInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-34-20, SCREEN_WIDTH, 34+20)];
        kMeWEAKSELF
        _inputView.cancelBlock = ^{
            kMeSTRONGSELF
            strongSelf.commentBtn.hidden = NO;
//            strongSelf->_inputView.textView.textView.text = @"";
//            strongSelf->_inputView.textView.placeholderTextView.hidden = NO;
            strongSelf->_inputView.frame = CGRectMake(0, SCREEN_HEIGHT-34-20, SCREEN_WIDTH, 34+20);
        };
    }
    return _inputView;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(0, SCREEN_HEIGHT-34-20, SCREEN_WIDTH-70, 34+20);
        [_commentBtn setTitle:@"" forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

@end
