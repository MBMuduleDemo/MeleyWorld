//
//  LGSearchResultController.m
//  meyley
//
//  Created by Bovin on 2018/8/4.
//  Copyright © 2018年 Meyley. All rights reserved.
//  首页搜索

#import "LGSearchResultController.h"
#import "LGSearchResultNavBar.h"
#import "LGCollectionFlowLayout.h"
#import "LGSearchTopView.h"
#import "LGBrandGoodsCell.h"
#import "LGEmptyView.h"
#import "LGCategorySelectView.h"
#import "LGGoodsDetailViewController.h"
#import "LGSelectSectionModel.h"
#import "LGSelectItemModel.h"

@interface LGSearchResultController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,LGSearchTopViewDelegate,UITextFieldDelegate,LGCategorySelectDelegate>

@property (nonatomic, strong) UITextField *textfield;

@property(nonatomic , strong)NSArray *dataArry;
@property(nonatomic , strong)NSArray *brandArry;
@property(nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic, strong)LGEmptyView *emptyView;
@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic, copy) NSString *lowPrice;
@property (nonatomic, copy) NSString *highPrice;
@property (nonatomic, copy) NSString *brandIds;
@end

@implementation LGSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.lowPrice = @"";
    self.highPrice = @"";
    self.brandIds = @"";
    self.searchKey = @"latest";
    self.textfield.text = self.keywords;
    self.navigationItem.titleView = self.textfield;
    if (self.seachBrandId.length>0) {
        self.brandIds = self.seachBrandId;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(requestData)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:LGFont(16)} forState:UIControlStateNormal];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.emptyView];
    [self requestData];
}

-(void)requestData{
    [self.textfield resignFirstResponder];
    NSString *action = [NSString stringWithFormat:@"page=1&pageSize=1000&sortBy=%@&key4search=%@&startPrice=%@&endPrice=%@&brandIds=%@",self.searchKey,self.keywords,self.lowPrice,self.highPrice,self.brandIds];
    [RequestUtil withGET:@"/api/ecs/goods/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            self.emptyView.hidden = YES;
            self.dataArry = responseObject[@"result"][@"goodsList"];
            [self.collectionView reloadData];
            //品牌列表
            NSArray *tempArry = responseObject[@"result"][@"brandList"];
            NSMutableArray *brandArry = [NSMutableArray array];
            for (NSInteger i=0; i<tempArry.count; i++) {
                NSDictionary *dic = tempArry[i];
                LGSelectItemModel *model = [LGSelectItemModel mj_objectWithKeyValues:@{@"status":@"N",@"title":dic[@"brandName"],@"itemId":[NSString stringWithFormat:@"%@",dic[@"brandId"]]}];
                [brandArry addObject:model];
            }
            self.brandArry = brandArry;
        }else{
            [self.emptyView showViewWithDes:@"暂无商品"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.emptyView showViewWithDes:@"网络请求失败，请重试"];
    }];
}

-(void)selectLowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice brands:(NSString *)brandIds{
    self.lowPrice = lowPrice.length>0?lowPrice:@"";
    self.highPrice = highPrice.length>0?highPrice:@"";
    self.brandIds = brandIds.length>0?brandIds:@"";
    [self requestData];
}

#pragma mark----UITextFieldDelegate--
-(void)textFieldValueChaged:(UITextField *)textField{
    self.keywords = textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestData];
    return YES;
}

//点击“最新”、“销量”、“价格”
-(void)selectSearchKey:(NSString *)searchKey{
    self.searchKey = searchKey;
    [self requestData];
}

//点击“筛选”
-(void)selectBtnTapAction{
    LGCategorySelectView *selectView = [[LGCategorySelectView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    LGSelectSectionModel *brandModel = [LGSelectSectionModel mj_objectWithKeyValues:@{@"sectionTitle":@"品牌",@"defaultCount":@"12",@"open":@"N",@"dataArry":self.brandArry}];
    [selectView.dataArry addObject:brandModel];
    selectView.delegate = self;
    [self.view.window addSubview:selectView];
}




//返回cell的个数，默认一组
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArry.count;
}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGBrandGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    if (indexPath.item < self.dataArry.count) {
        cell.dataDic = self.dataArry[indexPath.item];
    }
    return cell;
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item < self.dataArry.count) {
        LGGoodsDetailViewController *controller = [[LGGoodsDetailViewController alloc]init];
        controller.goodsId = [NSString stringWithFormat:@"%@",self.dataArry[indexPath.row][@"goodsId"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 设置头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_W, viewPix(45));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, viewPix(10), 0);//分别为上、左、下、右
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    LGSearchTopView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewTimeBG" forIndexPath:indexPath];
    topView.backgroundColor = [UIColor whiteColor];
    topView.delegate = self;
    return topView;
}
#pragma mark-------lazy-----
- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_W-120, 32)];
        _textfield.borderStyle = UITextBorderStyleRoundedRect;
        _textfield.placeholder = @"搜索关键字";
        _textfield.font = LGFont(14);
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewPix(30), 44-viewPix(10))];
        UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
        searchIcon.center = CGPointMake(leftView.center.x+viewPix(5), leftView.center.y);
        [leftView addSubview:searchIcon];
        _textfield.leftView = leftView;
        _textfield.leftViewMode = UITextFieldViewModeAlways;
        _textfield.tintColor = ML_MAIN_COLOR;
        _textfield.returnKeyType = UIReturnKeySearch;
        _textfield.delegate = self;
        [_textfield addTarget:self action:@selector(textFieldValueChaged:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _textfield;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建layer层
        LGCollectionFlowLayout *layout = [[LGCollectionFlowLayout alloc] init];
        //设置同行之间cell的间隙
        layout.minimumInteritemSpacing = viewPix(10);
        //设置两行之间的间隙
        layout.minimumLineSpacing = 0;
        layout.navHeight = 0;
        //设置cell的宽高
        layout.itemSize = CGSizeMake((Screen_W-viewPix(10))/2.0, viewPix(248));
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //创建UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight) collectionViewLayout:layout];
        //滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        //设置背景
        _collectionView.backgroundColor = RGB(245, 245, 245);
        //设置是否可以滚动
        _collectionView.scrollEnabled = YES;
        // 取消弹簧效果
        _collectionView.bounces = YES;
        //代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //注册cell   ->代码cell
        [self.collectionView registerClass:[LGBrandGoodsCell class] forCellWithReuseIdentifier:@"goodsCell"];
        //创建头部视图
        [self.collectionView registerClass:[LGSearchTopView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewTimeBG"];
    }
    return _collectionView ;
}


-(LGEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[LGEmptyView alloc]initWithFrame:CGRectMake(0, viewPix(45), Screen_W, Screen_H-topBarHeight-viewPix(45))];
        _emptyView.backgroundColor = RGB(245, 245, 245);
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
