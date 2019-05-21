//
//  MEBynamicHomeVC.m
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBynamicHomeVC.h"
#import "MEBynamicMainCell.h"
#import "CLInputToolbar.h"
#import "MEBynamicHomeModel.h"
#import "METhridProductDetailsVC.h"
#import "IQKeyboardManager.h"
#import "MEBynamicPublishVC.h"
#import "ALAssetsLibrary+MECategory.h"

@interface MEBynamicHomeVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate,JXCategoryViewDelegate>{
    NSInteger _comentIndex;
    NSArray *_arrType;
    //1 动态 2 每日爆款 3宣传素材
    NSInteger _type;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@end

@implementation MEBynamicHomeVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态";
    _type = 1;
     _arrType = @[@"动态",@"每日爆款",@"宣传素材"];
    if(![MEUserInfoModel isLogin]){
        
    }else{
        [self.view addSubview:self.categoryView];
        [self.view addSubview:self.tableView];
        [self.refresh addRefreshView];
        [self setTextViewToolbar];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
    if(kCurrentUser.user_type == 3 || kCurrentUser.user_type == 5){
        self.btnRight.hidden = NO;
    }else{
        self.btnRight.hidden = YES;
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}
//- (void)keyboardWillHide:(NSNotification *)notification{
//    if(self.maskView && self.inputToolbar){
//        [self.inputToolbar bounceToolbar];
//        self.maskView.hidden = YES;
//    }
//}

- (void)userLogout{
    _type = 1;
    [self.navigationController popToViewController:self animated:NO];
    [self.refresh.arrData removeAllObjects];
    self.refresh = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    self.maskView.hidden = YES;
    [self.inputToolbar bounceToolbar];
    [self.inputToolbar removeFromSuperview];
    self.inputToolbar = nil;
    [self.maskView removeFromSuperview];
    self.maskView = nil;
    [self.categoryView removeFromSuperview];
    self.categoryView = nil;
    self.btnRight.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)userLogin{
    if(kCurrentUser.user_type == 3 || kCurrentUser.user_type == 5){
        self.btnRight.hidden = NO;
    }else{
        self.btnRight.hidden = YES;
    }
    _type = 1;
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    [self setTextViewToolbar];
}
#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),@"tool":@"1",@"show_type":@(_type)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEBynamicHomeModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    NSInteger currentindex = index+1;
    if(currentindex == _type){
        return;
    }
    _type = currentindex;
    [self.refresh reload];
}
#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBynamicHomeModel *model = self.refresh.arrData[indexPath.row];
    MEBynamicMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBynamicMainCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.shareBlock = ^{
        kMeSTRONGSELF
        [strongSelf shareAction];
    };
    cell.LikeBlock = ^{
        kMeSTRONGSELF
        [strongSelf likeAction:indexPath.row];
    };
    cell.CommentBlock = ^{
        kMeSTRONGSELF
        [strongSelf commentAction:indexPath.row];
    };
    cell.delBlock = ^{
        MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除动态吗?"];
        [aler addButtonWithTitle:@"确定" block:^{
            kMeSTRONGSELF
            [strongSelf delDyWithModel:model index:indexPath.row];
        }];
        [aler addButtonWithTitle:@"取消"];
        [aler show];
    };
    cell.saveBlock = ^{
        kMeSTRONGSELF
        [strongSelf saveAllPhotoWithIndex:indexPath.row];
    };
    return cell;
}

- (void)delDyWithModel:(MEBynamicHomeModel *)model index:(NSInteger)index{
    kMeWEAKSELF
    [MEPublicNetWorkTool postdynamicDelDynamicWithdynamicId:kMeUnNilStr(model.idField) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf.refresh.arrData removeObjectAtIndex:index];
        [strongSelf.tableView reloadData];
    } failure:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBynamicHomeModel *model = self.refresh.arrData[indexPath.row];
    return [MEBynamicMainCell getCellHeightithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBynamicHomeModel *model = self.refresh.arrData[indexPath.row];
    if(model.product_id){
        METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (void)saveAllPhotoWithIndex:(NSInteger)index{
    MEBynamicHomeModel *model = self.refresh.arrData[index];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = kMeUnNilStr(model.content);
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    __block BOOL isError = NO;
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [kMeUnArr(model.images) enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL * _Nonnull stop) {
            NSURL *url = [NSURL URLWithString: urlString];
            [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
                UIImage *img;
                if(isInCache){
                    img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                }else{
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    img = [UIImage imageWithData:data];
                }
                HUD.label.text = [NSString stringWithFormat:@"正在保存第%@张",@(idx+1)];
                if(img){
                    [library saveImage:img toAlbum:kMEAppName withCompletionBlock:^(NSError *error) {
                        NSLog(@"%@",[error description]);
                        if (!error) {
                            dispatch_semaphore_signal(semaphore);
                        }else{
                            isError = YES;
                            dispatch_semaphore_signal(semaphore);
                            *stop = YES;
                        }
                    }];
                }else{
                    [MEShowViewTool showMessage:@"图片出错" view:kMeCurrentWindow];
                    dispatch_semaphore_signal(semaphore);
                }
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            if(isError){
                [[[UIAlertView alloc]initWithTitle:@"无法保存" message:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的照片" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"图片已保存至您的手机相册并复制描述" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            }
        });
    });
}


- (void)shareAction{
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    shareTool.sharWebpageUrl = MEIPShare;
    NSLog(@"%@",MEIPShare);
    shareTool.shareTitle = @"睁着眼洗的洁面慕斯,你见过吗?";
    shareTool.shareDescriptionBody = @"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
    shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
    
    [shareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession success:^(id data) {
        NSLog(@"分享成功%@",data);
        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
    } failure:^(NSError *error) {
        NSLog(@"分享失败%@",error);
        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
    }];
}

- (void)commentAction:(NSInteger)index{
    if(index>self.refresh.arrData.count){
        return;
    }
    _comentIndex = index;
    [self didTouchBtn];
}

- (void)pushlishAction:(UIButton *)btn{
    MEBynamicPublishVC *vc = [[MEBynamicPublishVC alloc]init];
    kMeWEAKSELF
    vc.publishSucessBlock = ^{
        kMeSTRONGSELF
        strongSelf->_type = 1;
        [strongSelf.categoryView selectItemAtIndex:0];
        [strongSelf.refresh reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)likeAction:(NSInteger)index{
    if(index>self.refresh.arrData.count){
        return;
    }
    MEBynamicHomeModel *model = self.refresh.arrData[index];
    kMeWEAKSELF
    [MEPublicNetWorkTool postdynamicPraiselWithdynamicId:kMeUnNilStr(model.idField) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            model.praise_over = YES;
            NSMutableArray *arrPar = [NSMutableArray array];
            MEBynamicHomepraiseModel *modelp = [[MEBynamicHomepraiseModel alloc]init];
            modelp.nick_name = kMeUnNilStr(kCurrentUser.name);
            [arrPar addObjectsFromArray:kMeUnArr(model.praise)];
            [arrPar addObject:modelp];
            model.praise = [NSArray arrayWithArray:arrPar];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    } failure:^(id object) {
        
    }];
}

-(void)didTouchBtn {
    self.maskView.hidden = NO;
    [self.inputToolbar popToolbar];
}
-(void)tapActions:(UITapGestureRecognizer *)tap {
    [self.inputToolbar bounceToolbar];
    self.maskView.hidden = YES;
}

-(void)setTextViewToolbar {
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
    
    UISwipeGestureRecognizer *recognizeru =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
    [recognizeru setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    UISwipeGestureRecognizer *recognizerd =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
    [recognizerd setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [self.maskView addGestureRecognizer:tap];
    [self.maskView addGestureRecognizer:recognizeru];
    [self.maskView addGestureRecognizer:recognizerd];
    
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    self.inputToolbar = [[CLInputToolbar alloc] init];
    self.inputToolbar.textViewMaxLine = 3;
    self.inputToolbar.fontSize = 15;
    self.inputToolbar.placeholder = @"请输入...";
    kMeWEAKSELF
    [self.inputToolbar inputToolbarSendText:^(NSString *text) {
        kMeSTRONGSELF
        NSLog(@"%@",text);
        MEBynamicHomeModel *model = strongSelf.refresh.arrData[strongSelf->_comentIndex];
        [MEPublicNetWorkTool postdynamicCommentdynamicId:kMeUnNilStr(model.idField) content:kMeUnNilStr(text) successBlock:^(ZLRequestResponse *responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MEBynamicHomecommentModel *modelc = [MEBynamicHomecommentModel new];
                modelc.nick_name = kMeUnNilStr(kCurrentUser.name);
                modelc.content = kMeUnNilStr(text);
                NSMutableArray *arrPar = [NSMutableArray array];
                [arrPar addObjectsFromArray:kMeUnArr(model.comment)];
                [arrPar addObject:modelc];
                model.comment = [NSArray arrayWithArray:arrPar];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:strongSelf->_comentIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf->_comentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
                [strongSelf.inputToolbar bounceToolbar];
                strongSelf.maskView.hidden = YES;
            });
            
        } failure:^(id object) {
            
        }];
    }];
    [self.maskView addSubview:self.inputToolbar];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBynamicMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBynamicMainCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommongetDynamicList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;

        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有动态";
        }];
    }
    return _refresh;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btnRight setTitle:@"发表" forState:UIControlStateNormal];
        [_btnRight setImage:[UIImage imageNamed:@"icon_push"] forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnRight.cornerRadius = 2;
        _btnRight.clipsToBounds = YES;
        _btnRight.frame = CGRectMake(0, 0, 30, 30);
        _btnRight.titleLabel.font = kMeFont(15);
        [_btnRight addTarget:self action:@selector(pushlishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

- (JXCategoryTitleView *)categoryView{
    if(!_categoryView){
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, kCategoryViewHeight)];
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineWidth = 55 *kMeFrameScaleX();
        lineView.indicatorLineViewColor = kMEPink;//[UIColor colorWithHexString:@"333333"];
        lineView.indicatorLineViewHeight = 2;
        _categoryView.indicators = @[lineView];
        //    self.categoryView.lineStyle = JXCategoryLineStyle_None;
        _categoryView.titles = _arrType;
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = kMEPink;//[UIColor colorWithHexString:@"333333"];
        _categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
        _categoryView.defaultSelectedIndex = 0;
    }
    return _categoryView;
}

@end
