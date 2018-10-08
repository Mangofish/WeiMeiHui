//
//  OrderCompletedViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "OrderCompletedViewController.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "OrderCompleteReplyTableViewCell.h"
#import "FamousGoodsTableViewCell.h"

@interface OrderCompletedViewController ()<UITableViewDelegate, UITableViewDataSource>{

    CGFloat cellHeight;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (copy, nonatomic)  NSDictionary *orderDataDic;

@end

@implementation OrderCompletedViewController

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
    
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    
    //    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [self getData];
    //    }];
    
    //    [_mainTableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.orderDataDic) {
        return 0;
    }
    
    return 3;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        cell.order = [GoodsDetail authorGoodsWithDict:self.orderDataDic];
        
        cell.status.text = self.status;
        
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            if ([self.type integerValue] == 5) {
                
                FamousGoodsTableViewCell *cell = [FamousGoodsTableViewCell famousGoodsTableViewCellDetail];
                cell.goods = [AuthorGoods authorGoodsWithDict:self.orderDataDic];
                cell.redView.hidden = YES;
                return cell;
                
            }else{
                
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
                cell.goodsDetail = [GoodsDetail authorGoodsWithDict:self.orderDataDic];
                return cell;
                
            }
            
//            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
//            cell.goodsDetail = [GoodsDetail authorGoodsWithDict:self.orderDataDic];
//            return cell;
        }
        
        if (indexPath.row == 1) {
            ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            cell.author = [ShopAuthor shopAuthorWithDict:self.orderDataDic];
            return cell;
        }
        
        if ([self.type integerValue] == 3) {
            
            if (indexPath.row == 2) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOne];
                cell.goodsDetail = [GoodsDetail authorGoodsWithDict:self.orderDataDic];
                return cell;
            }
            
            if (indexPath.row == 3) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            }
            
        }else{
            if (indexPath.row == 2) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            }
        }
        
    }
    
//    回复
    OrderCompleteReplyTableViewCell *cell = [OrderCompleteReplyTableViewCell orderCompleteReplyTableViewCell];
    cell.order = [OrderComment orderCommentWithDict:self.orderDataDic];
    cellHeight = cell.cellHeight;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if ([self.type integerValue] == 4) {
                return 40;
            }
            
            if ([self.type integerValue] == 5) {
                return 88;
            }
            
            return 60;
        }
        
        if (indexPath.row == 1) {
            return 88;
        }
        
        return 44;
    }
    
    if (indexPath.section == 2) {
        
        return cellHeight;
        
    }
    
    if (indexPath.section == 0) {
        
        return 60;
        
    }
    
    return 155;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}


- (void)getData{
    
    //网络请求
    //    NSString *uuid = @"";
    //    if ([PublicMethods isLogIn]) {
    //        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    //    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
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
    
    if ([self.type integerValue] == 4) {
        path = WeiOrderDetail;
    }
    
    if ([self.type integerValue] == 5) {
        path = KillOrderDetail;
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.orderDataDic = dic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mainTableView reloadData];
        });
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (IBAction)serviceAction:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",self.orderDataDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
