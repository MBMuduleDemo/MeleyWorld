//
//  LGActiveListViewController.m
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//  优惠活动列表页

#import "LGActiveListViewController.h"
#import "LGActiveListCell.h"
//活动详情页
#import "LGActiveDetailViewController.h"
@interface LGActiveListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong)UITableView *myTableView;

@property (nonatomic , strong)NSMutableArray *activeArry;

@property (nonatomic , copy)NSString *currentPage;


@end

@implementation LGActiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"优惠活动";
    [self.view addSubview:self.myTableView];

    self.currentPage = @"1";
    [self refreshData];
}

-(void)refreshData{
    self.currentPage = @"1";
    [self requestData];
}

-(void)requestData{
    [RequestUtil withGET:@"/api/mw/activity/list.action" parameters:@"pageSize=10000&page=1" success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"1"]) {
            if ([self.currentPage isEqualToString:@"1"]) {
                [self.activeArry removeAllObjects];
            }
            NSDictionary *dic = responseObject[@"result"];
            if ([dic[@"curPage"] integerValue] < [dic[@"totalPage"] integerValue]) {
                self.currentPage = [NSString stringWithFormat:@"%ld",[dic[@"curPage"] integerValue]+1];
            }else{
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
                self.myTableView.mj_footer.hidden = YES;
            }
            [self.activeArry addObjectsFromArray:dic[@"activityList"]];
            [self.myTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activeArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGActiveListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.activeArry.count) {
        cell.dataDic = self.activeArry[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.activeArry.count) {
        LGActiveDetailViewController *controller = [[LGActiveDetailViewController alloc]init];
        controller.dataDic = self.activeArry[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark -- 创建控件
-(NSMutableArray *)activeArry{
    if (!_activeArry) {
        _activeArry = [NSMutableArray array];
    }
    return _activeArry;
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight) style:UITableViewStylePlain];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = viewPix(280);
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        if (kAPIVersion11Later) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        [_myTableView registerClass:[LGActiveListCell class] forCellReuseIdentifier:@"cell"];
    }
    return _myTableView;
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
