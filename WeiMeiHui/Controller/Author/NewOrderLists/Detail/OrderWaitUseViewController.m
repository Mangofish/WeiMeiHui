//
//  OrderWaitUseViewController.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "OrderWaitUseViewController.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "AlertView.h"
#import "ErCodeOrderTableViewCell.h"

@interface OrderWaitUseViewController ()<UITableViewDelegate,UITableViewDataSource,AlertViewDelegate>
{
    
    AlertView *alert;
    UIView *bgTapView;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


@property (copy,nonatomic) NSDictionary *dataDic;
@end

@implementation OrderWaitUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self configNavView];
    [self getData];
    
}

- (void)configNavView {
    
//    微信订单
    if ([self.type integerValue] == 4) {
        _cancelBtn.hidden = YES;
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
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.dataDic) {
        return 0;
    }
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        
        if ([_type integerValue] == 4) {
            return 1;
        }
        
        return 3;
    }
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if ([self.type integerValue] == 4) {
                return 40;
            }
            
            return 60;
        }
        
        if (indexPath.row == 1) {
            return 88;
        }
        
    }
    
    if (indexPath.section == 2) {
        
        if ([self.type integerValue] == 2) {
            
            return 288;
            
        }else{
            
            return 190;
            
        }
       
        
    }
    
    if (indexPath.section == 0) {
        
        return 60;
        
    }
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        cell.order = [GoodsDetail authorGoodsWithDict:self.dataDic];
        
        cell.status.text = self.status;
            
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
            cell.goodsDetail = [GoodsDetail authorGoodsWithDict:self.dataDic];
            return cell;
        }
        
        if ([_type integerValue] == 4) {
            
            if (indexPath.row == 1) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            }
            
        }
        
        if (indexPath.row == 1) {
            ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            cell.author = [ShopAuthor shopAuthorWithDict:self.dataDic];
            return cell;
        }
        
        if (indexPath.row == 2) {
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
            return cell;
        }
    }
    
    if ([self.type integerValue] == 2) {
        
        ErCodeOrderTableViewCell *cell = [ErCodeOrderTableViewCell erCodeOrderTableViewCell];
        
        if (self.dataDic) {
             cell.goodsDetail = [GoodsDetail authorGoodsWithDict:self.dataDic];
        }
        
       
        return cell;
        
    }else{
        
        ErCodeOrderTableViewCell *cell = [ErCodeOrderTableViewCell erCodeOrderTableViewCellEasy];
        if (self.dataDic) {
            cell.goodsDetailEasy = [ThreeOrder recentOrderWithDict:self.dataDic];
        }
        return cell;
        
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
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.dataDic = dic[@"data"];
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
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID}];
    
    [YYNet POST:GroupUserApply paramters:@{@"json":url} success:^(id responseObject) {
        
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


@end
