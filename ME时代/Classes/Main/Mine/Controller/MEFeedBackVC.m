//
//  MEFeedBackVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/17.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFeedBackVC.h"
#import "METextView.h"
#import "MEBynamicPublishGridModel.h"
#import "MEBynamicPublishGridView.h"
#import <TZImagePickerController.h>
#import "YBImageBrowser.h"
#import "MEBynamicPublishGridContentView.h"

const static CGFloat MEBynamicPublishVCTextHeight = 193;

@interface MEFeedBackVC ()<TZImagePickerControllerDelegate,YBImageBrowserDataSource>
{
    NSInteger _currentIndex;
    NSMutableArray *_arrImage;
    NSString *_token;
    BOOL _isError;
    NSInteger _type;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) METextView *textView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) MEBynamicPublishGridView *gridView;
@property (strong, nonatomic) NSMutableArray *arrModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (nonatomic, strong) UIButton *submitBtn;

@end


@implementation MEFeedBackVC

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    if (_type == 1) {
        self.title = @"问题咨询";
    }else {
        self.title = @"意见反馈";
    }
    _isError = NO;
    
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
    
    _currentIndex = 0;
    _arrImage = [NSMutableArray array];
    _consTopMargin.constant = kMeNavBarHeight;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    CGFloat sheight = ((kMEBynamicPublishGridViewOneHeight*3)+(kMEBynamicPublishGridViewPadding *4));
    sheight = sheight<(SCREEN_HEIGHT-kMeNavBarHeight)?(SCREEN_HEIGHT-kMeNavBarHeight):sheight;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, sheight);
    [_scrollView addSubview:self.textView];
    
    [_scrollView addSubview:self.titleLbl];
    [_scrollView addSubview:self.gridView];
    
    [self reloadGridView];
    
    [_scrollView addSubview:self.submitBtn];
}

- (void)reloadGridView{
    [_gridView setUIWithArr:self.arrModel];
    self.submitBtn.frame = CGRectMake(40, CGRectGetMaxY(self.gridView.frame)+36, SCREEN_WIDTH - 80, 42);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.submitBtn.frame)+36);
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
                
                if (strongSelf->_type == 1) {
                    [MEPublicNetWorkTool postConsultQuestionWithProblem:content images:jsonString successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        [MEShowViewTool showMessage:@"提交成功" view:self.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                        });
                    } failure:^(id object) {
                        
                    }];
                }else {
                    [MEPublicNetWorkTool postFeedBackWithConten:content images:jsonString successBlock:^(ZLRequestResponse *responseObject) {
                        kMeSTRONGSELF
                        [MEShowViewTool showMessage:@"提交成功" view:self.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                        });
                    } failure:^(id object) {
                        
                    }];
                }
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
    if (_type == 1) {
        return self.arrModel.count;
    }
    return self.arrModel.count -1;
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
        _gridView = [[MEBynamicPublishGridView alloc]initWithFrame:CGRectMake(8, MEBynamicPublishVCTextHeight+49, SCREEN_WIDTH-16, 0) maxCount:_type==1?3:9];
        _gridView.backgroundColor = [UIColor whiteColor];
        kMeWEAKSELF
        _gridView.selectBlock = ^(MEBynamicPublishGridModel *model) {
            kMeSTRONGSELF
            if(model.isAdd){
                NSInteger maxIndex= (strongSelf->_type==1?3:9)+1 - strongSelf.arrModel.count;
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
                    if (assets.count < (strongSelf->_type==1?3:9)) {
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
            if (strongSelf.arrModel.count < (strongSelf->_type==1?3:9)) {
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
        _textView = [[METextView alloc]initWithFrame:CGRectMake(8, 5, SCREEN_WIDTH-16, MEBynamicPublishVCTextHeight)];
        _textView.placeholderTextView.text = @"请在此输入您的宝贵意见，APP使用体验、优化建议都可以告诉我";
        if (_type == 1) {
            _textView.placeholderTextView.text = @"为了获得更好帮助，请尽可能详细描述问题~";
        }
        _textView.textView.font = kMeFont(14);
        _textView.textView.textColor = kMEblack;
    }
    return _textView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, MEBynamicPublishVCTextHeight + 21, 100, 13)];
        _titleLbl.text = @"点击添加图片";
        _titleLbl.textColor = kME999999;
        _titleLbl.font = [UIFont systemFontOfSize:14];
    }
    return _titleLbl;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setFrame:CGRectMake(40, CGRectGetMaxY(self.gridView.frame)+36, SCREEN_WIDTH - 80, 42)];
        [_submitBtn setBackgroundColor:kMEPink];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
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


@end
