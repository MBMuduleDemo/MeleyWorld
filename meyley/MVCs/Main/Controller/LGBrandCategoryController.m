//
//  LGBrandCategoryController.m
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//  分类--品牌

#import "LGBrandCategoryController.h"
#import "LGBrandViewController.h"
#import "LGCategoryViewController.h"
//搜索
#import "LGSearchResultController.h"

@interface LGBrandCategoryController ()<UITextFieldDelegate>
//导航栏搜索框
@property (nonatomic, strong) UITextField *textfield;

@property (nonatomic, strong) MBPageContentView *contentView;
@property (nonatomic, strong) MBSegmentScrollView *segmentView;


@end

@implementation LGBrandCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];

    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.contentView];
    if (self.selectType == LGShowTypeCategory) {
        [self.segmentView setSelectedIndex:0 animated:NO];
    }else {
        [self.segmentView setSelectedIndex:1 animated:NO];
    }
}

- (void)setupNavBar {
    self.navigationItem.titleView = self.textfield;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
}
#pragma mark---action----
- (void)search {
    [self.textfield resignFirstResponder];
    if (self.textfield.text.length>0) {
        LGSearchResultController *searchVC= [LGSearchResultController new];
        searchVC.keywords = self.textfield.text;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}
#pragma mark----UITextFieldDelegate--
-(void)textFieldValueChaged:(UITextField *)textField{
    [self search];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textfield resignFirstResponder];
    return YES;
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

- (MBPageContentView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[MBPageContentView alloc]initWithFrame:CGRectMake(0, 44, Screen_W, Screen_H-topBarHeight-44) segmentView:self.segmentView childVCs:@[[LGCategoryViewController new],[LGBrandViewController new]] parentViewController:self];
    }
    return _contentView;
}

- (MBSegmentScrollView *)segmentView {
    
    if (!_segmentView) {
        MBSegmentStyle *style = [[MBSegmentStyle alloc]init];
        style.showLine = YES;
        style.titleMargin = (Screen_W-60)/2;
        style.edgeMargin = 0.0;
        style.scrollLineWidth = 50;
        style.titleFont = [UIFont systemFontOfSize:14];
        style.scrollLineColor = [UIColor colorWithString:@"#ff0052"];
        style.scrollLineBottomMargin = 0;
        style.normalTitleColor = [UIColor colorWithString:@"#616161"];
        style.selectedTitleColor = [UIColor colorWithString:@"#ff0052"];
        __weak typeof(self)weakSelf = self;
        _segmentView = [[MBSegmentScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 44) segmentStyle:style titles:@[@"分类",@"品牌"] margin:0 titleDidClick:^(UILabel *titleLabel, NSInteger index) {
            [weakSelf.contentView setSelectItemIndex:index];
        }];
        _segmentView.backgroundColor = [UIColor whiteColor];
    }
    return _segmentView;
}
@end
