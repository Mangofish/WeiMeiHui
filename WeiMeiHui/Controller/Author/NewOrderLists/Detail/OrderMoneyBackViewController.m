//
//  OrderMoneyBackViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "OrderMoneyBackViewController.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "ThreeTypeOrderTableViewCell.h"
#import "NextFreeNewViewController.h"

@interface OrderMoneyBackViewController ()<UITableViewDelegate,UITableViewDataSource,ThreeTypeOrderTableViewCellDelegate>
{
    NSDictionary *dataDic;
}


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation OrderMoneyBackViewController

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
    _titleLab.text = self.titleStr;
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    //
    
    self.mainTableView.delegate  =self;
    self.mainTableView.dataSource = self;
    
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!dataDic) {
        return 0;
    }
    
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        
        if ([self.type integerValue] == 3) {
            return 4;
        }
        
        return 3;
    }
    
    return 1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
//        if ([self.type integerValue] == 5 || [self.type integerValue] == 6) {
            ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellFooterPay];
            cell.delegate = self;
            return cell;
//    }
    }
    
    return nil;
}

#pragma mark - 查看帮助
- (void)checkAllAction{
    
    NSString *url = dataDic[@"refund_help"];
    NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
    lists.url = url;
    [self.navigationController pushViewController:lists animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            return 60;
        }
        
        if (indexPath.row == 1) {
            return 88;
        }
        
        return 44;
    }
    
    
    if (indexPath.section == 0) {
        
        return 60;
        
    }
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return Space;
    }
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        cell.order = [GoodsDetail authorGoodsWithDict:dataDic];
        cell.status.text = self.status;
        return cell;
        
    }else  {
        
        if (indexPath.row == 0) {
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
            cell.goodsDetail = [GoodsDetail authorGoodsWithDict:dataDic];
            return cell;
        }
        
        if (indexPath.row == 1) {
            ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            cell.author = [ShopAuthor shopAuthorWithDict:dataDic];
            return cell;
        }
        
        if ([self.type integerValue] == 3) {
            
            if (indexPath.row == 2) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOne];
                cell.goodsDetail = [GoodsDetail authorGoodsWithDict:dataDic];
                return cell;
            }
            
            if (indexPath.row == 3) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            }
            
        }else{
            
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            
        }
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
            return cell;
        
    }
    
   
    
}

- (void)getData{
    
    //网络请求
    //    NSString *uuid = @"";
    //    if ([PublicMethods isLogIn]) {
    //        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    //    }
    
    NSString *path = @"";
    if ([self.type integerValue] == 1) {
        path = PayOrderDetail;
    }
    
    if ([self.type integerValue] == 2) {
        path = GroupOrderDetails;
    }
    
    if ([self.type integerValue] == 3) {
        path = ActOrderDetails;
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->dataDic = dic[@"data"];
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (IBAction)serviceAction:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",dataDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
}

@end
