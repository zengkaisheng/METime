//
//  MEDiagnoseConsultDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseConsultDetailVC.h"
#import "MEDiagnoseConsultModel.h"

#import "METextView.h"
#import "MEBynamicPublishGridModel.h"
#import "MEBynamicPublishGridView.h"
#import <TZImagePickerController.h>
#import "YBImageBrowser.h"
#import "MEBynamicPublishGridContentView.h"

@interface MEDiagnoseConsultDetailVC ()<TZImagePickerControllerDelegate,YBImageBrowserDataSource>
{
    NSInteger _currentIndex;
    NSMutableArray *_arrImage;
    NSString *_token;
    BOOL _isError;
    BOOL _isExpert;
}

@property (nonatomic, strong) MEDiagnoseConsultModel *model;
@property (nonatomic, assign) NSInteger consultId;

@property (nonatomic, strong) METextView *textView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) MEBynamicPublishGridView *gridView;
@property (strong, nonatomic) NSMutableArray *arrModel;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation MEDiagnoseConsultDetailVC

- (instancetype)initWithModel:(MEDiagnoseConsultModel *)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (instancetype)initWithConsultId:(NSInteger )consultId {
    if (self = [super init]) {
        self.consultId = consultId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isReply) {
        self.title = @"问题回答";
    }else {
        self.title = @"问题反馈";
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FCFBFB"];
    
    if (self.consultId > 0) {
        [self requestConsultDetail];
    }else {
        if (_model) {
            [self loadUI];
        }
    }
    if (self.isReply) {
        MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
        kMeWEAKSELF
        [MEPublicNetWorkTool postgetQiuNiuTokkenWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            [HUD hideAnimated:YES];
            kMeSTRONGSELF
            strongSelf->_token = responseObject.data[@"token"];
        } failure:^(id object) {
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)reloadGridView{
    [_gridView setUIWithArr:self.arrModel];
}

- (void)loadUI {
    //问题描述
    CGFloat problemHeight = [self getLabelHeightWithContent:kMeUnNilStr(self.model.problem)];
    CGFloat problemViewHeight = [self getBGViewHeightWithContentHeight:problemHeight images:kMeUnArr(self.model.images)];
    
    UIView *problemView = [self createBGViewWithTitle:@"问题描述：" content:kMeUnNilStr(self.model.problem) contentHeight:problemHeight images:kMeUnArr(self.model.images) frame:CGRectMake(15, kMeNavBarHeight + 10, SCREEN_WIDTH-30, problemViewHeight)];
    problemView.backgroundColor = [UIColor colorWithHexString:@"#FFD5D5"];
    [self.view addSubview:problemView];
    
    //问题回答
    CGFloat answerHeight = [self getLabelHeightWithContent:kMeUnNilStr(self.model.answer)];
    CGFloat answerViewHeight = [self getBGViewHeightWithContentHeight:answerHeight images:kMeUnArr(self.model.answer_images)];
    
    if (self.isReply) {
        UIView *replyView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(problemView.frame)+20, SCREEN_WIDTH-30, 290)];
        replyView.backgroundColor = [UIColor whiteColor];
        replyView.layer.cornerRadius = 10;
        replyView.layer.borderWidth = 1.0;
        replyView.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        [self.view addSubview:replyView];
        
        [replyView addSubview:self.textView];
        [replyView addSubview:self.titleLbl];
        [replyView addSubview:self.gridView];
        
        [self reloadGridView];
        _currentIndex = 0;
        _arrImage = [NSMutableArray array];
        [self.view addSubview:self.submitBtn];
        
        UILabel *replyLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(replyView.frame)+10, 60, 21)];
        replyLbl.text = @"回复身份";
        replyLbl.font = [UIFont systemFontOfSize:15.0];
        [self.view addSubview:replyLbl];
        
        NSArray *btns;
        if (kCurrentUser.identity_type == 1) {
            btns= @[@"专家"];
            _isExpert = YES;
        }else if (kCurrentUser.identity_type == 2) {
            btns= @[@"客服"];
            _isExpert = NO;
        }else {
            btns= @[@"专家",@"客服"];
            _isExpert = YES;
        }
        for (int i = 0; i < btns.count; i++) {
            UIButton *btn = [self createBtnWithTitle:btns[i] frame:CGRectMake(90+60*i, CGRectGetMaxY(replyView.frame)+8, 55, 25) tag:100+i];
            if (i == 0) {
                btn.selected = YES;
            }
            [self.view addSubview:btn];
        }
        
    }else {
        UIView *answerView = [self createBGViewWithTitle:@"问题回答：" content:kMeUnNilStr(self.model.answer) contentHeight:answerHeight images:kMeUnArr(self.model.answer_images) frame:CGRectMake(15, CGRectGetMaxY(problemView.frame)+30, SCREEN_WIDTH-30, answerViewHeight)];
        answerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:answerView];
    }
}

#pragma mark -- Networking
- (void)requestConsultDetail {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetConsultDetailWithConsultId:[NSString stringWithFormat:@"%@",@(self.consultId)] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            strongSelf.model = [MEDiagnoseConsultModel mj_objectWithKeyValues:responseObject.data];
        }else {
            strongSelf.model = [[MEDiagnoseConsultModel alloc] init];
        }
        [strongSelf loadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)btnDidClick:(UIButton *)sender {
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == 100 || btn.tag == 101) {
                btn.selected = NO;
            }
        }
    }
    UIButton *selectedBtn = (UIButton *)sender;
    selectedBtn.selected = YES;
    if (selectedBtn.tag == 100) {
        _isExpert = YES;
    }else {
        _isExpert = NO;
    }
}

- (void)submitFeedBack{
    [self.view endEditing:YES];
    NSString *content = kMeUnNilStr(_textView.textView.text);
    if(!content.length){
        [MEShowViewTool showMessage:@"内容不能为空" view:self.view];
        return;
    }
    
    _isError = NO;
    [_arrImage removeAllObjects];
    
    kMeWEAKSELF
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    MBProgressHUD *hub =  [MEPublicNetWorkTool commitWithHUD:@"提交中"];
    dispatch_group_async(group, queue, ^{
        kMeSTRONGSELF
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        for (MEBynamicPublishGridModel *model in self.arrModel) {
            if(!model.isAdd){
                [MEPublicNetWorkTool postQiNiuUpFileWithToken:strongSelf->_token filePath:model.filePath successBlock:^(id object) {
                    NSLog(@"%@",object);
                    if([object isKindOfClass:[NSDictionary class]]){
                        [strongSelf->_arrImage addObject:kMeUnNilStr(object[@"key"])];
                    }else{
                        strongSelf->_isError = YES;
                    }
                    dispatch_semaphore_signal(semaphore);
                } failure:^(id object) {
                    strongSelf->_isError = YES;
                    [strongSelf->_arrImage addObject:@""];
                    dispatch_semaphore_signal(semaphore);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        kMeSTRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!strongSelf->_isError){
                [hub hideAnimated:YES];
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:strongSelf->_arrImage
                                                                   options:kNilOptions
                                                                     error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                             encoding:NSUTF8StringEncoding];
                
                [MEPublicNetWorkTool postReplyQuestionWithAnswer:content questionId:[NSString stringWithFormat:@"%@",@(self.model.idField)] userType:(self->_isExpert?2:1) answerImages:jsonString successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    [MEShowViewTool showMessage:@"提交成功" view:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    });
                } failure:^(id object) {
                    
                }];
            }else{
                [MEShowViewTool SHOWHUDWITHHUD:hub test:@"图片上传失败"];
            }
        });
    });
}

- (void)showPhotoWithModel:(MEBynamicPublishGridModel*)model{
    _currentIndex = model.selectIndex;
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSource = self;
    browser.currentIndex = model.selectIndex;
    [browser show];
}
#pragma ---- YBImageBrowserDataSource
- (NSInteger)numberInYBImageBrowser:(YBImageBrowser *)imageBrowser {
    return self.arrModel.count;
}
- (YBImageBrowserModel *)yBImageBrowser:(YBImageBrowser *)imageBrowser modelForCellAtIndex:(NSInteger)index {
    MEBynamicPublishGridModel *gmodel = [self.arrModel objectAtIndex:index];
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    model.image = gmodel.image;
    return model;
}
- (UIImageView *)imageViewOfTouchForImageBrowser:(YBImageBrowser *)imageBrowser {
    MEBynamicPublishGridContentView *contenView = [_gridView.arrImageView objectAtIndex:_currentIndex];
    return contenView.imageVIew;
}

- (NSMutableArray *)arrModel{
    if(!_arrModel){
        _arrModel = [NSMutableArray array];
        MEBynamicPublishGridModel *model = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
        [_arrModel addObject:model];
    }
    return _arrModel;
}

- (MEBynamicPublishGridView *)gridView{
    if(!_gridView){
        _gridView = [[MEBynamicPublishGridView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_textView.frame)+30, SCREEN_WIDTH-30-16, 0) maxCount:3];
        _gridView.backgroundColor = [UIColor whiteColor];
        kMeWEAKSELF
        _gridView.selectBlock = ^(MEBynamicPublishGridModel *model) {
            kMeSTRONGSELF
            if(model.isAdd){
                NSInteger maxIndex= 3+1 - strongSelf.arrModel.count;
                TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxIndex columnNumber:3 delegate:strongSelf pushPhotoPickerVc:YES];
                imagePicker.allowPickingOriginalPhoto = NO;
                imagePicker.allowPickingVideo = NO;
                [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
                    kMeSTRONGSELF
                    [strongSelf.arrModel removeLastObject];
                    for (int i = 0; i < assets.count; i ++) {
                        PHAsset *phAsset = assets[i];
                        if (phAsset.mediaType == PHAssetMediaTypeImage) {
                            UIImage *image = photos[i];
                            NSDictionary *info = infos[i];
                            MEBynamicPublishGridModel *model = [MEBynamicPublishGridModel modelWithImage:image isAdd:NO];
                            NSString *filename = [phAsset valueForKey:@"filename"];
                            //                            NSURL *url = [info valueForKey:@"PHImageFileURLKey"];
                            model.filePath = [MECommonTool getImagePath:image filename:filename];
                            [strongSelf.arrModel addObject:model];
                        }
                    }
                    if (assets.count < 3) {
                        BOOL isAdd = NO;
                        for (MEBynamicPublishGridModel *model in strongSelf.arrModel) {
                            if (model.isAdd) {
                                isAdd = YES;
                            }
                        }
                        if (!isAdd) {
                            MEBynamicPublishGridModel *lastmodel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
                            [strongSelf.arrModel addObject:lastmodel];
                        }
                    }
                    [strongSelf reloadGridView];
                }];
                [strongSelf presentViewController:imagePicker animated:YES completion:nil];
            }else{
                kMeSTRONGSELF
                [strongSelf showPhotoWithModel:model];
            }
        };
        _gridView.delBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            [strongSelf.arrModel removeObjectAtIndex:index];
            if (strongSelf.arrModel.count < 3) {
                BOOL isAdd = NO;
                for (MEBynamicPublishGridModel *model in strongSelf.arrModel) {
                    if (model.isAdd) {
                        isAdd = YES;
                    }
                }
                if (!isAdd) {
                    MEBynamicPublishGridModel *lastmodel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
                    [strongSelf.arrModel addObject:lastmodel];
                }
            }
            [strongSelf reloadGridView];
        };
    }
    return _gridView;
}

- (METextView *)textView{
    if(!_textView){
        _textView = [[METextView alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH-30-40, 120)];
        _textView.placeholderTextView.text = @"问题回答：";
        _textView.textView.font = kMeFont(14);
        _textView.textView.textColor = kMEblack;
    }
    return _textView;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.textView.frame)+8, 200, 13)];
        _titleLbl.text = @"点击添加图片,最多选择3张";
        _titleLbl.textColor = kME999999;
        _titleLbl.font = [UIFont systemFontOfSize:14];
    }
    return _titleLbl;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setFrame:CGRectMake(40, SCREEN_HEIGHT-42-21, SCREEN_WIDTH - 80, 42)];
        [_submitBtn setBackgroundColor:kMEPink];
        [_submitBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_submitBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:15]];
        [_submitBtn addTarget:self action:@selector(submitFeedBack) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.layer.cornerRadius = 21;
        _submitBtn.layer.shadowColor = [UIColor colorWithRed:4/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor;
        _submitBtn.layer.shadowOffset = CGSizeMake(0,3);
        _submitBtn.layer.shadowOpacity = 1;
        _submitBtn.layer.shadowRadius = 5;
    }
    return _submitBtn;
}

#pragma --- Helper
- (UIView *)createBGViewWithTitle:(NSString *)title content:(NSString *)content contentHeight:(CGFloat)contentHeight images:(NSArray *)images frame:(CGRect)frame{
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.layer.cornerRadius = 10.0;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#707070"].CGColor;
    //标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, frame.size.width-40, 21)];
    titleLbl.text = title;
    titleLbl.textColor = kME333333;
    titleLbl.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:titleLbl];
    //内容
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 46, SCREEN_WIDTH-70, contentHeight)];
    contentLbl.text = content;
    contentLbl.textColor = kME333333;
    contentLbl.font = [UIFont systemFontOfSize:15];
    contentLbl.numberOfLines = 0;
    [bgView addSubview:contentLbl];
    //图片
    if (images.count > 0) {
        CGFloat itemWith = 75;
        CGFloat itemHeight = 70;
        for (int i = 0; i < images.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(itemWith+40)*i, frame.size.height-10-itemHeight, itemWith, itemHeight)];
            kSDLoadImg(imgView, kMeUnNilStr(images[i]));
            [bgView addSubview:imgView];
        }
    }
    
    return bgView;
}

- (UIButton *)createBtnWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btn setImage:[UIImage imageNamed:@"icon_xuanzhe01"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"inc-gg"] forState:UIControlStateSelected];
    [btn setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:1];
    btn.frame = frame;
    btn.tag = tag;
    
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (CGFloat)getLabelHeightWithContent:(NSString *)content {
    CGFloat height = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    return height;
}

- (CGFloat)getBGViewHeightWithContentHeight:(CGFloat)contentHeight images:(NSArray *)images{
    CGFloat height = 15 + 21 + 10 + contentHeight + 10;
    if (images.count > 0) {
        height += 70 + 10;
    }
    return height>176?height:176;
}

@end
