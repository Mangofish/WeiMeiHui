//
//  ShopCardsDetailsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopCardsDetailsViewController.h"
#import "ShopCardsTableViewCell.h"
#import "ShopCardDetailTableViewCell.h"
#import "UseableShopViewController.h"
#import "ShopCardsCommentsViewController.h"
#import "CardsUseLogViewController.h"
#import "EnableShopListsViewController.h"


@interface ShopCardsDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,ShopCardDetailTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic)  NSMutableDictionary *dataDic;
@property (strong, nonatomic)  NSMutableDictionary *heightDic;

@end

@implementation ShopCardsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _heightDic = [NSMutableDictionary dictionary];
    _dataDic = [NSMutableDictionary dictionary];
    if (self.coupon_ID.length) {
        [self.questionBtn setTitle:@"适用商户" forState:UIControlStateNormal];
    }
    
    [self configNavView];
    [self getData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.dataDic.count) {
        [self getData];
    }
    
//    [self getCardsData];
    
}

- (void)configNavView {
    
    self.tabBarController.tabBar.hidden = YES;
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight);
    _mainTableView.bounces = NO;
   
    
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
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 4;
    }
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (self.coupon_ID.length) {
            ShopCardsTableViewCell *cell = [ShopCardsTableViewCell shopCardsTableViewCellTwo];
            [cell.singleImg sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
            return cell;
        }
        
        ShopCard *card =  [ShopCard shopCardWithDict:self.dataDic];
        
        ShopCardsTableViewCell *cell = [ShopCardsTableViewCell shopCardsTableViewCell];
        cell.card = card;
        
        
        
        return cell;
        
    }else {
        
        if (indexPath.row == 0) {
            
            ShopCard *card =  [ShopCard shopCardWithDict:self.dataDic];
           
            ShopCardDetailTableViewCell *cell = [ShopCardDetailTableViewCell shopCardDetailTableViewCellEr];
            cell.card = [ShopCardDetail shopCardDetailWithDict:self.dataDic];
            
            if ([card.use_type integerValue] == 2) {
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:
                                                    @"仅限本活动合作商户使用查看可用商户"];
                NSRange titleRange = {11,6};
                
                NSRange titleRanget = {0,11};
                
                NSDictionary *dic = @{NSForegroundColorAttributeName: MainColor};
                
                [title addAttributes:dic range:titleRange];
                
                NSDictionary *dic2 = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
                [title addAttributes:dic2 range:titleRanget];
                
                [cell.inforLab setAttributedTitle:title
                                         forState:UIControlStateNormal];
                
            }else{
                
                cell.inforLab.enabled = NO;
                
            }
            
            
            cell.delegate = self;
            cell.conentLab.hidden = YES;
            return cell;
            
        }else{
            
            ShopCardDetailTableViewCell *cell = [ShopCardDetailTableViewCell shopCardDetailTableViewCell];
            
            cell.separatorInset = UIEdgeInsetsMake(44, 0, 0, 0);
            if (indexPath.row == 1) {
                cell.titleLab.text = @"卡片说明：";
                cell.card = [ShopCardDetail shopCardDetailWithDict:self.dataDic];
            }
            
            if (indexPath.row == 2) {
                cell.titleLab.text = @"有效日期：";
                cell.conentLab.textColor = MainColor;
                
                NSMutableDictionary *temp = [NSMutableDictionary dictionary];
                [temp setValuesForKeysWithDictionary:self.dataDic];
                [temp setValue:self.dataDic[@"end_time"] forKey:@"card_summary"];
                
                cell.card = [ShopCardDetail shopCardDetailWithDict:temp];
            }
            
            if (indexPath.row == 3) {
                cell.titleLab.text = @"使用须知：";
                NSMutableDictionary *temp = [NSMutableDictionary dictionary];
                [temp setValuesForKeysWithDictionary:self.dataDic];
                [temp setValue:self.dataDic[@"use_note"] forKey:@"card_summary"];
                
                cell.card = [ShopCardDetail shopCardDetailWithDict:temp];
            }
            
            
            _heightDic[@(indexPath.row)] = @(cell.contentHeight);
            
            return cell;
            
        }
        
    }
    
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 215;
    }
    
    if (indexPath.section == 1 &&  indexPath.row == 0) {
        return 184;
    }
    
    return [_heightDic[@(indexPath.row)] doubleValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
    
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
//
//    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
//    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_number":self.ID}];
    
    NSString *path = MyCardsDE;
    
    if (self.coupon_ID.length) {
        path = MyCouponsDE;
        url = [PublicMethods dataTojsonString:@{@"coupon_id":self.coupon_ID,@"id":self.ID,@"uuid":uuid}];
    }
    
    [YYNet POST:path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            [self.dataDic setDictionary: dic[@"data"]];
            self.titleLab.text = self.dataDic[@"card_name"];
            [self.mainTableView reloadData];
            
            while (1) {
                
                if (self.dataDic.count) {
                    [self getCardsData];
                    break;
                }
                
                
            }
            
        }
        
        
        
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        
    }];
    
}


- (void)getCardsData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    //
    //    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    //    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    if (!self.dataDic[@"remainder"]) {
        return;
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_number":self.ID,@"remainder":self.dataDic[@"remainder"]}];
    
//    NSString *path = MyCardsDE;
//
//    if (self.coupon_ID.length) {
//        path = MyCouponsDE;
//        url = [PublicMethods dataTojsonString:@{@"coupon_id":self.coupon_ID,@"id":self.ID,@"uuid":uuid}];
//    }
    
    [YYNet POST:MyCardsStatus paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([[dic[@"data"] objectForKey:@"status"] integerValue] == 0) {
            
            [self getCardsData];
            
        }else{
            
//            跳转
            ShopCardsCommentsViewController *comVC = [[ShopCardsCommentsViewController alloc]init];
            comVC.ID = [dic[@"data"] objectForKey:@"log_id"];
            comVC.status = @"1";
            [self.navigationController pushViewController:comVC animated:YES];
            
        }
        
    } faild:^(id responseObject) {
        
        [self getCardsData];
        
        
    }];
    
}

- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)useListAcion:(UIButton *)sender {
    
    if (self.coupon_ID.length) {
        
        UseableShopViewController *useVC = [[UseableShopViewController alloc]init];
        useVC.ID = self.coupon_ID;
        [self.navigationController pushViewController:useVC animated:YES];
        
        
    }else{
        
        CardsUseLogViewController *useVC = [[CardsUseLogViewController alloc]init];
        useVC.ID = self.ID;
        [self.navigationController pushViewController:useVC animated:YES];
        
    }
    
    
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [self.dataDic removeAllObjects];
    
}


- (void)didClickMenu{
    
    EnableShopListsViewController *shopVC = [[EnableShopListsViewController alloc]init];
    shopVC.ID = self.dataDic[@"id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}


@end
