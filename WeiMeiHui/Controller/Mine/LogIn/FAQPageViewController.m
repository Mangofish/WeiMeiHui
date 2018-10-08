//
//  FAQPageViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "FAQPageViewController.h"
#import "NextFreeNewViewController.h"

@interface FAQPageViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *subTitleView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTablView;

@property (copy, nonatomic) NSArray *dataAry;

@end

@implementation FAQPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
}

- (void)customUI{
    
    _titleView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    _backBtn.frame = CGRectMake(0, SafeAreaTopHeight, 40, 40);
    _subTitleView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, 40);
    _subTitleLab.frame = CGRectMake(Space, 0, kWidth, 40);
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY).offset(0);
    }];
    _mainTablView.frame = CGRectMake(Space, SafeAreaHeight+40+Space+1, kWidth-20, kHeight-SafeAreaHeight-1-40-Space);
    _mainTablView.delegate = self;
    _mainTablView.dataSource = self;
//    _mainTablView.
    [self getData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataAry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.textLabel.text = [self.dataAry[indexPath.row] objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NextFreeNewViewController *reVC = [[NextFreeNewViewController alloc]init];
    reVC.url = [self.dataAry[indexPath.row] objectForKey:@"url"];
    [self.navigationController pushViewController:reVC animated:YES];
    
}

- (void)getData{
    

    
    [YYNet POST:FAQP paramters:@{@"json":@""} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"data"] isKindOfClass:[NSArray class]]) {
            self.dataAry = dic[@"data"];
        }
        
        [self.mainTablView reloadData];
        
        
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
