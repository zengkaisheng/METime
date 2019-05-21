//
//  MESkuBuyCell.m
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESkuBuyCell.h"
#import "MESkuByReusableView.h"
#import "MESkuBuyContentCell.h"

#import "MEEqualSpaceFlowLayout.h"
#import "MEGoodDetailModel.h"
#import "MEGoodSpecModel.h"
#import "MELoginVC.h"
//120+ch+150

const static CGFloat kMinCellWidth = 50;
#define kMinColectionHeight ( 220 * kMeFrameScaleY())

@interface MESkuBuyCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    kMeBasicBlock _selectBlock;
    BOOL _isInteral;
}
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodName;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblSelected;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblSku;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;//数量
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) MEGoodDetailModel *goodModel;
//@property (strong, nonatomic) NSArray *arrData;
@property (weak, nonatomic) IBOutlet UILabel *lblStock;

@end

@implementation MESkuBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    MEEqualSpaceFlowLayout *layout = [[MEEqualSpaceFlowLayout alloc]init];
    layout.maximumInteritemSpacing = kMESkuBuyContentCellMargin;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MESkuBuyContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MESkuBuyContentCell class])];
    [_collectionView  registerNib:[UINib nibWithNibName:NSStringFromClass([MESkuByReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MESkuByReusableView class])];
    _collectionView.collectionViewLayout = layout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
//    _collectionView.scrollEnabled = NO;

    // Initialization code
}

- (void)setUIWithModel:(MEGoodDetailModel *)goodModel isInteral:(BOOL)isInteral slectBlock:(kMeBasicBlock)slectBlock{
    _isInteral = isInteral;
    _goodModel = goodModel;
    _selectBlock = slectBlock;
    _lblGoodName.text = kMeUnNilStr(goodModel.title);
    if(kMeUnNilStr(goodModel.psmodel.spec_img).length){
        kSDLoadImg(_imgPic, kMeUnNilStr(goodModel.psmodel.spec_img));
    }else{
        kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(goodModel.images)));
    }
//    _arrData = kMeUnArr(_goodModel.spec);
    [self setSkuStrWith:_goodModel.arrSelect];
    [_collectionView reloadData];
    [self layoutIfNeeded];
}

- (void)setSkuStrWith:(NSArray *)arrSelect{
    NSMutableString *str = [NSMutableString string];
    for (int i=0; i<arrSelect.count; i++) {
        NSUInteger index = [arrSelect[i] integerValue];
        MEGoodDetailSpecModel *oldSectionModel = kMeUnArr(_goodModel.spec)[i];
        MEGoodSpecModel *ospecModel = kMeUnArr(oldSectionModel.spec_value)[index];
        [str appendFormat:@"%@",kMeUnNilStr(ospecModel.spec_value)];
    }
    _lblSku.text = str;
    if(_isInteral){
        _lblPrice.text = [NSString stringWithFormat:@"%@美豆",kMeUnNilStr(_goodModel.psmodel.integral_lines)];
    }else{
        if(_goodModel.is_seckill==1){
            _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(_goodModel.psmodel.seckill_price)];
        }else{
            _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(_goodModel.psmodel.goods_price)];
        }
    }
    _lblStock.text =[NSString stringWithFormat:@"库存:%@",kMeUnNilStr(_goodModel.psmodel.stock)];
    _goodModel.skus = str;
}

#pragma mark- CollectionView Delegate And DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return kMeUnArr(_goodModel.spec).count;
}

- (void)setSelectWithdidSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger oldSelect = [_goodModel.arrSelect[indexPath.section] integerValue];
    MEGoodDetailSpecModel *oldSectionModel = kMeUnArr(_goodModel.spec)[indexPath.section];
    MEGoodSpecModel *ospecModel = kMeUnArr(oldSectionModel.spec_value)[oldSelect];
    ospecModel.isSelect = NO;
    
    _goodModel.arrSelect[indexPath.section] = @(indexPath.row);
    
    MEGoodDetailSpecModel *sectionModel = kMeUnArr(_goodModel.spec)[indexPath.section];
    MEGoodSpecModel *specModel = kMeUnArr(sectionModel.spec_value)[indexPath.row];
    specModel.isSelect = YES;
    
    [self setSkuStrWith:_goodModel.arrSelect];
    kMeCallBlock(_selectBlock);
    [_collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     NSInteger oldSelect = [_goodModel.arrSelect[indexPath.section] integerValue];
    if(indexPath.row == oldSelect && _goodModel.psmodel){
        return;
    }
    kMeWEAKSELF

    NSMutableArray *arrSpc = [NSMutableArray array];
    NSMutableArray *arrSelectSPc = [_goodModel.arrSelect mutableCopy];
    arrSelectSPc[indexPath.section] = @(indexPath.row);
    
    [kMeUnArr(_goodModel.spec) enumerateObjectsUsingBlock:^(MEGoodDetailSpecModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {\
        NSInteger slectInSection = [arrSelectSPc[idx] integerValue];
        MEGoodSpecModel *model = kMeUnArr(obj.spec_value)[slectInSection];
        [arrSpc addObject:@(model.idField).description];
    }];
    
    NSString *str = [arrSpc componentsJoinedByString:@","];
   
    [MEPublicNetWorkTool postPriceAndStockWithGoodsId:@(_goodModel.product_id).description specIds:str ssuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_goodModel.spec_ids = str;
        MEPriceAndStockModel *model = [MEPriceAndStockModel mj_objectWithKeyValues:responseObject.data];
        strongSelf->_goodModel.psmodel = model;
        
        
        MEGoodDetailSpecModel *obj = kMeUnArr(strongSelf->_goodModel.spec)[indexPath.section];
        //老参数
        MEGoodSpecModel *oldspcmodel = kMeUnArr(obj.spec_value)[oldSelect];
        oldspcmodel.isSelect = NO;
        
        //新的参数
        MEGoodSpecModel *spcmodel = kMeUnArr(obj.spec_value)[indexPath.row];
        spcmodel.isSelect = YES;
                                            

        strongSelf->_goodModel.arrSelect = arrSelectSPc;
//        strongSelf->_goodModel.skusImage = kMeUnNilStr(oldspcmodel.spec_img);
        [strongSelf setSelectWithdidSelectItemAtIndexPath:indexPath];
    } failure:^(id object) {
        
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    MEGoodDetailSpecModel *sectionModel = kMeUnArr(_goodModel.spec)[section];
    return sectionModel.spec_value.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodDetailSpecModel *sectionModel = kMeUnArr(_goodModel.spec)[indexPath.section];
    MEGoodSpecModel *specModel = kMeUnArr(sectionModel.spec_value)[indexPath.row];
    MESkuBuyContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MESkuBuyContentCell class]) forIndexPath:indexPath];
    [cell setmodelWithStr:specModel isSelect:specModel.isSelect];
    return cell;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MEGoodDetailSpecModel *sectionModel = kMeUnArr(_goodModel.spec)[indexPath.section];
        MESkuByReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MESkuByReusableView class]) forIndexPath:indexPath];
        reusableView.lbTitle.text = kMeUnNilStr(sectionModel.spec_name);
        return reusableView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodDetailSpecModel *sectionModel = kMeUnArr(_goodModel.spec)[indexPath.section];
    MEGoodSpecModel *specModel = kMeUnArr(sectionModel.spec_value)[indexPath.row];
    NSString *str = kMeUnNilStr(specModel.spec_value);
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kMESkuBuyContentCellHeight) options:NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
    CGFloat cellw = rect.size.width>kMinCellWidth?rect.size.width:kMinCellWidth;
    
    return CGSizeMake(cellw+10, kMESkuBuyContentCellHeight);
}

// collectionView的上下左右间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kMESkuBuyContentCellMargin, kMESkuBuyContentCellMargin, kMESkuBuyContentCellMargin);
}

// 单元的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMESkuBuyContentCellMargin;
}

// 每个小单元的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMESkuBuyContentCellMargin;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, kZLSchoolSelectViewReusableViewHeight, 0, kZLSchoolSelectViewReusableViewHeight);
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, kMESkuByReusableViewHeight);
}

- (IBAction)cut:(UIButton *)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count--;
    if (count <= 0) {
        return;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
    _goodModel.buynum = count;
    kMeCallBlock(self.CutBlock,self.countLabel);
}

//加
- (IBAction)add:(UIButton *)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count++;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
    _goodModel.buynum = count;
    kMeCallBlock(self.AddBlock,self.countLabel);
}
- (IBAction)confirmAction:(UIButton *)sender {
    if(_goodModel.buynum > [_goodModel.psmodel.stock integerValue]){
        [MEShowViewTool showMessage:@"库存不足" view:self];
        return;
    }
//    if([MEUserInfoModel isLogin]){
        kMeCallBlock(self.confirmBlock);
//    }else{
//        kMeWEAKSELF
//        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
//            kMeSTRONGSELF
//            kMeCallBlock(strongSelf.confirmBlock);
//        } failHandler:nil];
//    }
}

+ (CGFloat)getCellHeigthWithModel:(id)goodModel{
    //margin + TITLE height
    CGFloat height  = 120 + 150;
    CGFloat cheight = 0;
    NSArray *arrData = @[@"补水平衡套餐"];
    if(arrData.count>0){
        NSInteger sections = (arrData.count/3) + (arrData.count%3>0?1:0);
        cheight +=sections*(kMESkuBuyContentCellHeight+kMESkuBuyContentCellMargin)+kMESkuBuyContentCellMargin;
        cheight+=kMESkuByReusableViewHeight;
    }
    return height+cheight+cheight;
}



+ (CGFloat)getCellHeigthWithdetailModel:(MEGoodDetailModel *)goodModel{
    CGFloat height  = 120 + 150;
    NSArray *arrData = goodModel.spec;//多个规格
    
    __block CGFloat sectionHeight = 0;
    [arrData enumerateObjectsUsingBlock:^(MEGoodDetailSpecModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat sectionAllcellWdith = kMESkuBuyContentCellMargin+kMESkuBuyContentCellMargin;
        NSInteger section = 1;//一个规格的类型有几行
        MEGoodDetailSpecModel *sectionModel = kMeUnArr(goodModel.spec)[idx];
        NSArray *arrDatasection = sectionModel.spec_value;//规格的类型
        for (int i=0; i<arrDatasection.count; i++) {
//            MEGoodDetailSpecModel *sectionModel = kMeUnArr(goodModel.spec)[idx];
            MEGoodSpecModel *specModel = kMeUnArr(sectionModel.spec_value)[i];
            NSString *str = kMeUnNilStr(specModel.spec_value);
            CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kMESkuBuyContentCellHeight) options:NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
            CGFloat cellW = rect.size.width>kMinCellWidth?rect.size.width:kMinCellWidth;
            sectionAllcellWdith += (cellW + 10)+kMESkuBuyContentCellMargin;
            if(sectionAllcellWdith>SCREEN_WIDTH){
                ++section;
                sectionAllcellWdith = kMESkuBuyContentCellMargin+kMESkuBuyContentCellMargin;//kMESkuBuyContentCellMargin+kMESkuBuyContentCellMargin+(rect.size.width + 10)+kMESkuBuyContentCellMargin+kMESkuBuyContentCellMargin;
            }
//            else{
//                //只有一个的情况
//                if(i == arrDatasection.count-1){
//                    ++section;
//                }
//            }
        }
        
        
        sectionHeight +=section*(kMESkuBuyContentCellHeight+kMESkuBuyContentCellMargin);
        sectionHeight+=kMESkuByReusableViewHeight;
    }];
    sectionHeight = sectionHeight>kMinColectionHeight?kMinColectionHeight:sectionHeight;
    return height + sectionHeight;
}

@end
