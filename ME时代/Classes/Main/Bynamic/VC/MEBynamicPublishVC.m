//
//  MEBynamicPublishVC.m
//  ME时代
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBynamicPublishVC.h"
#import "MEBynamicPublishGridView.h"
#import "MEBynamicPublishGridModel.h"
#import <TZImagePickerController.h>
#import "METextView.h"
#import "YBImageBrowser.h"
#import "MEBynamicPublishGridContentView.h"

const static CGFloat MEBynamicPublishVCTextHeight = 135;

@interface MEBynamicPublishVC ()<TZImagePickerControllerDelegate,YBImageBrowserDataSource>{
    NSInteger _currentIndex;
    NSMutableArray *_arrImage;
    NSString *_token;
    BOOL _isError;
}
//@property (weak, nonatomic) IBOutlet MEBynamicPublishGridView *gridView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consGridViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (nonatomic , strong) METextView *textView;
@property (nonatomic , strong) MEBynamicPublishGridView *gridView;
@property (strong, nonatomic) NSMutableArray *arrModel;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MEBynamicPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表";
    kMeWEAKSELF
    _isError = NO;
    MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    _consTopMargin.constant = kMeNavBarHeight;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    CGFloat sheight = ((kMEBynamicPublishGridViewOneHeight*3)+(kMEBynamicPublishGridViewPadding *4));
    sheight = sheight<(SCREEN_HEIGHT-kMeNavBarHeight)?(SCREEN_HEIGHT-kMeNavBarHeight):sheight;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, sheight);
    [_scrollView addSubview:self.textView];
    [_scrollView addSubview:self.gridView];
    [self reloadGridView];
    // Do any additional setup after loading the view from its nib.
}

- (void)reloadGridView{
    [_gridView setUIWithArr:self.arrModel];
}

- (void)pushlishAction:(UIButton *)btn{
    [self.view endEditing:YES];
    NSString *content = kMeUnNilStr(_textView.textView.text);
    if(content.length == 0 && self.arrModel.count ==1){
        [MEShowViewTool showMessage:@"内容不能为空" view:self.view];
        return;
    }
    
    _isError = NO;
    [_arrImage removeAllObjects];
   
    kMeWEAKSELF
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    MBProgressHUD *hub =  [MEPublicNetWorkTool commitWithHUD:@"发表中"];
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
//                [MEPublicNetWorkTool posUploadImagesWithFile:model.image successBlock:^(ZLRequestResponse *responseObject) {
//                    [strongSelf->_arrImage addObject:kMeUnNilStr(responseObject.data[@"images_url"])];
//                    NSLog(@"---------%@",responseObject.data);
//                    NSLog(@"%@",kMeUnNilStr(responseObject.data[@"images_url"]));
//                    dispatch_semaphore_signal(semaphore);
//                } failure:^(id object) {
//                    [strongSelf->_arrImage addObject:@""];
//                    dispatch_semaphore_signal(semaphore);
//                }];
//                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
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
                [MEPublicNetWorkTool postdynamicVotingCommentWithConten:content images:jsonString successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    kMeCallBlock(strongSelf.publishSucessBlock);
                    [strongSelf.navigationController popViewControllerAnimated:YES];
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

- (NSInteger)numberInYBImageBrowser:(YBImageBrowser *)imageBrowser {
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

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setTitle:@"发表" forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnRight.backgroundColor = kMEPink;
        _btnRight.cornerRadius = 2;
        _btnRight.clipsToBounds = YES;
        _btnRight.frame = CGRectMake(0, 0, 63, 30);
        _btnRight.titleLabel.font = kMeFont(15);
        [_btnRight addTarget:self action:@selector(pushlishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

- (MEBynamicPublishGridView *)gridView{
    if(!_gridView){
        _gridView = [[MEBynamicPublishGridView alloc]initWithFrame:CGRectMake(0, MEBynamicPublishVCTextHeight, SCREEN_WIDTH, 0)];
        kMeWEAKSELF
        _gridView.selectBlock = ^(MEBynamicPublishGridModel *model) {
            kMeSTRONGSELF
            if(model.isAdd){
                NSInteger maxIndex= 10 - strongSelf.arrModel.count;
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
                    MEBynamicPublishGridModel *lastmodel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
                    [strongSelf.arrModel addObject:lastmodel];
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
            [strongSelf reloadGridView];
        };
    }
    return _gridView;
}

- (METextView *)textView{
    if(!_textView){
        _textView = [[METextView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, MEBynamicPublishVCTextHeight)];
        _textView.placeholderTextView.text = @"这一刻的想法....";
        _textView.textView.font = kMeFont(17);
        _textView.textView.textColor = kMEblack;
    }
    return _textView;
}

@end
