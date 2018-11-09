//
//  LGAddReceiveAddressViewController.m
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGAddReceiveAddressViewController.h"
#import "LGAddNewAddressTableCell.h"
#import "LGReceiveAddressModel.h"
#import "LGChooseAddressView.h"


@interface LGAddReceiveAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *addressTableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) LGChooseAddressView *addressView;

//记录参数
@property (nonatomic, copy) NSString *receiverName; //姓名
@property (nonatomic, copy) NSString *mobile;       //手机号
@property (nonatomic, copy) NSString *province;     //省份id
@property (nonatomic, copy) NSString *provinceName; //省份
@property (nonatomic, copy) NSString *city;         //市id
@property (nonatomic, copy) NSString *cityName;     //市
@property (nonatomic, copy) NSString *area;         //区id
@property (nonatomic, copy) NSString *areaName;     //区
@property (nonatomic, copy) NSString *detailAddress;//详细地址
@property (nonatomic, copy) NSString *isDefault;    //是否设为默认

@end
static NSString *const addNewAddressCell = @"addNewAddressCell";
@implementation LGAddReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.style == LGAddressStyleNew) {
        self.navigationItem.title = @"新建收货地址";
        self.dataArray = @[@{@"typeName":@"收货人",@"typeValue":@"",@"placeHolder":@"请输入姓名",@"cellType":@(LGAddressCellTypeDefault)},@{@"typeName":@"手机号码",@"typeValue":@"",@"placeHolder":@"请输入手机号码",@"cellType":@(LGAddressCellTypeDefault)},@{@"typeName":@"所在地区",@"typeValue":@"",@"placeHolder":@"请选择省份、城市和区县",@"cellType":@(LGAddressCellTypeChoose)},@{@"typeName":@"详细地址",@"typeValue":@"",@"placeHolder":@"请输入街道、小区和门牌号",@"cellType":@(LGAddressCellTypeDefault)}];
    }else {
        self.navigationItem.title = @"编辑收货地址";
        NSString *address = [NSString stringWithFormat:@"%@%@%@",self.model.provinceName,self.model.cityName,self.model.districtName];
        self.dataArray = @[@{@"typeName":@"收货人",@"typeValue":self.model.consignee,@"placeHolder":@"请输入姓名",@"cellType":@(LGAddressCellTypeDefault)},@{@"typeName":@"手机号码",@"typeValue":self.model.mobile,@"placeHolder":@"请输入手机号码",@"cellType":@(LGAddressCellTypeDefault)},@{@"typeName":@"所在地区",@"typeValue":address,@"placeHolder":@"请选择省份、城市和区县",@"cellType":@(LGAddressCellTypeChoose)},@{@"typeName":@"详细地址",@"typeValue":self.model.address,@"placeHolder":@"请输入街道、小区和门牌号",@"cellType":@(LGAddressCellTypeDefault)}];
        self.receiverName = self.model.consignee;
        self.mobile = self.model.mobile;
        self.province = self.model.province;
        self.provinceName = self.model.provinceName;
        self.city = self.model.city;
        self.cityName = self.model.cityName;
        self.area = self.model.district;
        self.areaName = self.model.districtName;
        self.detailAddress = self.model.address;
        self.isDefault = self.model.isDefault;
    }
    
    [self.view addSubview:self.addressTableView];
    
}
#pragma mark---保存收货地址----
- (void)saveReceivingAddress {
    [self.view endEditing:YES];
    NSString *urlString;
    NSDictionary *action;
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    if (![[self.receiverName stringByReplacingOccurrencesOfString:@" " withString:@""]length]) {
        [TooltipView showMessage:@"请输入姓名" offset:0];
        return;
    }
    if (![[self.mobile stringByReplacingOccurrencesOfString:@" " withString:@""]length]) {
        [TooltipView showMessage:@"请输入手机号码" offset:0];
        return;
    }else {
        if (![MBTools checkMobileIsTrue:self.mobile]) {
            [TooltipView showMessage:@"请输入正确的手机号码" offset:0];
            return;
        }
    }
    NSString *add = [NSString stringWithFormat:@"%@%@%@",self.provinceName.length?self.provinceName:@"",self.cityName.length?self.cityName:@"",self.areaName.length?self.areaName:@""];
    if (!add.length) {
        [TooltipView showMessage:@"请选择省市区" offset:0];
        return;
    }
    if (![[self.detailAddress stringByReplacingOccurrencesOfString:@" " withString:@""]length]) {
        [TooltipView showMessage:@"请输入详细收货地址" offset:0];
        return;
    }
    
    if (self.style == LGAddressStyleNew) { //新增
        urlString = @"/api/ecs/address/add.action";
        action = @{@"userId":userId,@"consignee":self.receiverName,@"mobile":self.mobile,@"province":self.province.length?self.province:@"",@"city":self.city.length?self.city:@"",@"district":self.area.length?self.area:@"",@"address":self.detailAddress,@"isDefault":self.isDefault};
    }else { //修改
        urlString = @"/api/ecs/address/modify.action";
        action = @{@"addressId":self.model.addressId,@"userId":userId,@"consignee":self.receiverName,@"mobile":self.mobile,@"province":self.province.length?self.province:@"",@"city":self.city.length?self.city:@"",@"district":self.area.length?self.area:@"",@"address":self.detailAddress,@"isDefault":self.isDefault};
    }
    
    [RequestUtil withPOST:urlString parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            if (self.style == LGAddressStyleEditing) {
                [TooltipView showMessage:@"收货地址修改成功" offset:0];
            }else {
                [TooltipView showMessage:@"收货地址添加成功" offset:0];
            }
            if (self.refreshReceiveAddress) {
                self.refreshReceiveAddress();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark--UITableViewDataSource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGAddNewAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:addNewAddressCell forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.typeString = [dic valueForKey:@"typeName"];
    cell.text = [dic valueForKey:@"typeValue"];
    cell.placeHolder = [dic valueForKey:@"placeHolder"];
    cell.type = [[dic valueForKey:@"cellType"] integerValue];

    if (indexPath.row == 0) {
        cell.text = self.receiverName;
    }else if (indexPath.row == 1) {
        cell.text = self.mobile;
    }else if (indexPath.row == 2) {
        NSString *add = [NSString stringWithFormat:@"%@%@%@",self.provinceName.length?self.provinceName:@"",self.cityName.length?self.cityName:@"",self.areaName.length?self.areaName:@""];
        cell.text = add;
    }else {
        cell.text = self.detailAddress;
    }
    __weak typeof(self)weakSelf = self;
    cell.editUserInfoBlock = ^(UITextField *textField, LGAddressCellType type) {
        [weakSelf handlerEditUserInfoWithTextField:textField cellType:type indexPath:indexPath];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(44);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return viewPix(16);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ML_BG_MAIN_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [defaultBtn setImage:[UIImage imageNamed:@"x2"] forState:UIControlStateNormal];
    [defaultBtn setImage:[UIImage imageNamed:@"x1"] forState:UIControlStateSelected];
    [defaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
    [defaultBtn setTitleColor:[UIColor colorWithString:@"#959595"] forState:UIControlStateNormal];
    defaultBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [defaultBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [defaultBtn addTarget:self action:@selector(setDefaultReceiveAddress:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:defaultBtn];
    if ([self.model.isDefault isEqualToString:@"1"]) {
        defaultBtn.selected = YES;
    }else {
        defaultBtn.selected = NO;
    }
    [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(view);
        make.width.mas_equalTo(100);
    }];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    LGAddNewAddressTableCell *cell = (LGAddNewAddressTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 2) {
        [self handlerEditUserInfoWithTextField:cell.textField cellType:LGAddressCellTypeChoose indexPath:indexPath];
    }else {
        cell.textField.userInteractionEnabled = YES;
        [self handlerEditUserInfoWithTextField:cell.textField cellType:LGAddressCellTypeDefault indexPath:indexPath];
    }
}
#pragma mark--action----
- (void)setDefaultReceiveAddress:(UIButton *)btn {
    btn.selected =! btn.selected;
    self.isDefault = btn.selected?@"1":@"0";
}
//处理编辑结果
- (void)handlerEditUserInfoWithTextField:(UITextField *)textField cellType:(LGAddressCellType)type indexPath:(NSIndexPath *)indexPath {
    LGLogFunction;
    if (type == LGAddressCellTypeDefault) { //除了选择省市区  type == LGAddressCellTypeDefault
        if (indexPath.row == 0) {   //姓名
            self.receiverName = textField.text;
        }else if (indexPath.row == 1) { //手机号码
            self.mobile = textField.text;
        }else { //详细收货地址
            self.detailAddress = textField.text;
        }
    }else {
        self.addressView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        __weak typeof(self)weakSelf = self;
        self.addressView.chooseAddressIdsAndNames = ^(NSDictionary *dic) {
            weakSelf.provinceName = dic[@"provinceName"];
            weakSelf.province = dic[@"provinceId"];
            weakSelf.cityName = dic[@"cityName"];
            weakSelf.city = dic[@"cityId"];
            weakSelf.areaName = dic[@"areaName"];
            weakSelf.area = dic[@"areaId"];
            NSString *add = [NSString stringWithFormat:@"%@%@%@",weakSelf.provinceName.length?weakSelf.provinceName:@"",weakSelf.cityName.length?weakSelf.cityName:@"",weakSelf.areaName.length?weakSelf.areaName:@""];
            textField.text = add;
        };
        [self presentViewController:self.addressView animated:NO completion:^{
            self.addressView.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        }];
    }
}

#pragma mark--lazy------
- (UITableView *)addressTableView {
    
    if (!_addressTableView) {
        
        _addressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight) style:UITableViewStyleGrouped];
        _addressTableView.delegate = self;
        _addressTableView.dataSource = self;
        _addressTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _addressTableView.separatorInset = UIEdgeInsetsMake(0, viewPix(16), 0, 0);
        _addressTableView.backgroundColor = [UIColor clearColor];
        _addressTableView.showsVerticalScrollIndicator = NO;
        _addressTableView.showsHorizontalScrollIndicator = NO;
        if (kAPIVersion11Later) {
            _addressTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _addressTableView.estimatedRowHeight = 0;
        _addressTableView.estimatedSectionFooterHeight = 0;
        _addressTableView.estimatedSectionHeaderHeight = 0;
        UIView *footerVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 200)];
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setBackgroundColor:RGB(255, 0, 82)];
        [saveBtn addTarget:self action:@selector(saveReceivingAddress) forControlEvents:UIControlEventTouchUpInside];
        saveBtn.layer.cornerRadius = 5;
        saveBtn.layer.masksToBounds = YES;
        [footerVIew addSubview:saveBtn];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerVIew.mas_left).offset(40);
            make.top.equalTo(footerVIew.mas_top).offset(39);
            make.right.equalTo(footerVIew.mas_right).offset(-40);
            make.height.mas_equalTo(45);
        }];
        _addressTableView.tableFooterView = footerVIew;
        [_addressTableView registerClass:[LGAddNewAddressTableCell class] forCellReuseIdentifier:addNewAddressCell];
    }
    return _addressTableView;
}

- (LGChooseAddressView *)addressView {
    
    if (!_addressView) {
        
        _addressView = [[LGChooseAddressView alloc]init];
    }
    return _addressView;
}
@end
