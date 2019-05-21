//
//  MERichTextVC.m
//  ME时代
//
//  Created by hank on 2019/3/29.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MERichTextVC.h"
#import "WGCommon.h"
#import "TZImagePickerController.h"
#import "MEAddGoodModel.h"

#define kEditorURL @"richText_editor"

@interface MERichTextVC ()<UITextViewDelegate,UIWebViewDelegate,KWEditorBarDelegate,KWFontStyleBarDelegate,TZImagePickerControllerDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,assign) BOOL isExitView;

@property (nonatomic,copy) NSString *tempArticleID;

@property (nonatomic,copy) NSString *tempTitle;
@property (nonatomic,copy) NSString *tempContent;

@property (nonatomic,assign) BOOL isLoadFinsh;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) KWEditorBar *toolBarView;
@property (nonatomic,strong) KWFontStyleBar *fontBar;


@property (nonatomic,assign) BOOL showHtml;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MERichTextVC

- (void)dealloc{
    @try {
        [self.toolBarView removeObserver:self forKeyPath:@"transform"];
    } @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
    } @finally {
        // Added to show finally works as well
    }
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    /// config
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolBarView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.toolBarView.delegate = self;
    [self.toolBarView addObserver:self forKeyPath:@"transform" options:
     NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
}

- (void)getHTMLText{
    [self.webView setInputEnabled:false];
    self.toolBarView.hidden = YES;
    self.fontBar.hidden = YES;
    [self.webView hiddenKeyboard];
    NSLog(@"%@",[self.webView contentHtmlText]);
    self.model.content = [self.webView contentHtmlText];
    kMeWEAKSELF
    MBProgressHUD *hub = [MEPublicNetWorkTool commitWithHUD:@"保存中"];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        kMeSTRONGSELF
        [hub hideAnimated:YES];
        kMeCallBlock(strongSelf->_finishBlcok);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    });
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"transform"]){
        CGRect fontBarFrame = self.fontBar.frame;
        fontBarFrame.origin.y = CGRectGetMaxY(self.toolBarView.frame)- KWFontBar_Height - KWEditorBar_Height;
        self.fontBar.frame = fontBarFrame;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0,kMeNavBarHeight, self.view.frame.size.width,self.view.frame.size.height - KWEditorBar_Height - kMeNavBarHeight);
}

#pragma mark -webviewdelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(kMeUnNilStr(self.model.content).length){
        [self.webView clearContentPlaceholder];
        [self.webView setupContent:self.model.content];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"NSError = %@",error);
    if([error code] == NSURLErrorCancelled){
        return;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"loadURL = %@",urlString);
    
    [self handleEvent:urlString];
    
    if ([urlString rangeOfString:@"re-state-content://"].location != NSNotFound) {
        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"re-state-content://" withString:@""];
        
        [self.fontBar updateFontBarWithButtonName:className];
        
        if ([self.webView contentText].length <= 0) {
            [self.webView showContentPlaceholder];
        }else{
            [self.webView clearContentPlaceholder];
        }
        
        if ([[className componentsSeparatedByString:@","] containsObject:@"unorderedList"]) {
            [self.webView clearContentPlaceholder];
        }
    }
    
    return YES;
}

#pragma mar - webView监听处理事件

- (void)handleEvent:(NSString *)urlString{
    if ([urlString hasPrefix:@"re-state-content://"]) {
        self.fontBar.hidden = NO;
        self.toolBarView.hidden = NO;
    }
    
    if ([urlString hasPrefix:@"re-state-title://"]) {
        self.fontBar.hidden = YES;
        self.toolBarView.hidden = YES;
    }
    
}


/**
 *  是否显示占位文字
 */
- (void)isShowPlaceholder{
    if ([self.webView contentText].length <= 0)
    {
        [self.webView showContentPlaceholder];
    }else{
        [self.webView clearContentPlaceholder];
    }
}

#pragma mark -editorbarDelegate
- (void)editorBar:(KWEditorBar *)editorBar didClickIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //显示或隐藏键盘
            if (self.toolBarView.transform.ty < 0) {
                [self.webView hiddenKeyboard];
            }else{
                [self.webView showKeyboardContent];
            }
            
        }
            break;
        case 1:{
            //回退
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('undo')"];
        }
            break;
        case 2:{
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('redo')"];
        }
            break;
        case 3:{
            //显示更多区域
            editorBar.fontButton.selected = !editorBar.fontButton.selected;
            if (editorBar.fontButton.selected) {
                [self.view addSubview:self.fontBar];
            }else{
                [self.fontBar removeFromSuperview];
            }
        }
            break;
        case 5:{
            //插入图片
            if (!self.toolBarView.keyboardButton.selected) {
                [self.webView showKeyboardContent];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showPhotos];
                });
            }else{
                [self showPhotos];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - fontbardelegate
- (void)fontBar:(KWFontStyleBar *)fontBar didClickBtn:(UIButton *)button{
    if (self.toolBarView.transform.ty>=0) {
        [self.webView showKeyboardContent];
    }
    switch (button.tag) {
        case 0:{
            //粗体
            [self.webView bold];
        }
            break;
        case 1:{//下划线
            [self.webView underline];
        }
            break;
        case 2:{//斜体
            [self.webView italic];
        }
            break;
        case 3:{//14号字体
            [self.webView setFontSize:@"2"];
        }
            break;
        case 4:{//16号字体
            [self.webView setFontSize:@"3"];
        }
            break;
        case 5:{//18号字体
            [self.webView setFontSize:@"4"];
        }
            break;
        case 6:{//左对齐
            [self.webView justifyLeft];
        }
            break;
        case 7:{//居中对齐
            [self.webView justifyCenter];
        }
            break;
        case 8:{//右对齐
            [self.webView justifyRight];
        }
            break;
        case 9:{//无序
            [self.webView unorderlist];
        }
            break;
        case 10:{
            //缩进
            button.selected = !button.selected;
            if (button.selected) {
                [self.webView indent];
            }else{
                [self.webView outdent];
            }
        }
            break;
        case 11:{
            
        }
            break;
        default:
            break;
    }
    
}

- (void)fontBarResetNormalFontSize{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView normalFontSize];
    });
}

#pragma mark -keyboard
- (void)keyBoardWillChangeFrame:(NSNotification*)notification{
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.transform =  CGAffineTransformIdentity;
            self.toolBarView.keyboardButton.selected = NO;
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
            self.toolBarView.keyboardButton.selected = YES;
            
        }];
    }
}


#pragma mark -上传图片


#pragma mark -图片选择器
- (void)showPhotos{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowPickingVideo = NO;
    kMeWEAKSELF
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        kMeSTRONGSELF
        for (int i = 0; i < assets.count; i ++) {
            PHAsset *phAsset = assets[i];
            if (phAsset.mediaType == PHAssetMediaTypeImage) {
                UIImage *image = photos[i];
                NSString *filename = [phAsset valueForKey:@"filename"];
                NSString *filePath= [MECommonTool getImagePath:image filename:filename];
                MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@"上传中"];
                [MEPublicNetWorkTool postQiNiuUpFileWithToken:strongSelf->_token filePath:filePath successBlock:^(id object) {
                    NSLog(@"%@",object);
                    kMeSTRONGSELF
                    NSString *key = kMeUnNilStr(object[@"key"]);
                    [self.webView inserImage:UIImageJPEGRepresentation(image, 0.2) key:key];
                    [strongSelf.webView inserSuccessImageKey:key imgUrl:MELoadQiniuImagesWithUrl(key)];
                    [HUD hideAnimated:YES];
                } failure:^(id object) {
                    [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"上传失败"];
                }];
               
            }
        }
    }];
     [self.webView.scrollView setContentOffset:CGPointMake(0, self.webView.scrollView.contentSize.height) animated:NO];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Setter

- (KWEditorBar *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [KWEditorBar editorBar];
        _toolBarView.frame = CGRectMake(0,SCREEN_HEIGHT - KWEditorBar_Height, self.view.frame.size.width, KWEditorBar_Height);
        _toolBarView.backgroundColor = COLOR(237, 237, 237, 1);
    }
    return _toolBarView;
}

- (KWFontStyleBar *)fontBar{
    if (!_fontBar) {
        _fontBar = [[KWFontStyleBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame) - KWFontBar_Height - KWEditorBar_Height, self.view.frame.size.width, KWFontBar_Height)];
        _fontBar.delegate = self;
        [_fontBar.heading2Item setSelected:YES];
        
    }
    return _fontBar;
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:kEditorURL                                                              ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [_webView loadHTMLString:htmlCont baseURL:baseURL];
        _webView.scrollView.bounces=NO;
        _webView.hidesInputAccessoryView = YES;
    }
    return _webView;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-20, 0, 30, 25);
        [_btnRight setTitle:@"保存" forState:UIControlStateNormal];
        _btnRight.titleLabel.font = kMeFont(14);
        [_btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(getHTMLText) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
