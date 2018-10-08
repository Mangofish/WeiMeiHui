//
//  ActivityOrdersDetailViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ActivityOrdersDetailViewController.h"

#import "NormalAuthorTableViewCell.h"
#import "NormalAuthorDEtailTableViewCell.h"
#import "OrderCompleteReplyTableViewCell.h"

@interface ActivityOrdersDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableDictionary *heightDic;
    
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (copy, nonatomic)  NSDictionary *orderDataDic;

@end

@implementation ActivityOrdersDetailViewController

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
    
    [_telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    
//    _orderDataAry = [NSMutableArray array];
     heightDic = [NSMutableDictionary dictionary];
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [heightDic[@(indexPath.section)] doubleValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    活动订单
//    完成
    
    if (_type == 3) {
        
        
        if (indexPath.section == 0) {
            NormalAuthorTableViewCell *cell = [NormalAuthorTableViewCell normalAuthorTableViewCell];
            cell.authorDetail = [AuthorOrdersModel orderInfoWithDict:self.orderDataDic];
            heightDic[@(indexPath.section)] = @(134);
            return cell;
        }
        
        if (indexPath.section == 1) {
            
            NormalAuthorDEtailTableViewCell *cell = [NormalAuthorDEtailTableViewCell normalAuthorDEtailTableViewCell];
            cell.comment = [OrderComment orderCommentWithDict:self.orderDataDic];
            heightDic[@(indexPath.section)] = @(193);
            return cell;
        }
        
        
        if (self.status == 1) {
            
            OrderCompleteReplyTableViewCell *cell = [OrderCompleteReplyTableViewCell orderCompleteReplyTableViewCell];
            cell.order = [OrderComment orderCommentWithDict:self.orderDataDic];
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
            
        
        }else{
            
            
            NormalAuthorDEtailTableViewCell *cell = [NormalAuthorDEtailTableViewCell normalAuthorDEtailTableViewCellFooter];
            heightDic[@(indexPath.section)] = @(193);
            return cell;
            
        }
        
        
        
    }else{
        
       
        if (indexPath.section == 0) {
            NormalAuthorTableViewCell *cell = [NormalAuthorTableViewCell normalAuthorTableViewCell];
            cell.authorDetail = [AuthorOrdersModel orderInfoWithDict:self.orderDataDic];
            heightDic[@(indexPath.section)] = @(134);
            return cell;
        }
        
        if (indexPath.section == 1) {
            
            NormalAuthorDEtailTableViewCell *cell = [NormalAuthorDEtailTableViewCell normalAuthorDEtailTableViewCellTwo];
            heightDic[@(indexPath.section)] = @(125);
            cell.comment = [OrderComment orderCommentWithDict:self.orderDataDic];
            return cell;
        }
        
        
        if (self.status == 1) {
            
            OrderCompleteReplyTableViewCell *cell = [OrderCompleteReplyTableViewCell orderCompleteReplyTableViewCell];
            cell.order = [OrderComment orderCommentWithDict:self.orderDataDic];
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
            
            
        }else{
            
            NormalAuthorDEtailTableViewCell *cell = [NormalAuthorDEtailTableViewCell normalAuthorDEtailTableViewCellFooter];
            heightDic[@(indexPath.section)] = @(193);
            
            return cell;
            
        }
        
        
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    邀请用户评价
    if (self.status == 2 && indexPath.section == 2 ) {
        
        
        
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
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_number":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:self.path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self.orderDataDic = dic[@"data"];
        
        self.status = [self.orderDataDic[@"is_eva"] integerValue];
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (IBAction)serviceAction:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",self.orderDataDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
}
@end
