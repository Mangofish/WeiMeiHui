//
//  ActivityViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityThreeTableViewCell.h"
#import "SDCycleScrollView.h"

#import "AuthorGoodsListsViewController.h"
#import "GroupGoodsListsViewController.h"

#import "NextFreeNewViewController.h"

@interface ActivityViewController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate,ActivityThreeTableViewCellDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) NSArray *userAry;
@property (nonatomic, copy) NSArray *middleAry;
@property (nonatomic, copy) NSArray *listAry;

@property (nonatomic, strong) NSMutableArray * imagesURLAry;
@property (nonatomic,strong) SDCycleScrollView *activityCycleView;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-48) style:UITableViewStyleGrouped];
    _mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    _imagesURLAry = [NSMutableArray array];
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
        return self.listAry.count+2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 && !self.userAry.count) {
        return 0;
    }
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ActivityThreeTableViewCell *cell = [ActivityThreeTableViewCell activityThreeTableViewCellSingle];
        [cell.singleImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.userAry[0] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        ActivityThreeTableViewCell *cell = [ActivityThreeTableViewCell activityThreeTableViewCellThree];
        
        [cell.leftImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.middleAry[0] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
        
         [cell.rightOne sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.middleAry[1] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
        
         [cell.rightTwo sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.middleAry[2] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
        cell.delegate = self;
        
        return cell;
        
    }else{
        
        ActivityThreeTableViewCell *cell = [ActivityThreeTableViewCell activityThreeTableViewCellSingle];
        [cell.singleImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.listAry[indexPath.section-2] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
        return cell;
    }
    
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return kWidth*88/375;
    }
    
    if (indexPath.section == 1) {
       return   kHeight*134/667 +Space*2;
    }
    
     return kWidth*100/375;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0 ||  section == 1) {
        return 0.00001;
    }
    
    return Space;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return kWidth*200/375;
    }
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*200/375)];
        
        [v addSubview:self.activityCycleView];
        [self.activityCycleView adjustWhenControllerViewWillAppera];
        return v;
    }
    
    return nil;
}

#pragma mark - cycleView
- (SDCycleScrollView *)activityCycleView{
    
    if (!_activityCycleView) {
        
        _activityCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, kWidth*200/375) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        _activityCycleView.currentPageDotImage = [UIImage imageNamed:@"dot"];
        _activityCycleView.pageDotImage = [UIImage imageNamed:@"dot2"];
        _activityCycleView.autoScroll = YES;
    }
    
    return _activityCycleView;
}

-(void)setImagesURLAry:(NSMutableArray *)imagesURLAry{
    
    _imagesURLAry = imagesURLAry;
    if (_imagesURLAry.count == 0) {
        
        _activityCycleView.localizationImageNamesGroup = @[@"test2"];
        
    }else{
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *obj in _imagesURLAry) {
            [temp addObject:obj[@"banner_pic"]];
        }
        _activityCycleView.imageURLStringsGroup = temp;
        _activityCycleView.autoScroll = YES;
//        _cycleView.delegate = self;
    }
    
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
    
    [YYNet POST:MainActivity paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        [self.mainTableView.mj_header endRefreshing];
        
        self.listAry = [dic[@"data"] objectForKey:@"list"];
        self.userAry = [dic[@"data"] objectForKey:@"new_user"];
        self.middleAry = [dic[@"data"] objectForKey:@"middle"];
        self.imagesURLAry = [dic[@"data"] objectForKey:@"banner"];
        [self.mainTableView reloadData];
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    新用户
    if (indexPath.section == 0) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = [self.userAry[0] objectForKey:@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
    }
    
//    列表
    if (indexPath.section >= 2) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = [self.listAry[indexPath.section-2] objectForKey:@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
    }
}


- (void)selectImg:(NSUInteger)index{
    
//    拼团
    if (index == 1) {
        
        GroupGoodsListsViewController *lists = [[GroupGoodsListsViewController alloc]init];
        
        [self.navigationController pushViewController:lists animated:YES];
        
        
    }
    
    if (index == 2) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = [self.middleAry[1] objectForKey:@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
        
    }
    
    if (index == 3) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = [self.middleAry[2] objectForKey:@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
        
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    
    [cache removeAllCachedResponses];
    
    [cache setDiskCapacity:0];
    
    [cache setMemoryCapacity:0];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self getDataT];
    [self getData];
    [self.activityCycleView adjustWhenControllerViewWillAppera];
}

#pragma mark - 获取数据
- (void)getDataT{
    
    
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *uuid = @"";
    
    if ([PublicMethods isLogIn]) {
        uuid  = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":@(1),@"lat":lat,@"lng":lng}];
    
    [YYNet POST:INDEXList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        NSUInteger type = [[dic[@"order_data"] objectForKey:@"type"] integerValue];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(type) forKey:WEIPUBLISH];
        
        
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}



- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if (_imagesURLAry.count == 0) {
        return;
    }
    
        NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
        adVC.url = [_imagesURLAry[index] objectForKey:@"url"];
        [self.navigationController pushViewController:adVC animated:YES];
    
}


@end
