//
//  MERCConversationVC.m
//  ME时代
//
//  Created by hank on 2018/9/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MERCConversationVC.h"
#import <IQKeyboardManager.h>
//#import "GroupInfoController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TVideoMessageCell.h"
#import "TFileMessageCell.h"
#import "ImageViewController.h"
#import "VideoViewController.h"
#import "FileViewController.h"

@interface MERCConversationVC ()<TChatControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) TChatController *chat;
@property (nonatomic, strong) TConversationCellData *conversation;

@end

@implementation MERCConversationVC

- (instancetype)initWIthconversationData:(TConversationCellData *)data{
    if(self = [super init]){
        self.conversation = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *tlsId =kMeUnNilStr(self.conversation.convId);
    NSLog(@"%@",tlsId);
    if(tlsId.length){
        NSDictionary *info =  [[NSUserDefaults standardUserDefaults] objectForKey:tlsId];
        if(!info){
            kMeWEAKSELF
            [MEPublicNetWorkTool postUserInfoByTlsWithTls_id:tlsId successBlock:^(ZLRequestResponse *responseObject) {
                if([responseObject.data isKindOfClass:[NSDictionary class]]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *dic = responseObject.data;
                        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:tlsId];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    });
                }
                kMeSTRONGSELF
                [strongSelf initSomeThing];
            } failure:^(id object) {
                kMeSTRONGSELF
                [strongSelf initSomeThing];
            }];
        }else{
            [self initSomeThing];
        }
    }else{
        [self initSomeThing];
    }
}

- (void)initSomeThing{
    _chat = [[TChatController alloc] init];
    _chat.conversation = _conversation;
    _chat.delegate = self;
    [self addChildViewController:_chat];
    [self.view addSubview:_chat.view];
    NSString *tlsId =kMeUnNilStr(self.conversation.convId);
    if(tlsId.length){
        NSDictionary *info =  [[NSUserDefaults standardUserDefaults] objectForKey:tlsId];
        if(!info){
            self.title = _conversation.title;
            self.parentViewController.title = _conversation.title;
        }else{
            NSString *name = kMeUnNilStr(info[@"name"]);
            self.title = name;
            self.parentViewController.title = name;
        }
    }else{
        self.title = _conversation.title;
        self.parentViewController.title = _conversation.title;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [super leftBarButtonItemPressed:nil];
    //    kNoticeReloadkUnMessage
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)chatController:(TChatController *)chatController didSelectMoreAtIndex:(NSInteger)index
{
    if(index == 0 || index == 1 || index == 2){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if(index == 0){
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            picker.navigationBar.translucent = NO;
        }
        else if(index == 1){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;
        }
        else{
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModeVideo;
            picker.videoQuality =UIImagePickerControllerQualityTypeHigh;
        }
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeData] inMode:UIDocumentPickerModeOpen];
        //        picker.edgesForExtendedLayout = UIRectEdgeNone;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)chatController:(TChatController *)chatController didSelectMessages:(NSMutableArray *)msgs atIndex:(NSInteger)index
{
    TMessageCellData *data = msgs[index];
    if([data isKindOfClass:[TImageMessageCellData class]]){
        ImageViewController *image = [[ImageViewController alloc] init];
        image.data = (TImageMessageCellData *)data;
        [self presentViewController:image animated:YES completion:nil];
    }
    else if([data isKindOfClass:[TVideoMessageCellData class]]){
        VideoViewController *video = [[VideoViewController alloc] init];
        video.data = (TVideoMessageCellData *)data;
        [self presentViewController:video animated:YES completion:nil];
    }
    else if([data isKindOfClass:[TFileMessageCellData class]]){
        FileViewController *file = [[FileViewController alloc] init];
        file.data = (TFileMessageCellData *)data;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:file];
        //[self presentViewController:nav animated:YES completion:nil];
        [self.navigationController pushViewController:file animated:YES];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation=  image.imageOrientation;
        if(imageOrientation != UIImageOrientationUp)
        {
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        [_chat sendImageMessage:image];
    }
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        [_chat sendVideoMessage:url];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [_chat sendFileMessage:url];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



@end
