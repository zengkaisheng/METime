//
//  MESkuBuyView.m
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESkuBuyView.h"
#import "MESkuBuyCell.h"
#import "MEMakeOrderVC.h"
//#import "MEProductDetailsVC.h"
#import "MEGoodDetailModel.h"
#import "MEGoodSpecModel.h"
#import "MEPriceAndStockModel.h"

@interface MESkuBuyView ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *_superView;
    CGFloat _allHeight;
    BOOL _isInteral;
}
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEGoodDetailModel *goodModel;
//@property (nonatomic, weak) UITableView *superView;
@end

@implementation MESkuBuyView

- (void)dealloc{
    NSLog(@"/*************** MESkuBuyView  delloc *******************/");
}

- (instancetype)initPurchaseViewWithFrame:(CGRect)frame serviceModel:(MEGoodDetailModel *)goodModel WithSuperView:(UIView *)superView isInteral:(BOOL)isInteral{
    if(self = [super initWithFrame:frame]){
        _isInteral = isInteral;
        _goodModel = goodModel;
        kMeWEAKSELF
        NSMutableArray *arrSpc = [NSMutableArray array];
        
        [kMeUnArr(_goodModel.spec) enumerateObjectsUsingBlock:^(MEGoodDetailSpecModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {\
            MEGoodSpecModel *model = kMeUnArr(obj.spec_value)[0];
            [arrSpc addObject:@(model.idField).description];
        }];
        NSString *str = [arrSpc componentsJoinedByString:@","];
//        获取第一个价格和库存
        [MEPublicNetWorkTool postPriceAndStockWithGoodsId:@(goodModel.product_id).description specIds:str ssuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if(strongSelf){
                strongSelf->_goodModel.spec_ids = str;
                MEPriceAndStockModel *psmodel = [MEPriceAndStockModel mj_objectWithKeyValues:responseObject.data];
                strongSelf->_goodModel.psmodel = psmodel;
                NSMutableArray *arrSpcName = [NSMutableArray array];
                [kMeUnArr(strongSelf->_goodModel.spec) enumerateObjectsUsingBlock:^(MEGoodDetailSpecModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {\
                    kMeSTRONGSELF
                    [strongSelf->_goodModel.arrSelect addObject:@(0)];
                    MEGoodSpecModel *model = kMeUnArr(obj.spec_value)[0];
                    model.isSelect = YES;
                    [arrSpcName addObject:kMeUnNilStr(model.spec_value)];
                }];
                strongSelf->_goodModel.skus = [arrSpcName componentsJoinedByString:@","];;
                
//                strongSelf->_goodModel.skusImage = kMeUnNilStr(psmodel.spec_img);
                [strongSelf setSubView];
                kMeCallBlock(strongSelf.sucessGetStoreBlock);
            }
        } failure:^(id object) {
            kMeSTRONGSELF
            kMeCallBlock(strongSelf.failGetStoreBlock);
        }];
        _superView = superView;
    }
    return self;
}

- (void)setSubView{
    [kMeCurrentWindow addSubview:self];
    [self setMaskView];
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    _allHeight = self.tableView.contentSize.height;
    //_allHeight = _allHeight>((self.height*2)/3)?((self.height*2)/3):_allHeight;
    self.tableView.frame = CGRectMake(0, -_allHeight, self.width, _allHeight);
    self.hidden = YES;
}

- (void)show{
    _superView.superview.backgroundColor = [UIColor blackColor];
    kMeWEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        kMeSTRONGSELF
        strongSelf->_superView.layer.transform = [strongSelf transform1];
    } completion:^(BOOL finished) {
        kMeSTRONGSELF
        self.hidden = NO;
        [kMeCurrentWindow addSubview:strongSelf];
        strongSelf->_allHeight = strongSelf.tableView.contentSize.height;
        //strongSelf->_allHeight = strongSelf->_allHeight>((strongSelf.height*2)/3)?((strongSelf.height*2)/3):strongSelf->_allHeight;
        
        strongSelf.tableView.frame = CGRectMake(0, strongSelf.height+strongSelf->_allHeight, strongSelf.width, strongSelf->_allHeight);
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            kMeSTRONGSELF
            strongSelf->_superView.layer.transform = [strongSelf transform2];
            CGFloat y = (strongSelf.height - strongSelf->_allHeight);
            strongSelf.maskView.alpha = 0.5;
            strongSelf.tableView.frame = CGRectMake(0, y, strongSelf.width, strongSelf->_allHeight);
        } completion:nil];
    }];
    
}

- (void)hide:(kMeBasicBlock)finishBlock{
    kMeWEAKSELF
    kMeCallBlock(_sucessGetStoreBlock);
    [UIView animateWithDuration:0.3 animations:^{
        kMeSTRONGSELF
        strongSelf->_superView.layer.transform = [strongSelf transform1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            kMeSTRONGSELF
            strongSelf->_superView.transform = CGAffineTransformIdentity;
            strongSelf.maskView.alpha = 0;
            strongSelf.tableView.frame = CGRectMake(0, strongSelf.height+strongSelf->_allHeight, strongSelf.width,strongSelf->_allHeight);
        } completion:^(BOOL finished) {
            kMeSTRONGSELF
            kMeCallBlock(finishBlock);
            [strongSelf removeFromSuperview];
            [strongSelf.layer removeAllAnimations];
        }];
    }];
}

- (void)hide{
    [self hide:nil];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MESkuBuyCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MESkuBuyCell class]) forIndexPath:indexPath];
    kMeWEAKSELF
    [cell setUIWithModel:_goodModel isInteral:_isInteral slectBlock:^() {
        //选择
        kMeSTRONGSELF
        [strongSelf.tableView reloadData];
    }];
    //确定
    cell.confirmBlock = ^{
        kMeSTRONGSELF
        [strongSelf hide:^{
            kMeCallBlock(strongSelf.confirmBlock);
        }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MESkuBuyCell getCellHeigthWithdetailModel:_goodModel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - Setter

- (void)setMaskView{
    self.maskView.alpha = 0.0;
    self.maskView.frame = self.bounds;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _maskView.userInteractionEnabled = YES;
        [_maskView addGestureRecognizer:tap];
        
    }
    return _maskView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MESkuBuyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MESkuBuyCell class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.clipsToBounds = NO;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (CATransform3D)transform1{
    CATransform3D form1 = CATransform3DIdentity;
    form1.m34 = 1.0/-900;
    form1 = CATransform3DScale(form1, 0.9, 0.9, 1);
    form1 = CATransform3DRotate(form1, 15.0 * M_PI/180.0, 1, 0, 0);
    return form1;
}

- (CATransform3D)transform2{
    CATransform3D form2 = CATransform3DIdentity;
    form2.m34 = [self transform1].m34;
    form2 = CATransform3DTranslate(form2, 0, _superView.height * (-0.02), 0);
    form2 = CATransform3DScale(form2, 0.9, 0.9, 1);
    return form2;
}


@end
