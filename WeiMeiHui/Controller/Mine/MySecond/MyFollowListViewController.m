//
//  MyFollowListViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyFollowListViewController.h"
#import "MineFlollowTableViewCell.h"

#import "UserDetailViewController.h"
#import "AuthorDetailViewController.h"

@interface MyFollowListViewController ()<UITableViewDelegate,UITableViewDataSource,MineFlollowTableViewCellDelegate>{
    
//    NSDictionary *_dataDic;
    NSUInteger page;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

/** 字母索引*/
@property (nonatomic, copy) NSArray *characterMutableArray;
/** 手艺人名称*/
@property (nonatomic, strong) NSMutableArray *authorMutableArray;
@property (nonatomic, copy) NSDictionary *dataDic;

@end

@implementation MyFollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self configNavView];
}

- (void)configNavView {
    
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
    
    if (_type == 1) {
        _titleLab.text = @"我的粉丝";
    }else{
        _titleLab.text = @"我的关注";
    }
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight-Space);
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self->page++;
        [self getData];
    }];
    
    [_mainTableView.mj_header beginRefreshing];
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mainTableView.sectionIndexColor=LightFontColor;
    _authorMutableArray = [NSMutableArray array];
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
    NSString *path = MineFollows;
    if (_type == 1) {
        path =  MineFans;
    }
    
    [YYNet POST:path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSDictionary *temp = @{};
        
        if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            temp = [dic objectForKey:@"data"];
        }
        
            if (temp.count == 0) {
                self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有关注"
                                                                            titleStr:@""
                                                                           detailStr:@""];
            }
        
        self.dataDic = temp;
        
        for (int i=0 ; i<temp.allValues.count; i++) {
            
            NSArray *value = temp.allValues[i];
            for (int j = 0; j<value.count; j++) {
                [self.authorMutableArray addObject:value[j]];
            }
            
        }
        
//        self.authorMutableArray = self.dataDic.allValues;
        self.characterMutableArray = self.dataDic.allKeys;
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
        
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _characterMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = _characterMutableArray[section];
    NSArray *value = [self.dataDic objectForKey:key];
    
    return value.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *key = _characterMutableArray[indexPath.section];
    NSArray *value = [self.dataDic objectForKey:key];
    
    
    MineFlollowTableViewCell *cell = nil;
   
    if (_type == 1) {
        
        cell =  [MineFlollowTableViewCell mineFlollowTableViewCellFans];
        cell.fansModel = [MineFollow orderCommentWithDict:value[indexPath.row]];
        
    }else{
        
        cell = [MineFlollowTableViewCell mineFlollowTableViewCell];
        cell.followModel = [MineFollow orderCommentWithDict:value[indexPath.row]];

    }
    
    NSDictionary *obj = value[indexPath.row];
    
    for (int i=0; i<self.authorMutableArray.count ; i++) {
        
        NSDictionary *objT = self.authorMutableArray[i];
        if ([obj isEqualToDictionary:objT]) {
            cell.isFollowBtn.tag = i;
        }
        
    }
    
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(44, 10, 0, 28);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

//设置右侧索引的标题，这里返回的是一个数组哦！
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _characterMutableArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth-28, 44)];
    lab.font = [UIFont systemFontOfSize:12];
    lab.backgroundColor = MJRefreshColor(240, 240, 240);
    lab.textColor = MJRefreshColor(153, 153, 153);      
    lab.text = [NSString stringWithFormat:@"    %@",_characterMutableArray[section]];
    
    [v addSubview:lab];
    return v;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *key = _characterMutableArray[indexPath.section];
    NSArray *value = [self.dataDic objectForKey:key];
    
    NSUInteger level = [[value[indexPath.row] objectForKey:@"level"] integerValue];

    if (level == 3) {

        UserDetailViewController *detailVc= [[UserDetailViewController alloc]init];
        detailVc.ID = [value[indexPath.row] objectForKey:@"uuid"];
        [self.navigationController pushViewController:detailVc animated:YES];

    }else{
        AuthorDetailViewController *detailVc= [[AuthorDetailViewController alloc]init];
        detailVc.ID = [value[indexPath.row] objectForKey:@"uuid"];
        [self.navigationController pushViewController:detailVc animated:YES];


    }
    
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 关注/取关
- (void)didClickFollowIndex:(NSInteger)index{
    
   
    
    if (self.type != 1) {
         NSString *cVStr = @"确定取消对此人的关注";
        
        CKAlertViewController *cV =  [CKAlertViewController alertControllerWithTitle:@"" message:cVStr];
        
        CKAlertAction *action = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
            
            
            
        } ];
        
        CKAlertAction *action2 = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
            
            NSString *touuid = [self.authorMutableArray[index] objectForKey:@"uuid"];
            
            
            NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
            //
            NSString *url = [PublicMethods dataTojsonString:@{@"from_uuid":uuid,@"to_uuid":touuid}];
            //
            [YYNet POST:FriendFollow paramters:@{@"json":url} success:^(id responseObject) {
                
                //        NSDictionary *dict = [solveJsonData changeType:responseObject];
                [self.mainTableView.mj_header beginRefreshing];
                
            } faild:^(id responseObject) {
                
            }];
            
        } ];
        
        [cV addAction:action];
        [cV addAction:action2];
        
        [self presentViewController:cV animated:YES completion:nil];
        
    }else{
        
        NSString *touuid = [_authorMutableArray[index] objectForKey:@"uuid"];
        
        
        NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        //
        NSString *url = [PublicMethods dataTojsonString:@{@"from_uuid":uuid,@"to_uuid":touuid}];
        //
        [YYNet POST:FriendFollow paramters:@{@"json":url} success:^(id responseObject) {
            
            //        NSDictionary *dict = [solveJsonData changeType:responseObject];
            [self.mainTableView.mj_header beginRefreshing];
            
        } faild:^(id responseObject) {
            
        }];
        
    }
    
   
    
    
   
    
}


@end
