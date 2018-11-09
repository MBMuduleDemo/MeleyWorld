//
//  LGChooseAddressView.m
//  meyley
//
//  Created by Bovin on 2018/9/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGChooseAddressView.h"
#import "LGAddressRegionModel.h"

@interface LGChooseAddressView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LGAddressChooseTopBar *topBar;
@property (nonatomic, strong) NSMutableArray *titlesArr;

@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *areaArr;

@property (nonatomic, strong) NSIndexPath *selectProvinceIndexPath;
@property (nonatomic, strong) NSIndexPath *selectCityIndexPath;
@property (nonatomic, strong) NSIndexPath *selectAreaIndexPath;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation LGChooseAddressView

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.titlesArr addObject:@"请选择"];
    self.selectIndex = 0;
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_H, Screen_W, 320)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.topBar];
    [self.containerView addSubview:self.tableView];
    [self.view addSubview:self.containerView];
    
    [self getAllProvinceData];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = CGRectMake(0, Screen_H-320, Screen_W, 320);
    }];
}
//获取所有省份的数据
- (void)getAllProvinceData {
    [RequestUtil GetAddressWithGET:@"/api/region/list.action" parameters:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self.provinceArr removeAllObjects];
            NSMutableArray *tmpArr = [LGAddressRegionModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [self.provinceArr addObjectsFromArray:tmpArr];
        }
        if (self.provinceArr.count) {
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)getCitiesDataWithRegionId:(NSString *)provinceId {
    NSString *action = [NSString stringWithFormat:@"regionId=%@",provinceId];
    [RequestUtil GetAddressWithGET:@"/api/region/getRegionById.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self.cityArr removeAllObjects];
            NSMutableArray *tmpArr = [LGAddressRegionModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [self.cityArr addObjectsFromArray:tmpArr];
            if (self.cityArr.count) {
                [self.tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getAreasDataWithRegionId:(NSString *)cityId {
    NSString *action = [NSString stringWithFormat:@"regionId=%@",cityId];
    [RequestUtil GetAddressWithGET:@"/api/region/getRegionById.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self.areaArr removeAllObjects];
            NSMutableArray *tmpArr = [LGAddressRegionModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [self.areaArr addObjectsFromArray:tmpArr];
            if (self.areaArr.count) {
                [self.tableView reloadData];
            }else {
                [self.titlesArr removeLastObject];
                self.topBar.titleArr = self.titlesArr;
                [self chooseFinishBlock];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)hideAddressChoose {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = CGRectMake(0, Screen_H, Screen_W, 320);
    }completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideAddressChoose];
}
#pragma mark--UITableViewDataSource------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectIndex == 0) {
        return self.provinceArr.count;
    }else if (self.selectIndex == 1){
        return self.cityArr.count;
    }else {
        return self.areaArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    LGAddressRegionModel *model;
    if (self.selectIndex == 0) {
        model = self.provinceArr[indexPath.row];
        if (self.selectProvinceIndexPath && self.selectProvinceIndexPath.row == indexPath.row) {
            cell.selected = YES;
        }else {
            cell.selected = NO;
        }
    }else if (self.selectIndex == 1){
        model = self.cityArr[indexPath.row];
        if (self.selectCityIndexPath && self.selectCityIndexPath.row == indexPath.row) {
            cell.selected = YES;
        }else {
            cell.selected = NO;
        }
    }else {
        model = self.areaArr[indexPath.row];
        if (self.selectAreaIndexPath && self.selectAreaIndexPath.row == indexPath.row) {
            cell.selected = YES;
        }else {
            cell.selected = NO;
        }
    }
    cell.textLabel.text = model.regionName;
    if (cell.selected) {
        cell.textLabel.textColor = RGB(255, 0, 82);
    }else {
        cell.textLabel.textColor = RGB(66, 62, 62);
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGAddressRegionModel *model;
    if (self.selectIndex == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.selectProvinceIndexPath != indexPath) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectProvinceIndexPath];
            cell.selected = NO;
            self.selectCityIndexPath = nil;
            self.selectAreaIndexPath = nil;
        }
        model = self.provinceArr[indexPath.row];
        if (!self.selectProvinceIndexPath) {
            [self.titlesArr insertObject:model.regionName atIndex:0];
        }else {
            [self.titlesArr removeAllObjects];
            [self.titlesArr addObject:model.regionName];
            [self.titlesArr addObject:@"请选择"];
        }
        cell.selected = YES;
        self.selectProvinceIndexPath = indexPath;
        [self getCitiesDataWithRegionId:model.regionId];
    }else if (self.selectIndex == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.selectCityIndexPath != indexPath) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectCityIndexPath];
            cell.selected = NO;
            self.selectAreaIndexPath = nil;
        }
        model = self.cityArr[indexPath.row];
        if (!self.selectCityIndexPath) {
            [self.titlesArr insertObject:model.regionName atIndex:1];
        }else {
            if (self.titlesArr.count ==2) {
                [self.titlesArr addObject:@"请选择"];
            }
            [self.titlesArr replaceObjectAtIndex:1 withObject:model.regionName];
        }
        cell.selected = YES;
        self.selectCityIndexPath = indexPath;
        [self getAreasDataWithRegionId:model.regionId];
    }else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.selectAreaIndexPath != indexPath) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectAreaIndexPath];
            cell.selected = NO;
        }
        model = self.areaArr[indexPath.row];
        [self.titlesArr replaceObjectAtIndex:2 withObject:model.regionName];
        cell.selected = YES;
        self.selectAreaIndexPath = indexPath;
        [self chooseFinishBlock];
    }
    self.topBar.titleArr = self.titlesArr;
}

- (void)chooseFinishBlock {
    [self hideAddressChoose];
    LGAddressRegionModel *provinceModel = self.provinceArr[self.selectProvinceIndexPath.row];
    NSString *provinceId= provinceModel.regionId;
    NSString *provinceName = provinceModel.regionName;
    LGAddressRegionModel *cityModel = self.cityArr[self.selectCityIndexPath.row];
    NSString *cityId= cityModel.regionId;
    NSString *cityName = cityModel.regionName;
    LGAddressRegionModel *areaModel;
    if (self.areaArr.count) {
        areaModel = self.areaArr[self.selectAreaIndexPath.row];
    }
    NSString *areaId= areaModel.regionId.length?areaModel.regionId:@"";
    NSString *areaName = areaModel.regionName.length?areaModel.regionName:@"";
    
    NSDictionary *dic = @{@"provinceId":provinceId,@"provinceName":provinceName,@"cityId":cityId,@"cityName":cityName,@"areaId":areaId,@"areaName":areaName};
    if (self.chooseAddressIdsAndNames) {
        self.chooseAddressIdsAndNames(dic);
    }
}

- (void)handlerTitleAndAddressDataWithIndex:(NSInteger)index {
    self.selectIndex = index;
    [self.tableView reloadData];
}
#pragma mark--lazy-------
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, Screen_W, 280) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (kAPIVersion11Later) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (LGAddressChooseTopBar *)topBar {
    
    if (!_topBar) {
        
        _topBar = [[LGAddressChooseTopBar alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
        _topBar.backgroundColor = [UIColor whiteColor];
        _topBar.titleArr = self.titlesArr;
        __weak typeof(self)weakSelf = self;
        _topBar.chooseAddressBlock = ^(NSInteger index) {
            [weakSelf handlerTitleAndAddressDataWithIndex:index];
        };
    }
    return _topBar;
}
- (NSMutableArray *)titlesArr {
    
    if (!_titlesArr) {
        
        _titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
}
- (NSMutableArray *)provinceArr {
    
    if (!_provinceArr) {
        
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
}
- (NSMutableArray *)cityArr {
    
    if (!_cityArr) {
        
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}
- (NSMutableArray *)areaArr {
    
    if (!_areaArr) {
        
        _areaArr = [NSMutableArray array];
    }
    return _areaArr;
}
@end


@interface LGAddressChooseTopBar ()

@property (nonatomic, strong) UIView *indicatorLine;

@property (nonatomic, strong) UILabel *selectLabel;

@end

@implementation LGAddressChooseTopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setTitleArr:(NSMutableArray *)titleArr {
    _titleArr = titleArr;
    [self setupSubviews];
}
- (void)setupSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = [UIColor colorWithString:@"#f5f5f5"];
    sepView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    [self addSubview:sepView];
    
    [self addSubview:self.indicatorLine];
    
    for (NSInteger i = 0; i<self.titleArr.count; i++) {
        NSString *name = self.titleArr[i];
        CGFloat space = 10;
        CGFloat width = 50;
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((space+width)*i, 0, width, 38)];
        nameLabel.text = name;
        nameLabel.textColor = RGB(66, 62, 62);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.tag = i;
        [self addSubview:nameLabel];
        nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAddressSelect:)];
        [nameLabel addGestureRecognizer:tap];
        if (i == self.titleArr.count-1) {
            [self chooseAddressSelect:tap];
        }
    }
    
}
- (void)chooseAddressSelect:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    if (self.selectLabel != label) {
        self.selectLabel.textColor = RGB(66, 62, 62);
        label.textColor = RGB(255, 0, 82);
        self.indicatorLine.center = CGPointMake(label.center.x, 39);
        self.indicatorLine.bounds = CGRectMake(0, 0, 40, 2);
    }
    self.selectLabel = label;
    if (self.chooseAddressBlock) {
        self.chooseAddressBlock(tap.view.tag);
    }
}
#pragma mark--lazy---
- (UIView *)indicatorLine {
    
    if (!_indicatorLine) {
        
        _indicatorLine = [[UIView alloc]init];
        _indicatorLine.backgroundColor = RGB(255, 0, 82);
    }
    return _indicatorLine;
}
@end
