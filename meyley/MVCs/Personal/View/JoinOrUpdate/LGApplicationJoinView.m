//
//  LGApplicationJoinView.m
//  meyley
//
//  Created by Bovin on 2018/10/24.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGApplicationJoinView.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"
#import "LGPickView.h"

#import "LGWaiterGradeModel.h"

@interface LGApplicationJoinView ()<UITableViewDelegate,UITableViewDataSource,LGPickViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) LGApplicationJoinHeaderView *headerView;

@property (nonatomic, strong) LGApplicationJoinBottomBar *bottomBar;

@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, strong) UITextField *waiterTypeTF;

@property (nonatomic, strong) NSMutableArray *waiterList;

//客服等级ID
@property (nonatomic, copy) NSString *waiterTypeId;

@property (nonatomic, copy) NSString *userRealName;
@property (nonatomic, copy) NSString *userCardNumber;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userWechatNumber;
@property (nonatomic, copy) NSString *userAreaString;
@property (nonatomic, copy) NSString *userDetailAddress;
@property (nonatomic, copy) NSString *userShop;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *areaId;



@end

@implementation LGApplicationJoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        HXSUserInfo *userInfo = [HXSUserAccount currentAccount].userInfo;
        self.waiterList = [NSMutableArray array];
        self.dataArray = @[@{@"typeName":@"会员昵称",@"placeHolder":@"",@"value":userInfo.basicInfo.userName},@{@"typeName":@"姓       名",@"placeHolder":@"请输入姓名",@"value":@""},@{@"typeName":@"证件号码",@"placeHolder":@"请输入证件号码",@"value":@""},@{@"typeName":@"手机号码",@"placeHolder":@"请输入手机号码",@"value":@""},@{@"typeName":@"微信账号",@"placeHolder":@"请输入微信帐号",@"value":@""},@{@"typeName":@"所在区域",@"placeHolder":@"请选择所在区域",@"value":@""},@{@"typeName":@"详细地址",@"placeHolder":@"请输入详细地址",@"value":@""},@{@"typeName":@"实体店铺",@"placeHolder":@"填写店铺名称/没有填“无”",@"value":@""}];
        [self addSubview:self.tableView];
        [self addSubview:self.bottomBar];
    }
    return self;
}

- (void)setWaiterListArray:(NSMutableArray *)waiterListArray {
    _waiterListArray = waiterListArray;
    if (waiterListArray.count>0) {
        LGWaiterGradeModel *model = waiterListArray[0];
        self.headerView.waiterType = model.rankName;
        self.headerView.waiterDesc = model.desc;
    }
    [self.waiterList removeAllObjects];
    for (LGWaiterGradeModel *model in waiterListArray) {
        [self.waiterList addObject:model.rankName];
    }
    
}

#pragma mark--UITableViewDataSource------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGApplicationJoinCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LGApplicationJoinCell class]) forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.typeName = dic[@"typeName"];
    cell.placeHolder = dic[@"placeHolder"];
    cell.valueString = dic[@"value"];
    cell.textField.userInteractionEnabled = (indexPath.row==0 ||indexPath.row == 5)?NO:YES;
    __weak typeof(self)weakSelf = self;
    cell.editUserInfoBlock = ^(NSString *userInfo) {
        switch (indexPath.row) {
            case 1:
                weakSelf.userRealName = userInfo;
                break;
            case 2:
                weakSelf.userCardNumber = userInfo;
                break;
            case 3:
                weakSelf.userPhone = userInfo;
                break;
            case 4:
                weakSelf.userWechatNumber = userInfo;
                break;
            case 6:
                weakSelf.userDetailAddress = userInfo;
                break;
            case 7:
                weakSelf.userShop = userInfo;
                break;
            default:
                break;
        }
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(49);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 5) { // 选择所在区域
        LGApplicationJoinCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.chooseUserAddressBlock) {
            self.chooseUserAddressBlock(cell.textField);
        }
    }
}

#pragma mark---
- (BOOL)isAgreeProtocol {
    return self.isAgree;
}

#pragma mark--action------
//申请加盟升级
- (void)applicationJoinBtnClick {
    //数据提交成功处理
    if (self.sureApplicationJoinBlock) {
        self.sureApplicationJoinBlock();
    }
}
//取消申请
- (void)cancelJoinBtnClick {
    if (self.cancelApplicationBlock) {
        self.cancelApplicationBlock();
    }
}
//选择服务等级
- (void)chooseWaiterTypeWithTextField:(UITextField *)textField {
    self.waiterTypeTF = textField;
    LGPickView *pickView = [[LGPickView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    pickView.pickArry = @[self.waiterList];
    pickView.units = @[];
    pickView.titleLabel.text = @"请选择客服等级";
    pickView.topColor = RGB(250, 0, 102);
    pickView.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:pickView];
}

-(void)sendPickViewResult:(NSString *)result selectStr:(NSString *)selectStr {
    self.waiterTypeTF.text = result;
    for (LGWaiterGradeModel *model in self.waiterListArray) {
        if ([model.rankName isEqualToString:result]) {
            self.headerView.waiterDesc = model.desc;
            self.waiterTypeId = model.rankId;
        }
    }
}

#pragma mark--lazy-------
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, self.frame.size.height-viewPix(60)) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        if (kAPIVersion11Later) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerClass:[LGApplicationJoinCell class] forCellReuseIdentifier:NSStringFromClass([LGApplicationJoinCell class])];
    }
    return _tableView;
}

- (LGApplicationJoinHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[LGApplicationJoinHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 150)];
        __weak typeof(self) weakSelf = self;
        _headerView.ChooseWaiterTypeBlock = ^(UITextField *textField) {
            [weakSelf chooseWaiterTypeWithTextField:textField];
        };
        _headerView.AgreeUserProtocolBlock = ^(BOOL isSelected) {
            weakSelf.isAgree = isSelected;
        };
        _headerView.TapUserProtocol = ^{
            if (weakSelf.showUserProtocolBlock) {
                weakSelf.showUserProtocolBlock();
            }
        };
    }
    return _headerView;
}

- (LGApplicationJoinBottomBar *)bottomBar {
    
    if (!_bottomBar) {
        
        _bottomBar = [[LGApplicationJoinBottomBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), Screen_W, viewPix(60))];
        [_bottomBar.sureBtn addTarget:self action:@selector(applicationJoinBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar.cancelBtn addTarget:self action:@selector(cancelJoinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBar;
}
@end


@interface LGApplicationJoinCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *typeLabel;


@end


@implementation LGApplicationJoinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.textField];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(viewPix(10));
            make.top.bottom.equalTo(self.contentView);
        }];
        [self.typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-viewPix(10));
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.typeLabel.mas_right).offset(5);
        }];
    }
    return self;
}
- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    self.typeLabel.text = [NSString stringWithFormat:@"%@:",typeName];
}
- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}
- (void)setValueString:(NSString *)valueString {
    _valueString = valueString;
    self.textField.text = valueString;
}

- (void)textValueChange:(UITextField *)textField {
    if (self.editUserInfoBlock) {
        self.editUserInfoBlock(textField.text);
    }
}

#pragma mark--lazy------
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = RGB(66, 62, 62);
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}
- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = RGB(66, 62, 62);
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.tintColor = RGB(255, 0, 82);
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleNone;
        [_textField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

@end


@interface LGApplicationJoinHeaderView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UILabel *protocolLabel;

@end

@implementation LGApplicationJoinHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(255, 0, 82);
        [self addSubview:self.textField];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.agreeBtn];
        [self addSubview:self.protocolLabel];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(viewPix(20));
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(viewPix(40));
            make.width.mas_equalTo(viewPix(120));
        }];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textField.mas_bottom).offset(viewPix(15));
            make.left.equalTo(self.mas_left).offset(viewPix(10));
            make.right.equalTo(self.mas_right).offset(-viewPix(10));
        }];
        [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.protocolLabel.mas_centerY);
            make.right.equalTo(self.protocolLabel.mas_left).offset(-viewPix(5));
        }];
        [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textField.mas_left);
            make.bottom.equalTo(self.mas_bottom).offset(-viewPix(15));
        }];
    }
    return self;
}
#pragma mark--setter------
- (void)setWaiterType:(NSString *)waiterType {
    _waiterType = waiterType;
    self.textField.text = waiterType;
}
- (void)setWaiterDesc:(NSString *)waiterDesc {
    _waiterDesc = waiterDesc;
    self.tipsLabel.text = waiterDesc;
}

#pragma mark--action--
- (void)agreeUserProtocol:(UIButton *)agreeBtn {
    _agreeBtn.selected =! agreeBtn.selected;
    if (self.AgreeUserProtocolBlock) {
        self.AgreeUserProtocolBlock(agreeBtn.selected);
    }
}
- (void)showUserJoinProtocol {
    if (self.TapUserProtocol) {
        self.TapUserProtocol();
    }
}
#pragma mark--UITextFieldDelegate--
- (void)chooseWaiterType:(UITapGestureRecognizer *)tap {
    if (self.ChooseWaiterTypeBlock) {
        self.ChooseWaiterTypeBlock(self.textField);
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}
#pragma mark--lazy-----
- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = RGB(66, 62, 62);
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.tintColor = RGB(255, 0, 82);
        _textField.delegate = self;
        _textField.text = @"魅力达人";
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala"]];
//        imageView.backgroundColor = ML_BORDER_COLOR;
        imageView.frame = CGRectMake(0, 0, 12, 6);
        _textField.rightView = imageView;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        _textField.borderStyle = UITextBorderStyleBezel;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseWaiterType:)];
        [_textField addGestureRecognizer:tap];
//        [_textField addTarget:self action:@selector(chooseWaiterType:) forControlEvents:UIControlEventTouchDown];
    }
    return _textField;
}
- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"累计推荐20名新会员，免费升级达人，获得此后一年推荐订单服务佣金返现";
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}
- (UIButton *)agreeBtn {
    
    if (!_agreeBtn) {
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.backgroundColor = [UIColor whiteColor];
        [_agreeBtn setImage:[UIImage imageNamed:@"gouxuan 1"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
        [_agreeBtn addTarget:self action:@selector(agreeUserProtocol:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}
- (UILabel *)protocolLabel {
    
    if (!_protocolLabel) {
        
        _protocolLabel = [[UILabel alloc]init];
        _protocolLabel.textColor = [UIColor whiteColor];
        _protocolLabel.font = [UIFont systemFontOfSize:12];
        _protocolLabel.textAlignment = NSTextAlignmentLeft;
        _protocolLabel.text = @"魅力网加盟合作协议";
        _protocolLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserJoinProtocol)];
        [_protocolLabel addGestureRecognizer:tap];
    }
    return _protocolLabel;
}
@end



@implementation LGApplicationJoinBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sureBtn];
        [self addSubview:self.cancelBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-viewPix(15));
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(viewPix(40));
        }];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(viewPix(15));
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.sureBtn.mas_left).offset(-viewPix(20));
            make.width.height.equalTo(self.sureBtn);
        }];
    }
    return self;
}


#pragma mark--lazy------
- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确认申请" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:RGB(255, 0, 82) forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"放弃申请" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:ML_DISABLE_COLOR forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
    }
    return _cancelBtn;
}
@end
