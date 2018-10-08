//
//  AwardRecordsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AwardRecordsViewController.h"
#import "PickAwardsTableViewCell.h"

#import "NextFreeNewViewController.h"

@interface AwardRecordsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (copy, nonatomic)  NSArray *orderData;



@end

@implementation AwardRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    [self getData];
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);
//        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1-40);
    _mainTableView.rowHeight = 49;
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PickAwardsTableViewCell *cell = [PickAwardsTableViewCell activityThreeTableViewCellRecord];
    cell.recordDic = self.orderData[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}

- (void)getData{
    
    //网络请求
        NSString *uuid = @"";
        if ([PublicMethods isLogIn]) {
            uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        }
    
//    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
//    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
    
    [YYNet POST:LotteryList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self.orderData = dic[@"data"];
        if (self.orderData.count == 0) {
            MJWeakSelf
            self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂无中奖记录" titleStr:@"" detailStr:@"" btnTitleStr:@"" btnClickBlock:^{
                [weakSelf getData];
            }];
        }
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}


- (IBAction)pickAction:(UIButton *)sender {
    
    NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
    
    adVC.url = @"http://try.wmh1181.com/index.php?s=/AppActivity/Activity/prize";
    [self.navigationController pushViewController:adVC animated:YES];
    
}

@end
