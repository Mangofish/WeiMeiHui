//
//  WeiOrderWaitUseViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/6/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiOrderWaitUseViewController.h"

#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "AlertView.h"
#import "ErCodeOrderTableViewCell.h"
#import "ThreeTypeOrderTableViewCell.h"
#import "AuthorDetailViewController.h"
#import "GoodsDetailViewController.h"


@interface WeiOrderWaitUseViewController ()<UITableViewDelegate,UITableViewDataSource,AlertViewDelegate>
{
    
    AlertView *alert;
    UIView *bgTapView;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong,nonatomic) NSMutableArray *authorDataAry;

@property (copy,nonatomic) NSDictionary *dataDic;

@end

@implementation WeiOrderWaitUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavView];
    [self getData];
    
}

- (void)configNavView {
    
    //    微信订单
    if ([self.type integerValue] == 5 || [self.type integerValue] == 6) {
        
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
    
    //    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    //
    
    //    self.mainTableView.delegate  =self;
    //    self.mainTableView.dataSource = self;
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-44);
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _authorDataAry = [NSMutableArray array];
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (!self.dataDic) {
        return 0;
    }
    
    return 3+self.authorDataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ShopAuthor *author ;
    if (section > 2) {
        author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[section-3]];
    }
    
    if (section >= 2 && author.author_goods.count) {
        
        return 2;
        
    }
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 2) {
        return 190;
    }
    
    if (indexPath.section == 0) {
        
        return 60;
        
    }
    
    if (indexPath.section >= 3) {
        
        if (indexPath.row == 0 ) {
            
            return 88;
            
        }
        
        return 49;
        
    }
    
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        return 44;
    }
    
    
    return 0.00001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    if (section == 3) {
        
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellHeaderAuthor];
        cell.titleLab.text = @"活动参与手艺人";
        return cell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    订单状态
    if (indexPath.section == 0) {
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        cell.order = [GoodsDetail authorGoodsWithDict:self.dataDic];
        
        cell.status.text = self.status;
        
        return cell;
        
    }else if (indexPath.section == 1) {
        
//        参数不一样
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        cell.weiorder = [GoodsDetail authorGoodsWithDict:self.dataDic];
        
        return cell;
       
    }else if(indexPath.section == 2){
        
        ErCodeOrderTableViewCell *cell = [ErCodeOrderTableViewCell erCodeOrderTableViewCellEasy];
        if (self.dataDic) {
            cell.goodsDetailEasy = [ThreeOrder recentOrderWithDict:self.dataDic];
        }
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            
            ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            
            if (cell == nil) {
                cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            }
            
            cell.author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[indexPath.section-3]];
            return cell;
            
        }else{
            
            ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            if (cell == nil) {
                cell = [ALLAuthorsTableViewCell allAuthorsTableViewCellSecond];
            }
            
            ShopAuthor *author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[indexPath.section-3]];
            cell.goods = [AuthorGoods authorGoodsWithDict:author.author_goods[indexPath.row-1]];
            return cell;
            
        }
        
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section >= 3 ) {

        if (indexPath.row == 0) {
            
            NSString *uuid = [self.authorDataAry[indexPath.section-3] objectForKey:@"author_uuid"];
            AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
            detailVc.ID = uuid;
            [self.navigationController pushViewController:detailVc animated:YES];
            
        }else{
            
            NSArray *temp = [self.authorDataAry[indexPath.section-3] objectForKey:@"author_goods"];
            
            NSString *uuid = [temp[indexPath.row-1] objectForKey:@"id"];
            GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
            detailVc.ID = uuid;
            detailVc.isGroup = [[temp[indexPath.row-1] objectForKey:@"is_group"] integerValue];
            [self.navigationController pushViewController:detailVc animated:YES];
            
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
        
        self.dataDic = dic[@"data"];
        self.authorDataAry = self.dataDic[@"author_list"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mainTableView reloadData];
        });
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (void)didClickMenuIndex:(NSInteger)index{
    
    
    if (index == 1 ) {
        //        退款
        [self payback];
    }
    
    //          移除
    [UIView animateWithDuration:0.3 animations:^{
        self->alert.frame  =  CGRectMake(Space, kHeight, kWidth-Space*2, 131);
        self->bgTapView.hidden  = YES;
    }completion:^(BOOL finished) {
        [self->bgTapView removeFromSuperview];
        [self->alert removeFromSuperview];
    }];
    
    
}
#pragma mark - 申请退款
- (IBAction)applyForMoney:(UIButton *)sender {
    if (!_ID.length) {
        return;
    }
    
    bgTapView = [[UIView alloc]initWithFrame:self.view.bounds];
    bgTapView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    bgTapView.tag = 100;
    [self.view addSubview:bgTapView];
    
    CGSize size = CGSizeMake(100, MAXFLOAT);
    //设置高度宽度的最大限度
    CGRect rect = [@"平台客服会在24小时内与店家沟通进行退款，申请成功后款项将原路退回，是否确认退款？" boundingRectWithSize:size options: NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
    
    AlertView *alertView = [AlertView alertViewWithFrame:CGRectMake(Space, kHeight-rect.size.height-20, kWidth-Space*2, rect.size.height)];
    alertView.delegate = self;
    alert = alertView;
    //    alert.titleLab.frame = CGRectMake(Space, Space, kWidth-Space*2, rect.size.height);
    alert.titleLab.text = @"平台客服会在24小时内与店家沟通进行退款，申请成功后款项将原路退回，是否确认退款？";
    [self.view addSubview:alertView];
    
    
}

- (void)payback{
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_number":_ID}];
    
    [YYNet POST:WeiUserApply paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        if ([dict[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

#pragma mark -联系客服
- (IBAction)telAction:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",_dataDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
}

@end
