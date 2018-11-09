//
//  MLLocationSelectView.m
//  meyley
//
//  Created by chsasaw on 2017/5/30.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLLocationSelectView.h"
#import "MBProgressHUD+HXS.h"
#import "MLRegion.h"
#import "MLRegionRequestModel.h"

@interface MLLocationTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *checkMarkImageView;

@end

@implementation MLLocationTableViewCell

@end

@interface MLLocationSelectView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray<MLRegion *> *provinceRegions;
@property (nonatomic, strong) NSMutableArray<MLRegion *> *cityRegions;
@property (nonatomic, strong) NSMutableArray<MLRegion *> *districtRegions;

@property (nonatomic, strong) MLRegion *province;
@property (nonatomic, strong) MLRegion *city;
@property (nonatomic, strong) MLRegion *district;

@end

@implementation MLLocationSelectView

+ (instancetype)selectView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isLoading = NO;
    self.currentIndex = 0;
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (IBAction)onSelectButton:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(selectView:onClickIndex:)]) {
        [self.delegate selectView:self onClickIndex:sender.tag];
    }
    [self startSelectIndex:sender.tag];
}

- (void)startSelectIndex:(NSInteger)index {
    if(self.isLoading) {
        [MBProgressHUD showInViewWithoutIndicator:self.tableView.superview status:@"正在加载中" afterDelay:1];
        return;
    }
    
    if(index == 2 && _province == nil) {
        [MBProgressHUD showInViewWithoutIndicator:self.tableView.superview status:@"请先选择省份" afterDelay:2];
    }else if(index == 3 && _city == nil) {
        [MBProgressHUD showInViewWithoutIndicator:self.tableView.superview status:@"请先选择省份和城市" afterDelay:2];
    }else if(_currentIndex != index){
        _currentIndex = index;
        
        if(self.selectRegions.count == 0) {
            [self loadDataSource];
        }
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    }
}

- (void)loadDataSource {
    
    if(self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    
    if(_currentIndex == 1) {
        [MLRegionRequestModel getRegionListWithComplete:^(HXSErrorCode code, NSString *message, NSArray<MLRegion *> *regions) {
            self.isLoading = NO;
            
            if(code == kHXSNoError) {
                [self.provinceRegions removeAllObjects];
                [self.provinceRegions addObjectsFromArray:regions];
            }else {
                [MBProgressHUD showInViewWithoutIndicator:self.tableView.superview status:message afterDelay:1.5];
            }
            
            [self.tableView reloadData];
        }];
    }else if(_currentIndex == 2) {
        [MLRegionRequestModel getRegionWithParentId:self.province.regionId complete:^(HXSErrorCode code, NSString *message, NSArray<MLRegion *> *regions) {
            self.isLoading = NO;
            
            if(code == kHXSNoError) {
                [self.cityRegions removeAllObjects];
                [self.cityRegions addObjectsFromArray:regions];
            }else {
                [MBProgressHUD showInViewWithoutIndicator:self.tableView.superview status:message afterDelay:1.5];
            }
            
            [self.tableView reloadData];
        }];
    }else if(_currentIndex == 3) {
        [MLRegionRequestModel getRegionWithParentId:self.city.regionId complete:^(HXSErrorCode code, NSString *message, NSArray<MLRegion *> *regions) {
            self.isLoading = NO;
            
            if(code == kHXSNoError) {
                [self.districtRegions removeAllObjects];
                [self.districtRegions addObjectsFromArray:regions];
            }else {
                [MBProgressHUD showInViewWithoutIndicator:self.tableView.superview status:message afterDelay:1.5];
            }
            
            [self.tableView reloadData];
        }];
    }
}

- (void)refreshSelectView {
    if(self.province) {
        [self.button1 setTitle:[NSString stringWithFormat:@" %@   v", self.province.regionName ] forState:UIControlStateNormal];
    }else {
        [self.button1 setTitle:[NSString stringWithFormat:@"%@  v", @"选择省份" ] forState:UIControlStateNormal];
    }
    
    if(self.city) {
        [self.button2 setTitle:[NSString stringWithFormat:@" %@   v", self.city.regionName ] forState:UIControlStateNormal];
    }else {
        [self.button2 setTitle:[NSString stringWithFormat:@"%@  v", @"选择城市" ] forState:UIControlStateNormal];
    }
    
    if(self.district) {
        [self.button3 setTitle:[NSString stringWithFormat:@" %@   v", self.district.regionName ] forState:UIControlStateNormal];
    }else {
        [self.button3 setTitle:[NSString stringWithFormat:@"%@  v", @"选择区域" ] forState:UIControlStateNormal];
    }
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectRegions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLLocationTableViewCell"];
    cell.nameLabel.text = self.selectRegions[indexPath.row].regionName;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([self.selectRegion.regionId isEqualToNumber:self.selectRegions[indexPath.row].regionId]) {
        cell.checkMarkImageView.hidden = NO;
        [cell.nameLabel setTextColor:ML_ACCENT_COLOR];
        [cell.checkMarkImageView setImage:[UIImage imageNamed:@"xianz"]];
    }else {
        [cell.nameLabel setTextColor:ML_TEXT_MAIN_COLOR];
        cell.checkMarkImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MLRegion *region = self.selectRegions[indexPath.row];
    if(_currentIndex == 1) {
        [self setProvince:region];
    }else if(_currentIndex == 2) {
        [self setCity:region];
    }else {
        [self setDistrict:region];
    }
}

#pragma getters
- (NSMutableArray<MLRegion *> *)selectRegions {
    if(_currentIndex == 1) {
        return self.provinceRegions;
    }else if(_currentIndex == 2) {
        return self.cityRegions;
    }else if(_currentIndex == 3){
        return self.districtRegions;
    }else {
        return nil;
    }
}

- (MLRegion *)selectRegion {
    if(_currentIndex == 1) {
        return self.province;
    }else if(_currentIndex == 2) {
        return self.city;
    }else if(_currentIndex == 3){
        return self.district;
    }else {
        return nil;
    }
}

- (NSMutableArray<MLRegion *> *)provinceRegions {
    if(!_provinceRegions) {
        _provinceRegions = [NSMutableArray array];
    }
    
    return _provinceRegions;
}

- (NSMutableArray<MLRegion *> *)cityRegions {
    if(!_cityRegions) {
        _cityRegions = [NSMutableArray array];
    }
    
    return _cityRegions;
}

- (NSMutableArray<MLRegion *> *)districtRegions {
    if(!_districtRegions) {
        _districtRegions = [NSMutableArray array];
    }
    
    return _districtRegions;
}

#pragma mark - setters
- (void)setProvince:(MLRegion *)province {
    if(!_province || ![province.regionId isEqualToNumber:_province.regionId]) {
        _province = province;
        _city = nil;
        _district = nil;
        [self.cityRegions removeAllObjects];
        [self.districtRegions removeAllObjects];
    }
    
    [self.tableView setHidden:YES];
    _currentIndex = 0;
    [self refreshSelectView];
}

- (void)setCity:(MLRegion *)city {
    if(!_city || ![city.regionId isEqualToNumber:_city.regionId]) {
        _city = city;
        _district = nil;
        [self.districtRegions removeAllObjects];
    }
    
    [self.tableView setHidden:YES];
    _currentIndex = 0;
    [self refreshSelectView];
}

- (void)setDistrict:(MLRegion *)district {
    if(!_district || ![district.regionId isEqualToNumber:_district.regionId]) {
        _district = district;
    }
    
    [self.tableView setHidden:YES];
    _currentIndex = 0;
    [self refreshSelectView];
    
    if([self.delegate respondsToSelector:@selector(selectView:onSelectProvince:city:district:)]) {
        [self.delegate selectView:self onSelectProvince:_province.regionId city:_city.regionId district:_district.regionId];
    }
}

@end
