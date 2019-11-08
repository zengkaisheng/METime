//
//  MEOrganizationDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOrganizationDetailVC.h"
#import "MEOrganizationDetailModel.h"

@interface MEOrganizationDetailVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBGViewConsTop;
@property (weak, nonatomic) IBOutlet UIView *topBGView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *signLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@property (weak, nonatomic) IBOutlet UIView *centerBGView;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;

@property (weak, nonatomic) IBOutlet UIView *bottomBGView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, assign) NSInteger organizationId;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UIButton *JoinBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) MEOrganizationDetailModel *model;

@end

@implementation MEOrganizationDetailVC

- (instancetype)initWithOrganizationId:(NSInteger)organizationId {
    if (self = [super init]) {
        self.organizationId = organizationId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"组织详情";
    _topBGView.layer.shadowOffset = CGSizeMake(0, 3);
    _topBGView.layer.shadowOpacity = 1;
    _topBGView.layer.shadowRadius = 6;
    _topBGView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    _topBGView.layer.masksToBounds = false;
    _topBGView.layer.cornerRadius = 14;
    _topBGView.clipsToBounds = false;
    _topBGViewConsTop.constant = kMeNavBarHeight+2;
    
    _centerBGView.layer.shadowOffset = CGSizeMake(0, 3);
    _centerBGView.layer.shadowOpacity = 1;
    _centerBGView.layer.shadowRadius = 6;
    _centerBGView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    _centerBGView.layer.masksToBounds = false;
    _centerBGView.layer.cornerRadius = 14;
    _centerBGView.clipsToBounds = false;
    
    _bottomBGView.layer.shadowOffset = CGSizeMake(0, 3);
    _bottomBGView.layer.shadowOpacity = 1;
    _bottomBGView.layer.shadowRadius = 6;
    _bottomBGView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    _bottomBGView.layer.masksToBounds = false;
    _bottomBGView.layer.cornerRadius = 14;
    _bottomBGView.clipsToBounds = false;
    
    self.textView.editable = NO;
    [self.view addSubview:self.JoinBtn];
    [self.view addSubview:self.attentionBtn];
    [self.view addSubview:self.checkBtn];
    self.checkBtn.hidden = YES;
    [self requestOrganizationDetailWithNetWork];
}

#pragma mark -- Networking
//组织详情
- (void)requestOrganizationDetailWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetOrganizationDetailWithOrganizationId:self.organizationId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEOrganizationDetailModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = [[MEOrganizationDetailModel alloc] init];
        }
        [self setUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setUI {
    kSDLoadImg(_headerPic, kMeUnNilStr(self.model.org_images));
    _nameLbl.text = kMeUnNilStr(self.model.org_name);
    _signLbl.text = kMeUnNilStr(self.model.signature).length>0?kMeUnNilStr(self.model.signature):@"Ta还没有设置签名";
    _addressLbl.text = [NSString stringWithFormat:@"%@ %@ %@",kMeUnNilStr(self.model.province),kMeUnNilStr(self.model.city),kMeUnNilStr(self.model.county)];
    _durationLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(self.model.duration)];
    _numberLbl.text = [NSString stringWithFormat:@"%@",@(self.model.volunteer_num)];
    _textView.text = kMeUnNilStr(self.model.detail);
    
    self.attentionBtn.selected = self.model.is_attention;
    self.JoinBtn.selected = self.model.is_join;
    self.checkBtn.hidden = !self.model.is_own;
    [self.checkBtn setTitle:kMeUnNilStr(self.model.status) forState:UIControlStateNormal];
}

#pragma mark -- Action
- (void)attentionBtnAction {
    kMeWEAKSELF
    [MEPublicNetWorkTool postAttentionOrganizationWithOrganizationId:self.organizationId status:self.model.is_attention==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
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

- (void)JoinBtnAction {
    kMeWEAKSELF
    [MEPublicNetWorkTool postJoinOrganizationWithOrganizationId:self.organizationId status:self.model.is_join==1?0:1 successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf.model.is_join = strongSelf.model.is_join==1?0:1;
        strongSelf.JoinBtn.selected = strongSelf.model.is_join;
        if (strongSelf.model.is_join) {
            [MECommonTool showMessage:@"加入组织成功" view:kMeCurrentWindow];
        }else {
            [MECommonTool showMessage:@"退出组织成功" view:kMeCurrentWindow];
        }
    } failure:^(id object) {
    }];
}

- (void)checkBtnAction {
    
}

#pragma mark -- Setter && Getter
- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH/2, 49)];
        _attentionBtn.backgroundColor = [UIColor whiteColor];
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionBtn setImage:[UIImage imageNamed:@"icon_organization_attention_nor"] forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor colorWithHexString:@"#2ED9A4"] forState:UIControlStateNormal];
        [_attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_attentionBtn setImage:[UIImage imageNamed:@"icon_recruit_attention_sel"] forState:UIControlStateSelected];
        [_attentionBtn setTitleColor:[UIColor colorWithHexString:@"#2ED9A4"] forState:UIControlStateSelected];
        _attentionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _attentionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_attentionBtn addTarget:self action:@selector(attentionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

- (UIButton *)JoinBtn {
    if (!_JoinBtn) {
        _JoinBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-49, SCREEN_WIDTH/2, 49)];
        _JoinBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [_JoinBtn setTitle:@"加入组织" forState:UIControlStateNormal];
        [_JoinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_JoinBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_JoinBtn setTitle:@"退出组织" forState:UIControlStateSelected];
        
        [_JoinBtn addTarget:self action:@selector(JoinBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _JoinBtn;
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _checkBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [_checkBtn setTitle:@"审核中" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_checkBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_checkBtn addTarget:self action:@selector(checkBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

@end
