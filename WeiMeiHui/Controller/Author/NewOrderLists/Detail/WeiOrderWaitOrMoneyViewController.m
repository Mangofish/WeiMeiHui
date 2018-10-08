//
//  WeiOrderWaitOrMoneyViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/6/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiOrderWaitOrMoneyViewController.h"

#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"

#import "PayStyleViewController.h"
#import "ALLAuthorsTableViewCell.h"
#import "AuthorDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "ThreeTypeOrderTableViewCell.h"

#import "NextFreeNewViewController.h"

@interface WeiOrderWaitOrMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,ThreeTypeOrderTableViewCellDelegate>
{
    NSMutableDictionary *heightDic;
    NSDictionary *dataDic;
    
}

@property (strong,nonatomic) NSMutableArray *authorDataAry;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation WeiOrderWaitOrMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    [self getData];
}

- (void)configNavView {
    
    if ([self.type integerValue] == 5 || [self.type integerValue] == 6) {
        [_cancelBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        _payBtn.hidden = YES;
    }
    
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
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-44);
    //
    
    self.mainTableView.delegate  =self;
    self.mainTableView.dataSource = self;
    
    _authorDataAry = [NSMutableArray array];
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!dataDic) {
        return 0;
    }
    
    return 2+self.authorDataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShopAuthor *author ;
    if (section > 1) {
        author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[section-2]];
    }
    
    if (section > 1 && author.author_goods.count) {
        
        return 2;
        
    }
    
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section > 1) {
        
        if (indexPath.row == 0 ) {
            
            return 88;
            
        }
        
        return 49;
        
    }
    
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section == 1) {
        
        if ([self.type integerValue] == 5 || [self.type integerValue] == 6) {
            return 44;
        }
    }
   
    
    return Space;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    
    
    return 0.00001;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    if (section == 2) {
        
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellHeaderAuthor];
        cell.titleLab.text = @"活动参与手艺人";
        return cell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        if ([self.type integerValue] == 5 || [self.type integerValue] == 6) {
            ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellFooterPay];
            cell.delegate = self;
            return cell;
        }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        cell.order = [GoodsDetail authorGoodsWithDict:dataDic];
        cell.status.text = self.status;
        return cell;
        
    }else if (indexPath.section == 1){
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        cell.weiorder = [GoodsDetail authorGoodsWithDict:dataDic];
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            
            ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            
            if (cell == nil) {
                cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            }
            
            
            cell.author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[indexPath.section-2]];
            return cell;
            
        }else{
            
            ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            if (cell == nil) {
                cell = [ALLAuthorsTableViewCell allAuthorsTableViewCellSecond];
            }
            
            ShopAuthor *author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[indexPath.section-2]];
            cell.goods = [AuthorGoods authorGoodsWithDict:author.author_goods[indexPath.row-1]];
            return cell;
            
        }
        
    }
    
    
}

- (void)getData{
    
    //网络请求
    //    NSString *uuid = @"";
    //    if ([PublicMethods isLogIn]) {
    //        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    //    }
    
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:WeiOrderDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->dataDic = dic[@"data"];
        
        if ([[dic[@"data"] objectForKey:@"author_list"] isKindOfClass:[NSArray class]]) {
            self.authorDataAry = [dic[@"data"] objectForKey:@"author_list"];
        }
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        
        
        
    }];
    
}




#pragma  mark - 去支付
- (IBAction)payAction:(UIButton *)sender {
    
    PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
    payVC.ordernumber = [dataDic objectForKey:@"order_number"];
    payVC.price = [dataDic objectForKey:@"pay_price"];
   
    if ([self.type integerValue] == 0) {
        payVC.notifyUrlAli = @"http://try.wmh1181.com/WMHFriend/Activity/AliCutPay";
        payVC.notifyUrlWeixin = @"http://try.wmh1181.com/WMHFriend/Activity/WeCutPay";
    }
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}


#pragma  mark - 取消订单/电话
- (IBAction)cancelAction:(UIButton *)sender {
    
    if ([self.type integerValue] == 5 || [self.type integerValue] == 6) {
        
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",dataDic[@"tel"]]]]];
        [self.view addSubview:callWebview];
        
        return;
        
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_number":dataDic[@"order_number"]}];
    
    [YYNet POST:WeiOrderCancel paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已取消" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
            
        }else{
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section >= 2 ) {
        
        if (indexPath.row == 0) {
            
            
            NSString *uuid = [self.authorDataAry[indexPath.section-2] objectForKey:@"author_uuid"];
            AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
            detailVc.ID = uuid;
            [self.navigationController pushViewController:detailVc animated:YES];
            
        }else{
            
            NSArray *temp = [self.authorDataAry[indexPath.section-2] objectForKey:@"author_goods"];
            
            NSString *uuid = [temp[indexPath.row-1] objectForKey:@"id"];
            GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
            detailVc.ID = uuid;
            detailVc.isGroup = [[temp[indexPath.row-1] objectForKey:@"is_group"] integerValue];
            [self.navigationController pushViewController:detailVc animated:YES];
            
        }
        
       
        
    }
    
    
    
}

@end
