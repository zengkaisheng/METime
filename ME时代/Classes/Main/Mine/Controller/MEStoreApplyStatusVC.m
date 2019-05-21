//
//  MEStoreApplyStatusVC.m
//  ME时代
//
//  Created by hank on 2019/3/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEStoreApplyStatusVC.h"
#import "MEStoreApplyModel.h"
#import "MEEnlargeTouchButton.h"
#import "MEStoreApplyVC.h"
#import "MEStoreApplyParModel.h"

@interface MEStoreApplyStatusVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblFailWhy;
@property (weak, nonatomic) IBOutlet UIButton *btnReApply;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;

@property (strong, nonatomic) MEEnlargeTouchButton *btnRight;
@end

@implementation MEStoreApplyStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审核状态";
    _consTopMargin.constant = kMeNavBarHeight +50;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnRight]];
    switch (_model.state) {
        case 1:{
            _imgPic.image = [UIImage imageNamed:@"icon_applyIng"];
            _lblStatus.text = @"提交成功，请等待管理员审核！";
            _lblFailWhy.text = kMeUnNilStr(_model.message);
        }
            break;
        case 2:{
            _imgPic.image = [UIImage imageNamed:@"icon_applySuc"];
            _lblStatus.text = @"恭喜，您的店铺审核通过了！";
            _lblFailWhy.text = kMeUnNilStr(_model.message);
        }
            break;
        case 3:
        {
            _imgPic.image = [UIImage imageNamed:@"icon_applyFail"];
            _lblStatus.text = @"抱歉，您的店铺审核未通过!";
            _lblFailWhy.text = kMeUnNilStr(_model.errot_desc);
        }
            break;
        case 4:
        {
            _imgPic.image = [UIImage imageNamed:@"icon_applyFail"];
            _lblStatus.text = @"抱歉，您的店铺已被禁用!";
            _lblFailWhy.text = kMeUnNilStr(_model.errot_desc);
        }
            break;
        default:
            break;
    }
    _btnReApply.hidden =  _model.state != 3;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)reApplyAction:(UIButton *)sender {
    MBProgressHUD *hub =  [MEPublicNetWorkTool commitWithHUD:@"获取审核数据中.."];

    MEStoreApplyVC *vc = [[MEStoreApplyVC alloc]init];
    MEStoreApplyParModel *parModel = [MEStoreApplyParModel new];
    parModel.token = kMeUnNilStr(kCurrentUser.token);
    parModel.true_name = kMeUnNilStr(_model.true_name);
    parModel.store_name = kMeUnNilStr(_model.store_name);
    parModel.name = kMeUnNilStr(_model.name);
    parModel.mobile = kMeUnNilStr(_model.mobile);
    parModel.intro = kMeUnNilStr(_model.intro);
    parModel.province = kMeUnNilStr(_model.province);
    parModel.city = kMeUnNilStr(_model.city);
    parModel.district = kMeUnNilStr(_model.district);
    parModel.address = kMeUnNilStr(_model.address);
    parModel.latitude = kMeUnNilStr(_model.latitude);
    parModel.longitude = kMeUnNilStr(_model.longitude);
    parModel.mask_img = kMeUnNilStr(_model.mask_img);
    parModel.mask_info_img = kMeUnNilStr(_model.mask_info_img);
    parModel.id_number = kMeUnNilStr(_model.id_number);
    parModel.business_images = kMeUnNilStr(_model.business_images);
    parModel.cellphone = kMeUnNilStr(_model.cellphone);
    
    
    if(kMeUnNilStr(_model.business_images_url).length){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.business_images_url]];
        UIImage *image = [UIImage imageWithData:data];
        MEBynamicPublishGridModel *business_imagesModel = [MEBynamicPublishGridModel modelWithImage:image isAdd:NO];
        business_imagesModel.filePath = [MECommonTool getNoCompressImagePath:image filename: kMeUnNilStr(_model.business_images)];
        parModel.business_imagesModel = business_imagesModel;
  
    }else{
        MEBynamicPublishGridModel *business_imagesModel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
        parModel.business_imagesModel = business_imagesModel;
    }
    
    if(kMeUnNilStr(_model.mask_img_url).length){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.mask_img_url]];
        UIImage *image = [UIImage imageWithData:data];
        MEBynamicPublishGridModel *mask_imgModel = [MEBynamicPublishGridModel modelWithImage:image isAdd:NO];
        mask_imgModel.filePath = [MECommonTool getNoCompressImagePath:image filename: kMeUnNilStr(_model.mask_img)];
        parModel.mask_imgModel = mask_imgModel;
        
    }else{
        MEBynamicPublishGridModel *mask_imgModel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
        parModel.mask_imgModel = mask_imgModel;
    }
    
    if(kMeUnNilStr(_model.mask_info_img_url).length){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.mask_info_img_url]];
        UIImage *image = [UIImage imageWithData:data];
        MEBynamicPublishGridModel *mask_info_imgModel = [MEBynamicPublishGridModel modelWithImage:image isAdd:NO];
        mask_info_imgModel.filePath = [MECommonTool getNoCompressImagePath:image filename: kMeUnNilStr(_model.mask_info_img)];
        parModel.mask_info_imgModel = mask_info_imgModel;
        
    }else{
        MEBynamicPublishGridModel *mask_info_imgModel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
        parModel.mask_info_imgModel = mask_info_imgModel;
    }
    vc.parModel = parModel;
    [hub hideAnimated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popBackAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (MEEnlargeTouchButton *)btnRight{
    MEEnlargeTouchButton *btnRight= [MEEnlargeTouchButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 70, 25);
    [btnRight setImage:[UIImage imageNamed:@"inc-xz"] forState:UIControlStateNormal];
    [btnRight setTitle:@"返回" forState:UIControlStateNormal];
    btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 26);
    btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [btnRight setTitleColor:[UIColor colorWithHexString:@"e3e3e3"] forState:UIControlStateNormal];
    btnRight.titleLabel.font = kMeFont(15);
    [btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(popBackAction) forControlEvents:UIControlEventTouchUpInside];
    return btnRight;
}

//- (void)setModel:(MEStoreApplyModel *)model{
//    _model = model;
//    //状态： 0初始状态 1待审核 2审核通过 3审核不通过 4禁用
//    switch (_model.state) {
//        case 1:{
//            _imgPic.image = [UIImage imageNamed:@"icon_applyIng"];
//            _lblStatus.text = @"提交成功，请等待管理员审核！";
//        }
//            break;
//        case 2:{
//            _imgPic.image = [UIImage imageNamed:@"icon_applySuc"];
//            _lblStatus.text = @"恭喜，您的店铺审核通过了！";
//        }
//            break;
//        case 3:
//        {
//            _imgPic.image = [UIImage imageNamed:@"icon_applyFail"];
//            _lblStatus.text = @"抱歉，您的店铺审核未通过!";
//
//        }
//            break;
//        default:
//            break;
//    }
//    _lblPhone.hidden =  _model.state != 3;
//    _btnReApply.hidden =  _model.state != 3;
//}

@end
