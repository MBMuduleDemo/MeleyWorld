//
//  ShopDetailsViewController.m
//  haoshuimian365
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 CZJ. All rights reserved.
//

#import "LGGoodsDetailViewController.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYAutoHeader.h"
#import <WebKit/WebKit.h>

#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"

#import "MLServiceCenterViewController.h"
//店铺
#import "LGBrandDetailViewController.h"
#import "LGGoodsDetailTopView.h"
#import "LGGoodsDetailTitleView.h"
#import "LGGoodsDetailAttrHeadView.h"
#import "LGGoodsDetailTotalPriceView.h"
#import "LGGoodsDetailBottomView.h"
#import "LGGoodsDetailCategoryCell.h"
#import "LGGoodsDetailShopView.h"
#import "LGGoodsDetailDesView.h"
#import "LGGoodsCategoryModel.h"
//货源
#import "LGGoodsDetailResourceView.h"
//购物车
#import "MLTreastureViewController.h"
//登录
#import "HXSLoginViewController.h"
//发布评论
#import "HXSCommunityPostingViewController.h"
//webView
#import "LGGoodsDetailWebViewController.h"

#define topWidth 80 //商品、详情按钮的宽度
#define baseHeight (Screen_H - viewPix(50)-bottomSafeBarHeight/2.0)

@interface LGGoodsDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,LGGoodsDetailCategoryDelegate,LGGoodsDetailTotalPriceViewDelegate,LGGoodsDetailResourceDelegate>

/**  头部切换 */
@property (nonatomic , strong)UIView *normalView;
/**   */
@property (nonatomic , strong)UILabel *detailLabel;
/**   */
@property (nonatomic , strong)UIView *lineView;
/**   */
@property (nonatomic , strong)UIButton *shopBtn;
/**   */
@property (nonatomic , strong)UIButton *detailBtn;
/**  base */
@property (nonatomic , strong)UIScrollView *baseScrollView;
/**  商品 */
@property (nonatomic , strong)UITableView *myTableView;
/**  详情 */
@property (nonatomic , strong)UIScrollView *webScrollView;
/**   */
@property (nonatomic , strong)UIWebView *webView;
/**  */
@property (nonatomic , strong)UIButton *bottomBtn;
/**  */
@property (nonatomic , strong)NSDictionary *dataDic;
/**  */
@property (nonatomic , assign)BOOL didMakePostRequest;
/**  */
@property (nonatomic , assign)CGFloat webHeight;

@property (nonatomic , strong)LGGoodsDetailTopView *topView;
@property (nonatomic , strong)LGGoodsDetailTitleView *titleView;
@property (nonatomic , strong)LGGoodsDetailAttrHeadView *headView;
@property (nonatomic , strong)LGGoodsDetailTotalPriceView *priceView;
@property (nonatomic , strong)LGGoodsDetailResourceView *sourceView;
@property (nonatomic , strong)LGGoodsDetailShopView *shopView;
@property (nonatomic , strong)LGGoodsDetailDesView *desView;
@property (nonatomic , strong)LGGoodsDetailBottomView *bottomView;

@property (nonatomic , strong)NSMutableArray *categoryArry;
@property (nonatomic , strong)NSArray *attrbutArry;
@property (nonatomic , strong)NSArray *productList;
@property (nonatomic , copy)NSString *price;
@property (nonatomic , assign)BOOL open;
@property (nonatomic , assign)CGFloat desHeight;
@property (nonatomic , copy)NSString *brandId;
@property (nonatomic , copy)NSString *brandName;
@property (nonatomic , copy)NSString *brandImage;
@property (nonatomic , copy)NSString *attrId;
@property (nonatomic , copy)NSString *productId;
@property (nonatomic , assign)NSInteger goodsNum;

//记录滑动方向
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation LGGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.open = YES;
    self.goodsNum = 1;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenKeyBorad)]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"#201341"] alpha:0.0]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self commonInit];
    [self requestData];
}


- (void)viewDidDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:ML_MAIN_COLOR]  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:ML_MAIN_COLOR];
    self.navigationController.navigationBar.translucent = NO;
    
    [super viewDidDisappear:animated];
    
}



- (void)requestData{
    NSString *action = [NSString stringWithFormat:@"goodsId=%@",self.goodsId];
    [RequestUtil withGET:@"/api/ecs/goods/detail.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        if ( [[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"result"];
            self.topView.imageArry = dic[@"goodsImg"];
            self.topView.dataDic = dic;
            NSArray *activeArry = dic[@"activityLabel"];
            if (activeArry.count>0) {
                self.titleView.activeStr = [NSString stringWithFormat:@"%@",dic[@"activityLabel"][0]];
            }
            self.titleView.priceStr = [NSString stringWithFormat:@"%@",dic[@"promotePrice"]];//85f
            self.titleView.shopPrice = [NSString stringWithFormat:@"%@",dic[@"shopPrice"]];//90
            self.titleView.markPriceStr = [NSString stringWithFormat:@"%@",dic[@"marketPrice"]];//288
            //            self.priceView.singPrice = [NSString stringWithFormat:@"%@",dic[@"shopPrice"]];
//            self.titleView.scanUrl = [NSString stringWithFormat:@"%@",dic[@"qrCodePicUrl"]];
            self.priceView.maxNum = [dic[@"goodsNumber"] integerValue];
            
            self.titleView.titleStr = [NSString stringWithFormat:@"%@",dic[@"goodsName"]];
            
            self.attrbutArry = [LGGoodsCategoryModel mj_objectArrayWithKeyValuesArray:dic[@"goodsAttr"]];
            
            self.productList = dic[@"productList"];
            
            self.sourceView.sourceArry = dic[@"goodsSourceApp"];
            
            self.brandId = [NSString stringWithFormat:@"%@",dic[@"brandId"]];
            self.brandName = [NSString stringWithFormat:@"%@",dic[@"brandName"]];
            self.brandImage = [NSString stringWithFormat:@"%@",dic[@"brandPic"]];
            self.shopView.titleStr = dic[@"brandName"];
            self.shopView.imageStr = dic[@"brandPic"];
            self.shopView.numerStr = [NSString stringWithFormat:@"%@",dic[@"goodsNumber"]];
            
            [self.webView loadHTMLString:dic[@"goodsDesc"] baseURL:nil];
            self.desView.packDesc = dic[@"packDesc"];
            [self.myTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)setProductList:(NSArray *)productList{
    _productList = productList;
    for (NSInteger i=0; i<productList.count; i++) {
        NSDictionary *dic = productList[i];
        if ([dic[@"isDefault"] integerValue]>0) {
            //显示默认价格
            self.titleView.priceStr = [NSString stringWithFormat:@"%@",dic[@"promotePrice"]];//85f
            self.titleView.shopPrice = [NSString stringWithFormat:@"%@",dic[@"shopPrice"]];
            self.titleView.markPriceStr = [NSString stringWithFormat:@"%@",dic[@"marketPrice"]];//288
            NSString *singPrice = [NSString stringWithFormat:@"%@",dic[@"promotePrice"]];
            if ([singPrice containsString:@"(null)"]) {
                singPrice = [NSString stringWithFormat:@"%@",dic[@"shopPrice"]];
            }
            self.priceView.singPrice = singPrice;
            self.productId = [NSString stringWithFormat:@"%@",dic[@"productId"]];
            //默认选中
            NSArray *attrIdArry = [dic[@"attrId"] componentsSeparatedByString:@","];
            for (NSInteger j=0; j<attrIdArry.count; j++) {
                //默认选中ID
                NSString *attrId = [NSString stringWithFormat:@"%@",attrIdArry[j]];
                for (NSInteger m=0; m<self.categoryArry.count; m++) {
                    //model
                    LGGoodsCategoryModel *model = self.categoryArry[m];
                    NSArray *valueArry = model.attrValues;
                    for (NSInteger n=0; n<valueArry.count; n++) {
                        NSString *goodsAttrId = [NSString stringWithFormat:@"%@",valueArry[n][@"goodsAttrId"]];
                        if ([attrId isEqualToString:goodsAttrId]) {
                            model.selectIndex = [NSString stringWithFormat:@"%ld",n];
                        }
                    }
                }
            }
            [self.myTableView reloadData];
            return;
        }
    }
}

-(void)setWebHeight:(CGFloat)webHeight{
    _webHeight = webHeight;
    self.webView.frame = CGRectMake(0, -1, Screen_W, webHeight);
    self.webScrollView.contentSize = CGSizeMake(Screen_W, webHeight);
}

-(void)topBtnTapAction:(UIButton *)sender{
    if (sender == self.shopBtn) {
        [self.baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [self.baseScrollView setContentOffset:CGPointMake(Screen_W, 0) animated:YES];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat width = self.baseScrollView.contentSize.width;
    CGFloat bottomOffset = scrollView.contentSize.height - offsetY;
   
    if (scrollView == self.myTableView) {
        if (bottomOffset <= baseHeight-viewPix(50)) {
            //底部
            self.baseScrollView.contentSize = CGSizeMake(Screen_W, baseHeight);
            self.webScrollView.frame = CGRectMake(0, baseHeight+topBarHeight, Screen_W, baseHeight-topBarHeight);
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.myTableView.frame = CGRectMake(0, -baseHeight, Screen_W, baseHeight);
                self.webScrollView.frame = CGRectMake(0, topBarHeight, Screen_W, baseHeight-topBarHeight);
                self.normalView.frame = CGRectMake((Screen_W-topWidth*2)/2.0-viewPix(60), -44, topWidth*2, 44);
                self.detailLabel.frame = CGRectMake((Screen_W-topWidth*2)/2.0-viewPix(60), 0, topWidth*2, 44);
            } completion:^(BOOL finished) {
                //结束加载
                [self.myTableView.mj_footer endRefreshing];
            }];
        }
        
    }else if (scrollView == self.webScrollView){
        if (offsetY<0 && width == Screen_W) {
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.myTableView.frame = CGRectMake(0, 0, Screen_W, baseHeight);
                self.webScrollView.frame = CGRectMake(0, baseHeight-topBarHeight, Screen_W, baseHeight-topBarHeight);
                self.normalView.frame = CGRectMake((Screen_W-topWidth*2)/2.0-viewPix(60), 0, topWidth*2, 44);
                self.detailLabel.frame = CGRectMake((Screen_W-topWidth*2)/2.0-viewPix(60), 44, topWidth*2, 44);
            } completion:^(BOOL finished) {
                //结束加载
                [self.webScrollView.mj_header endRefreshing];
                self.baseScrollView.contentSize = CGSizeMake(Screen_W*2, baseHeight);
                self.webScrollView.frame = CGRectMake(Screen_W, topBarHeight, Screen_W, baseHeight-topBarHeight);
            }];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGFloat sizeWidth = self.baseScrollView.contentSize.width;
    if (sizeWidth>Screen_W) {
        _webScrollView.mj_header = nil;
    }else{
        MJDIYAutoHeader *header =[MJDIYAutoHeader headerWithRefreshingTarget:self refreshingAction:@selector(doNoting)];
        _webScrollView.mj_header = header;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = self.baseScrollView.contentOffset.x;
    if (offsetX == 0) {
        self.shopBtn.selected = YES;
        self.detailBtn.selected = NO;
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"#201341"] alpha:0]  forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.titleView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.center = CGPointMake(topWidth/2.0, 42.5);
        }];
        CGFloat offset = self.myTableView.contentOffset.y;
        CGFloat alpha = (CGFloat)offset/(viewPix(195)-topBarHeight);
        if (alpha<1.0) {
            self.navigationController.navigationBar.translucent = YES;
        }else{
            self.navigationController.navigationBar.translucent = NO;
        }
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"#201341"] alpha:alpha]  forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.titleView.alpha = alpha;
    }else if (offsetX == Screen_W){
        self.shopBtn.selected = NO;
        self.detailBtn.selected = YES;
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"#201341"] alpha:1]  forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.titleView.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.center = CGPointMake(topWidth*3/2.0, 42.5);
        }];
    }
    
}

-(void)buyAction{
    
}

-(void)setAttrbutArry:(NSArray *)attrbutArry{
    _attrbutArry = attrbutArry;
    self.categoryArry = [NSMutableArray array];
    for (NSInteger i=0; i<attrbutArry.count; i++) {
        LGGoodsCategoryModel *model = attrbutArry[i];
        if ([model.attrType isEqualToString:@"0"]) {
            [self.categoryArry addObject:model];
        }
    }
}

//选择规格
-(void)selectCategoryAtRow:(NSInteger)row index:(NSInteger)index{
    LGGoodsCategoryModel *model = self.categoryArry[row];
    model.selectIndex = [NSString stringWithFormat:@"%ld",index];
    //选择规格变更价格
    LGGoodsCategoryModel *cateModel = self.categoryArry[0];
    
    NSString *attId = [NSString stringWithFormat:@"%@",cateModel.attrValues[[cateModel.selectIndex integerValue]][@"goodsAttrId"]];
    if (self.categoryArry.count>1) {
        for (NSInteger i=0; i<self.categoryArry.count; i++) {
            LGGoodsCategoryModel *tempModel = self.categoryArry[i];
            attId = [NSString stringWithFormat:@"%@,%@",attId,tempModel.attrValues[[tempModel.selectIndex integerValue]][@"goodsAttrId"]];
        }
    }
    
    
//    NSString *attId = [NSString stringWithFormat:@"%@",model.attrValues[index][@"goodsAttrId"]];
    self.attrId = attId;
    [self changePriceWithAttrbutid:attId];
    //显示选中规格
    NSString *category;
    BOOL first = YES;
    for (NSInteger i=0; i<self.categoryArry.count; i++) {
        LGGoodsCategoryModel *Model = self.categoryArry[i];
        if (Model.selectIndex && Model.selectIndex.length>0) {
            if (first == YES) {
                first = NO;
                category = [NSString stringWithFormat:@"%@",Model.attrValues[[Model.selectIndex integerValue]][@"attrValue"]];
            }else{
                category = [NSString stringWithFormat:@"%@/%@",category,Model.attrValues[[Model.selectIndex integerValue]][@"attrValue"]];
            }
        }
    }
    self.headView.categoryTitle = category;
}

//15567 -- 4000 15573 -- 4005
-(void)changePriceWithAttrbutid:(NSString *)attid{
    for (NSDictionary *dic in self.productList) {
        NSString * attrId = [NSString stringWithFormat:@"%@",dic[@"attrId"]];
        if ([attid isEqualToString:attrId]) {
            self.titleView.priceStr = [NSString stringWithFormat:@"%@",dic[@"promotePrice"]];//85f
            self.titleView.shopPrice = [NSString stringWithFormat:@"%@",dic[@"shopPrice"]];
            self.titleView.markPriceStr = [NSString stringWithFormat:@"%@",dic[@"marketPrice"]];//288
            NSString *singPrice = [NSString stringWithFormat:@"%@",dic[@"promotePrice"]];
            if ([singPrice containsString:@"(null)"]) {
                singPrice = [NSString stringWithFormat:@"%@",dic[@"shopPrice"]];
            }
            self.priceView.singPrice = singPrice;
            self.productId = [NSString stringWithFormat:@"%@",dic[@"productId"]];
            NSLog(@">>???>>%@",dic);
            return;
        }
    }
}

-(void)getGoodsNumer:(NSInteger)numer{
    self.goodsNum = numer;
    self.headView.goodsNum = numer;
}

-(void)openHeadView:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.open = sender.selected;
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -- 点击事件
-(void)hidenKeyBorad{
    [self.view endEditing:YES];
}


//去品牌页面
-(void)goToBrandView{
    LGBrandDetailViewController *controller = [[LGBrandDetailViewController alloc]init];
    controller.brandId = self.brandId;
    controller.brandName = self.brandName;
    controller.brandImage = self.brandImage;
    [self.navigationController pushViewController:controller animated:YES];
}

//收藏
-(void)collectBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

//点击货源
-(void)selectResourceWithDic:(NSDictionary *)dic{
    NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
    //type为0不跳转
    if ([type isEqualToString:@"1"]) {
        //外链
        LGGoodsDetailWebViewController *controller = [[LGGoodsDetailWebViewController alloc] init];
        controller.urlStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if ([type isEqualToString:@"2"]){
        //商品ID
        LGGoodsDetailViewController *controller = [[LGGoodsDetailViewController alloc] init];
        controller.goodsId = [NSString stringWithFormat:@"%@",dic[@"content"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//发布评论
- (void)goToComment {
    if ([HXSUserAccount currentAccount].isLogin) {
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        if([self.navigationController.topViewController isKindOfClass:[HXSCommunityPostingViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
    } else {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            self.titleView.scanUrl = [NSString stringWithFormat:@"http://www.meyley.com/production/detail/%@?inviteCode=%@",self.goodsId,[HXSUserAccount currentAccount].userInfo.basicInfo.inviteCode];
            HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
            [self.navigationController pushViewController:communityPostingViewController animated:YES];
        }];
    }
}
//联系客服
-(void)kefuBtnAction{
    MLServiceCenterViewController *controller = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil]instantiateViewControllerWithIdentifier:@"MLServiceCenterViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
//购物车
-(void)shopCartBtnAction{
    if (![HXSUserAccount currentAccount].isLogin) {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            _titleView.scanUrl = [NSString stringWithFormat:@"http://www.meyley.com/production/detail/%@?inviteCode=%@",self.goodsId,[HXSUserAccount currentAccount].userInfo.basicInfo.inviteCode];
        }];
        
    }else{
        MLTreastureViewController *controller = [[UIStoryboard storyboardWithName:@"Treasure" bundle:nil]instantiateViewControllerWithIdentifier:@"MLTreastureViewController"];
        controller.isFromGoodsDetail = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
//加入购物车
-(void)addBtnAction:(UIButton *)sender{
    if (![HXSUserAccount currentAccount].isLogin) {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            _titleView.scanUrl = [NSString stringWithFormat:@"http://www.meyley.com/production/detail/%@?inviteCode=%@",self.goodsId,[HXSUserAccount currentAccount].userInfo.basicInfo.inviteCode];
        }];
        
    }else{
        BOOL finish = YES;
        for (LGGoodsCategoryModel *model in self.categoryArry) {
            if (!model.selectIndex) {
                finish = NO;
            }
        }
        
        if (finish == YES) {
            //加入购物车
            NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
            sender.userInteractionEnabled = NO;
            NSDictionary *action = @{@"userId":userId,@"brandId":self.brandId,@"goodsId":self.goodsId,@"goodsNumber":[NSString stringWithFormat:@"%ld",self.goodsNum],@"spec":self.attrId,@"productId":@([self.productId intValue])};
            
            [RequestUtil withPOST:@"/api/ecs/cart/add.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
                sender.userInteractionEnabled = YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:LGRefreshShopingCartGoodsNotification object:nil];
                if ( [[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"再逛逛" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"去购物车" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        //去购物车
                        [self shopCartBtnAction];
                    }];
                    [alertController addAction:continuAciont];
                    [alertController addAction:chartAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }else{
                    [TooltipView showMessage:responseObject[@"msg"] offset:0];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                sender.userInteractionEnabled = YES;
                [TooltipView showMessage:@"添加购物车失败" offset:0];
            }];
            
        }else{
            //弹框显示提示
            [TooltipView showMessage:@"请选择属性规格" offset:0];
        }
    }
}



#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 && self.open == YES) {
        return self.categoryArry.count;
    }else{
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGGoodsDetailCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[LGGoodsDetailCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (indexPath.row < self.categoryArry.count) {
        cell.model = self.categoryArry[indexPath.row];
        cell.row = indexPath.row;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(92);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return viewPix(80);
    }else if (section == 1){
        return viewPix(45);
    }else if (section == 2){
        return viewPix(50);
    }else if (section == 3){
        return viewPix(45);
    }else if (section == 4){
        return viewPix(45);
    }else if (section == 5){
        return viewPix(80);
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleView;
    }else if (section == 1){
        return self.headView;
    }else if (section == 2){
        return self.priceView;
    }else if (section == 3){
        return self.sourceView;
    }else if (section == 4){
        return self.desView;
    }else if (section == 5){
        return self.shopView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 2 || section == 3 || section == 4) {
        return viewPix(13);
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 2 || section == 3 || section == 4) {
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(13))];
        baseView.backgroundColor = RGB(247, 247, 247);
        [_myTableView bringSubviewToFront:self.titleView];
        return baseView;
    }else{
        return [[UIView alloc]init];
    }
}


#pragma mark---webViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, Screen_W-viewPix(20)];
    [_webView stringByEvaluatingJavaScriptFromString:js];
    [_webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    self.webHeight =[[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
}


-(void)doNoting{
    
}

-(void)dealloc{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
    self.baseScrollView.delegate = nil;
    self.webScrollView.delegate = nil;
    self.webView.scrollView.delegate = nil;
}
#pragma mark---懒加载+创建控件
-(void)commonInit{
//    self.view.backgroundColor = [UIColor colorWithString:@"f2f2f2"];
    if (@available(ios 11.0 , *)) {
        self.baseScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.webScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self creatTopView];

    [self.view addSubview:self.baseScrollView];
    [self.baseScrollView addSubview:self.myTableView];
    [self.baseScrollView addSubview:self.webScrollView];
    [self.webScrollView addSubview:self.webView];
    [self.view addSubview:self.bottomView];
}

-(UIScrollView *)baseScrollView{
    if(!_baseScrollView){
        _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, - topBarHeight, Screen_W, baseHeight)];
        _baseScrollView.contentSize = CGSizeMake(Screen_W*2, baseHeight);
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.pagingEnabled = YES;
        _baseScrollView.delegate = self;
        _baseScrollView.bounces = NO;
    }
    return _baseScrollView;
}

-(UITableView *)myTableView{
    if(!_myTableView){
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, baseHeight) style:UITableViewStyleGrouped];
        _myTableView.tableHeaderView = self.topView;
        _myTableView.estimatedRowHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.rowHeight = UITableViewAutomaticDimension;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        MJDIYAutoFooter *footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNoting)];
        _myTableView.mj_footer = footer;
        _myTableView.mj_footer.hidden = YES;
    }
    return _myTableView;
}

-(UIScrollView *)webScrollView{
    if(!_webScrollView){
        _webScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(Screen_W, topBarHeight, Screen_W, baseHeight-topBarHeight)];
        _webScrollView.backgroundColor = [UIColor colorWithString:@"f2f2f2"];
        _webScrollView.contentSize = CGSizeMake(Screen_W, baseHeight);
        _webScrollView.delegate = self;
        MJDIYAutoHeader *header =[MJDIYAutoHeader headerWithRefreshingTarget:self refreshingAction:@selector(doNoting)];
        _webScrollView.mj_header = header;
    }
    return _webScrollView;
}

-(UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(Screen_W, -1, Screen_W, baseHeight)];
        _webView.backgroundColor = [UIColor colorWithString:@"f2f2f2"];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        _webView.scrollView.bounces = NO;
//        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

-(LGGoodsDetailTopView *)topView{
    if (!_topView) {
        _topView = [[LGGoodsDetailTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, statusBarHeight+viewPix(360))];
    }
    return _topView;
}

-(LGGoodsDetailTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LGGoodsDetailTitleView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(80))];
        if (![HXSUserAccount currentAccount].isLogin) {
            //未登录
            _titleView.scanUrl = [NSString stringWithFormat:@"http://www.meyley.com/production/detail/%@",self.goodsId];
            
        }else{
            //登录
            _titleView.scanUrl = [NSString stringWithFormat:@"http://www.meyley.com/production/detail/%@?inviteCode=%@",self.goodsId,[HXSUserAccount currentAccount].userInfo.basicInfo.inviteCode];
        }
        
    }
    return _titleView;
}

-(LGGoodsDetailAttrHeadView *)headView{
    if (!_headView) {
        _headView = [[LGGoodsDetailAttrHeadView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(45))];
        [_headView.openBtn addTarget:self action:@selector(openHeadView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

-(LGGoodsDetailResourceView *)sourceView{
    if (!_sourceView) {
        _sourceView = [[LGGoodsDetailResourceView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(50))];
        _sourceView.delegate = self;
    }
    return _sourceView;
}

-(LGGoodsDetailTotalPriceView *)priceView{
    if (!_priceView) {
        _priceView = [[LGGoodsDetailTotalPriceView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(50))];
        _priceView.delegate = self;
    }
    return _priceView;
}

-(LGGoodsDetailShopView *)shopView{
    if (!_shopView) {
        _shopView = [[LGGoodsDetailShopView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(90))];
        [_shopView.checkBtn addTarget:self action:@selector(goToBrandView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopView;
}

-(LGGoodsDetailDesView *)desView{
    if (!_desView) {
        _desView = [[LGGoodsDetailDesView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(45))];
    }
    return _desView;
}

-(LGGoodsDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[LGGoodsDetailBottomView alloc]initWithFrame:CGRectMake(0, Screen_H-topBarHeight-viewPix(50), Screen_W, viewPix(50))];
        [_bottomView.kefuBtn addTarget:self action:@selector(kefuBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.commentBtn addTarget:self action:@selector(goToComment) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.collectBtn addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.shopCartBtn addTarget:self action:@selector(shopCartBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

-(NSMutableArray *)categoryArry{
    if (!_categoryArry) {
        _categoryArry = [NSMutableArray array];
    }
    return _categoryArry;
}


-(void)creatTopView{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(viewPix(60), statusBarHeight, Screen_W-viewPix(120), 44)];
    baseView.clipsToBounds = YES;
    

    UIView *normalView = [[UIView alloc]initWithFrame:CGRectMake((Screen_W-topWidth*2)/2.0-viewPix(60), 0, topWidth*2, 44)];
    self.normalView = normalView;
    [baseView addSubview:normalView];
    
    UILabel *detailLabel = [UILabel lableWithFrame:CGRectMake((Screen_W-topWidth*2)/2.0-viewPix(60), 44, topWidth*2, 44) text:@"商品详情" textColor:[UIColor whiteColor] font:17 textAlignment:NSTextAlignmentCenter lines:1];
    self.detailLabel = detailLabel;
    [baseView addSubview:detailLabel];
    
    UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopBtn.frame = CGRectMake(0, 0, topWidth, 44);
    [shopBtn setTitle:@"商品" forState:UIControlStateNormal];
    [shopBtn setTitleColor:[UIColor colorWithString:@"999999"] forState:UIControlStateNormal];
    [shopBtn setTitleColor:[UIColor colorWithString:@"FFFFFF"] forState:UIControlStateSelected];
    [shopBtn addTarget:self action:@selector(topBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    shopBtn.titleLabel.font = LGFont(15);
    shopBtn.selected = YES;
    self.shopBtn = shopBtn;
    [normalView addSubview:shopBtn];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(topWidth, 0, topWidth, 44);
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor colorWithString:@"999999"] forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor colorWithString:@"FFFFFF"] forState:UIControlStateSelected];
    [detailBtn addTarget:self action:@selector(topBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    detailBtn.titleLabel.font = LGFont(15);
    self.detailBtn = detailBtn;
    [normalView addSubview:detailBtn];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.center = CGPointMake(topWidth/2.0, 42.5);
    lineView.bounds = CGRectMake(0, 0, viewPix(50), 3);
    lineView.backgroundColor = [UIColor whiteColor];
    self.lineView = lineView;
    [normalView addSubview:lineView];
    self.navigationItem.titleView = baseView;
}





/**peek时上拉出来的菜单*/
-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    return self.actions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
