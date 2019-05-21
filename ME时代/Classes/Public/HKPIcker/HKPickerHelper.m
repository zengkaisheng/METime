//
//  HKPickerHelper.m
//  HKFIleTransfer
//
//  Created by hank on 2018/11/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "HKPickerHelper.h"
#import "MEImagePickerVC.h"

@interface HKPickerHelper ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,strong)UIViewController * superVC;
@property (nonatomic,strong)NSString *fatherPath;
@end

@implementation HKPickerHelper

- (void)dealloc{
    NSLog(@"HKPickerHelper dealloc");
}

- (void)showPhotoWIthSuperVC:(UIViewController *)superVC{
//    HKPickerHelper *pickHelper =  [HKPickerHelper new];
//    self.superVC = superVC;
//    [self addMultimediaActionWithChooseImage:YES];
    MEImagePickerVC *imagePickerVc = [[MEImagePickerVC alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowPickingVideo = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (int i = 0; i < assets.count; i ++) {
            PHAsset *phAsset = assets[i];
            if (phAsset.mediaType == PHAssetMediaTypeImage) {
//                NSString *name = @"";
//                name = [phAsset valueForKey:@"filename"];
//                if(!kHankUnNilStr(name).length){
//                    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
//                    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
//                    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
//                    name = [NSString stringWithFormat:@"%@.JPG",timeString];
//                }
                UIImage *image = photos[i];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [HKFileHelper createFile:[NSString stringWithFormat:@"%@/%@",self.fatherPath,name] saveData:UIImagePNGRepresentation(image) isImage:YES];
//                });
            }
        }
    }];
    
    [superVC presentViewController:imagePickerVc animated:YES completion:nil];

}

//- (void)showPhotoWIthSuperVC:(UIViewController *)superVC{
//    MEImagePickerVC *imagePickerVc = [[MEImagePickerVC alloc] initWithMaxImagesCount:1 columnNumber:1 delegate:self pushPhotoPickerVc:YES];
//    imagePickerVc.allowPickingImage = NO;
//    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
//        PHAsset *phAsset = asset;
//        if (phAsset.mediaType == PHAssetMediaTypeVideo) {
//            NSString *name = @"";
//            if(!kHankUnNilStr(name).length){
//                NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
//                NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
//                NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
//                name = [NSString stringWithFormat:@"%@.MP4",timeString];
//            }
//
//            /// 包含该视频的基础信息
//            PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset: phAsset] firstObject];
//
//            NSLog(@"%@",resource);
//            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
//            options.version = PHImageRequestOptionsVersionCurrent;
//            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
//
//            PHImageManager *manager = [PHImageManager defaultManager];
//            [manager requestAVAssetForVideo:asset
//                                    options:options
//                              resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//                                  AVURLAsset *vedioUrlAsset = (AVURLAsset *)asset;
//                                  NSURL *vedioUrl = vedioUrlAsset.URL;
//                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                        [HKFileHelper createVideo:vedioUrl path:[NSString stringWithFormat:@"%@/%@",self.fatherPath,name]];
//                                  });
//            }];
//        }
//    }];
//
//
//    [superVC presentViewController:imagePickerVc animated:YES completion:nil];
//}

//chooseImage yes 图片 no视频
//- (void)addMultimediaActionWithChooseImage:(BOOL)chooseImage{
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction * localAction = [UIAlertAction actionWithTitle:@"本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self showPickerVC:YES chooseImage:chooseImage];
//
//    }];
//    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (![UIImagePickerController
//              isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
//        [self showPickerVC:NO chooseImage:chooseImage];
//    }];
//
//    UIAlertAction * cancalAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//
//    [alertController addAction:localAction];
//    [alertController addAction:cameraAction];
//    [alertController addAction:cancalAction];
//
//    [self.superVC presentViewController:alertController animated:YES completion:nil];
//}

//// lacol yes 本地 no 拍摄 chooseImage yes 图片 no视频
//- (void)showPickerVC:(BOOL)lacol chooseImage:(BOOL)chooseImage {
//    HANKWEAKSELF
//    [self.viewModel addImage_lacol:lacol chooseImage:chooseImage perfect:^(BOOL perfect, UIImagePickerController *PickerController, NSString *msg) {
//        if (perfect){
//            PickerController.delegate = weakSelf;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.superVC presentViewController:PickerController animated:YES completion:nil];
//            });
//        }else{
//            [weakSelf showAlertControllerStyleAlert_code:msg];
//        }
//    }];
//}
//
//- (void)showAlertControllerStyleAlert_code:(NSString *)code{
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:code preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertController addAction:okAction];
//    [self.superVC presentViewController:alertController animated:YES completion:nil];
//}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    NSLog(@"%@", info);
//    //相册返回的数据
//    //    UIImagePickerControllerEditedImage // 编辑后的UIImage
//    //    UIImagePickerControllerMediaType // 返回媒体的媒体类型
//    //    UIImagePickerControllerOriginalImage // 原始的UIImage
//    //    UIImagePickerControllerReferenceURL // 图片地址
//    //本地视频返回的数据
//    //    UIImagePickerControllerMediaType
//    //    UIImagePickerControllerMediaURL
//    //    UIImagePickerControllerReferenceURL
//    //拍摄视频返回的数据
//    //    UIImagePickerControllerMediaType
//    //    UIImagePickerControllerMediaURL
//    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if([mediaType isEqualToString:(NSString*)kUTTypeMovie]){
//        NSString *name = [info[UIImagePickerControllerMediaURL] lastPathComponent];
//        if(!kHankUnNilStr(name).length){
//            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
//            NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
//            NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
//            name = [NSString stringWithFormat:@"%@.MP4",timeString];
//        }
//        [HKFileHelper createVideo:info[UIImagePickerControllerMediaURL] path:[NSString stringWithFormat:@"%@/%@",self.fatherPath,name]];
////        [HKFileHelper createFile:[NSString stringWithFormat:@"%@/%@",self.fatherPath,name] saveImage:file];
//    }else{
//        UIImage * image = info[UIImagePickerControllerOriginalImage];//获取得到的原始图片
//        NSString *name = @"";
//        if (@available(iOS 11.0, *)) {
//            name = [info[UIImagePickerControllerImageURL] lastPathComponent];
//        }
//        if(!kHankUnNilStr(name).length){
//            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
//            NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
//            NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
//            name = [NSString stringWithFormat:@"%@.PNG",timeString];
//        }
//        NSLog(@"获取到的image == %@",image);
//        [HKFileHelper createFile:[NSString stringWithFormat:@"%@/%@",self.fatherPath,name] saveData:UIImagePNGRepresentation(image) isImage:YES];
//    }
//    [self.superVC dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (MLViewModel *)viewModel{
//    if (!_viewModel){
//        _viewModel = [[MLViewModel alloc] init];
//    }
//    return _viewModel;
//}
//
//+ (MBProgressHUD *)commitWithHUD:(NSString *)str{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: animated:YES];
//    hud.label.text = str;
//    hud.userInteractionEnabled = YES;
//    return hud;
//}

@end
