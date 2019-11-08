//
//  MEVolunteerInfoVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/7.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEVolunteerInfoVC.h"
#import "MEVolunteerInfoModel.h"

@interface MEVolunteerInfoVC ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *signLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConsTop;

@property (nonatomic, assign) NSInteger volunteerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) MEVolunteerInfoModel *model;

@end

@implementation MEVolunteerInfoVC

- (instancetype)initWithVolunteerId:(NSInteger)volunteerId name:(NSString *)name {
    if (self = [super init]) {
        self.volunteerId = volunteerId;
        self.name = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithFormat:@"%@的主页",kMeUnNilStr(self.name)];
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
    _bgViewConsTop.constant = kMeNavBarHeight+2;
    
    [self.view addSubview:self.praiseBtn];
    [self.view addSubview:self.attentionBtn];
    [self requestVolunteerDetailWithNetWork];
}

#pragma mark -- Networking
//志愿者详情
- (void)requestVolunteerDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetVolunteerDetailWithVolunteerId:self.volunteerId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEVolunteerInfoModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = [[MEVolunteerInfoModel alloc] init];
        }
        [self setUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setUI {
    kSDLoadImg(_headerPic, kMeUnNilStr(self.model.header_pic));
    _nameLbl.text = kMeUnNilStr(self.model.name);
    _signLbl.text = kMeUnNilStr(self.model.signature).length>0?kMeUnNilStr(self.model.signature):@"Ta还没有设置签名";
    _timeLbl.text = [NSString stringWithFormat:@"%@小时",kMeUnNilStr(self.model.duration)];
    self.praiseBtn.selected = self.model.is_praise;
    self.attentionBtn.selected = self.model.is_attention;
}

#pragma mark -- Action
- (void)praiseBtnAction {
    kMeWEAKSELF
    [MEPublicNetWorkTool postPraiseVolunteerWithVolunteerId:self.volunteerId status:self.model.is_praise==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf.model.is_praise = strongSelf.model.is_praise==1?0:1;
        strongSelf.praiseBtn.selected = strongSelf.model.is_praise;
        if (strongSelf.model.is_praise) {
            [MECommonTool showMessage:@"点赞成功" view:kMeCurrentWindow];
        }else {
            [MECommonTool showMessage:@"取消点赞成功" view:kMeCurrentWindow];
        }
    } failure:^(id object) {
    }];
}

- (void)attentionBtnAction {
    if (self.model.member_id == [kCurrentUser.uid integerValue]) {
        [MECommonTool showMessage:@"您不能关注自己" view:kMeCurrentWindow];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postAttentionVolunteerWithVolunteerId:self.volunteerId status:self.model.is_attention==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf.model.is_attention = strongSelf.model.is_attention==1?0:1;
        strongSelf.attentionBtn.selected = strongSelf.model.is_attention;
        if (strongSelf.model.is_attention) {
            [MECommonTool showMessage:@"关注成功" view:kMeCurrentWindow];
        }else {
            [MECommonTool showMessage:@"取消关注成功" view:kMeCurrentWindow];
        }
    } failure:^(id object) {
    }];
}

#pragma mark -- Setter && Getter
- (UIButton *)praiseBtn {
    if (!_praiseBtn) {
        _praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH/2, 49)];
        _praiseBtn.backgroundColor = [UIColor whiteColor];
        [_praiseBtn setTitle:@"点赞" forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_volunteer_praise_nor"] forState:UIControlStateNormal];
        [_praiseBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_praiseBtn setTitle:@"已点赞" forState:UIControlStateSelected];
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_volunteer_praise_sel"] forState:UIControlStateSelected];
        [_praiseBtn setTitleColor:[UIColor colorWithHexString:@"#2ED9A4"] forState:UIControlStateSelected];
        _praiseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _praiseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_praiseBtn addTarget:self action:@selector(praiseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseBtn;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-49, SCREEN_WIDTH/2, 49)];
        _attentionBtn.backgroundColor = [UIColor colorWithHexString:@"#35DAA7"];
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionBtn setImage:[UIImage imageNamed:@"icon_recruit_attention_white_nor"] forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_attentionBtn setImage:[UIImage imageNamed:@"icon_recruit_attention_white_nor"] forState:UIControlStateSelected];
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _attentionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _attentionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_attentionBtn addTarget:self action:@selector(attentionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}



@end
