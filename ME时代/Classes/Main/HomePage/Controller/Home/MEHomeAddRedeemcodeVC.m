//
//  MEHomeAddRedeemcodeVC.m
//  ME时代
//
//  Created by hank on 2019/5/17.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeAddRedeemcodeVC.h"
#import "MERedeemcodeInfoModel.h"
#import "TDWebViewCell.h"
#import "MEHomeAddRedeemcodeCell.h"
#import <TZImagePickerController.h>

const static CGFloat kMEHomeAddRedeemcodeVCBootomHeight = 67;

@interface MEHomeAddRedeemcodeVC ()<UITableViewDelegate, UITableViewDataSource,TZImagePickerControllerDelegate>{
    NSString *_imageStr;
    MERedeemcodeInfoModel *_model;
    NSString *_token;
}

@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) TDWebViewCell                  *explainWebCell;
@property (strong, nonatomic) TDWebViewCell                  *redeemInfoWebCell;

@end

@implementation MEHomeAddRedeemcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换码提交";
    _model = [MERedeemcodeInfoModel new];
    kMeWEAKSELF
    [MEPublicNetWorkTool postgetQiuNiuTokkenWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_token = responseObject.data[@"token"];
        [strongSelf requestdata];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)requestdata{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetredeemcodeInfoWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_model = [MERedeemcodeInfoModel mj_objectWithKeyValues:responseObject.data];
        [strongSelf initSomeThing];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)addAction:(UIButton *)btn{
    if(!kMeUnNilStr(_imageStr).length){
        [MEShowViewTool showMessage:@"请先上传图片" view:self.view];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetredeemcodeaddCodeWithImage:_imageStr SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id object) {
        
    }];
}

- (void)initSomeThing{
    self.title = kMeUnNilStr(_model.title);
    [self.view addSubview:self.tableView];
    UIView *viewForBottom = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kMEHomeAddRedeemcodeVCBootomHeight, SCREEN_WIDTH, kMEHomeAddRedeemcodeVCBootomHeight)];
    _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAdd.frame = CGRectMake(16, 10, SCREEN_WIDTH-32, 47);
    _btnAdd.backgroundColor = kMEPink;
    [_btnAdd setTitle:@"确定提交" forState:UIControlStateNormal];
    _btnAdd.cornerRadius =2;
    _btnAdd.clipsToBounds = YES;
    [_btnAdd addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewForBottom addSubview:_btnAdd];
    [self.view addSubview:viewForBottom];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    
    [self.explainWebCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(_model.explain)] baseURL:nil];
    [self.redeemInfoWebCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(_model.redeem_info)] baseURL:nil];
    kTDWebViewCellDidFinishLoadNotification
}

-(void)reloadWebViewHeight{
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return self.redeemInfoWebCell;
    }else if (indexPath.row == 1){
        MEHomeAddRedeemcodeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEHomeAddRedeemcodeCell class]) forIndexPath:indexPath];
        if(kMeUnNilStr(_imageStr).length){
            kSDLoadImg(cell.imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(_imageStr)));
        }
        return cell;
    }else{
        return self.explainWebCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        if(!_redeemInfoWebCell){
            return 0;
        }else{
            return [[self.redeemInfoWebCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }else if (indexPath.row == 1){
        return kMEHomeAddRedeemcodeCellHeight;
    }else{
        if(!_explainWebCell){
            return 0;
        }else{
            return [[self.explainWebCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        kMeWEAKSELF
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
        imagePicker.allowPickingOriginalPhoto = NO;
        imagePicker.allowPickingVideo = NO;
        [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
            kMeSTRONGSELF
            for (int i = 0; i < assets.count; i ++) {
                PHAsset *phAsset = assets[i];
                if (phAsset.mediaType == PHAssetMediaTypeImage) {
                    UIImage *image = photos[i];
                    //                    MEBynamicPublishGridModel *gmodel = [MEBynamicPublishGridModel modelWithImage:image isAdd:NO];
                    NSString *filename = [phAsset valueForKey:@"filename"];
                    NSString *path = [MECommonTool getImagePath:image filename:filename];
                    MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
                    [MEPublicNetWorkTool postQiNiuUpFileWithToken:strongSelf->_token filePath:path successBlock:^(id object) {
                        NSLog(@"%@",object);
                        if([object isKindOfClass:[NSDictionary class]]){
                            NSString *key = kMeUnNilStr(object[@"key"]);
                            strongSelf->_imageStr = key;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            kMeSTRONGSELF
                            [strongSelf.tableView reloadData];
                        });
                        [HUD hideAnimated:YES];
                    } failure:^(id object) {
                        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"图片上传失败"];
                    }];
                }
            }
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEHomeAddRedeemcodeVCBootomHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeAddRedeemcodeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEHomeAddRedeemcodeCell class])];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];;
    }
    return _tableView;
}
- (TDWebViewCell *)explainWebCell{
    if(!_explainWebCell){
        _explainWebCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _explainWebCell;
}

- (TDWebViewCell *)redeemInfoWebCell{
    if(!_redeemInfoWebCell){
        _redeemInfoWebCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _redeemInfoWebCell;
}
@end
