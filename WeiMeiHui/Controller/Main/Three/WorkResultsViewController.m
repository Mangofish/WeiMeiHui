//
//  WorkResultsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WorkResultsViewController.h"
#import "WeiContentTableViewCell.h"
#import "HWDownSelectedView.h"
#import "NextFreeNewViewController.h"
#import "UserDetailViewController.h"
#import "WeiFriendDetailViewController.h"
#import "NextFreeNewViewController.h"
#import "AuthorDetailViewController.h"
#import "ChatViewController.h"
#import "ShopViewController.h"
#import "LWShareService.h"
#import "ShareService.h"
#import "ReportViewController.h"
#import "PlayViewController.h"

@interface WorkResultsViewController () <HWDownSelectedViewDelegate,WeiContentCellDelegate>

@property(nonatomic,strong) NSMutableArray *contentdataAry;
@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (copy, nonatomic) NSArray *selectAry;
@property (strong, nonatomic)  UIView *dropView;
@property (strong, nonatomic)  UILabel *countLab;
@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (assign, nonatomic)  NSUInteger selectIndex;

@end

@implementation WorkResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.intelligent = @"";
    
    self.contentdataAry =[NSMutableArray array];
    _heightDic = [NSMutableDictionary dictionary];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-SafeAreaHeight-SafeAreaBottomHeight-88) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //    self.tableView.style = UITableViewStyleGrouped;
    // 代理&&数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    //    加刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refreshData:1];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self refreshMoreData:1];
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        
    }
    
    _dropView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    _dropView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dropView];
    
    _countLab = [[UILabel alloc]initWithFrame:CGRectMake(Space, 0, kWidth/4, 44)];
    _countLab.textColor = LightFontColor;
    _countLab.font = [UIFont systemFontOfSize:12];
    [_dropView addSubview:_countLab];
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    down.selectedIndex = 0;
    [self.view addSubview:down];
//    [self.tableView bringSubviewToFront:down];

    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.dropView.mas_left).offset(3*kWidth/4);
        make.top.mas_equalTo(self.view.mas_top).offset(0);
    }];
//    down.frame = CGRectMake(0, 0, kWidth/4, 44);
    down.listArray = @[@"全部",@"待付款",@"待使用", @"待评价",@"退款售后"];
    down.delegate = self;
    down.tag = 1;
    self.down1 = down;
    
     [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData:(NSUInteger)page{
    
    self.page = 1;
    [self getDataAtIndex:1];
    
}

- (void)refreshMoreData:(NSUInteger)page{
    self.page ++;
    [self getDataAtIndex:1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.contentdataAry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        WeiContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WeiContentTableViewCell"];
        if (!cell) {
            cell = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeiContentTableViewCell"];
        }
        
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.homeCellViewModel = [WeiContent contentListWithDict:self.contentdataAry[indexPath.row]];
        
        [_heightDic setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
        return cell;
    
}


- (void)getDataAtIndex:(NSUInteger)tag{
    
    
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    if (!uuid) {
        uuid = @"";
    }
    
    if (!city_id.length) {
        city_id = @"";
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":@"3",@"lat":lat,@"lng":lng,@"page":@(self.page),@"dump_id":self.dump_id,@"intelligent":self.intelligent,@"grade":self.grade,@"tag_id":self.tag_id,@"content":self.content,@"cut_id":self.cut_id}];
    
    [YYNet POST:SearchREsultsN paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        self.countLab.text = [NSString stringWithFormat:@"%@篇作品",dic[@"count"]];
        
        if ([[[dic objectForKey:@"select_data"] objectForKey:@"intelligent"] isKindOfClass:[NSArray class]]) {
            
            
            self.selectAry = [[dic objectForKey:@"select_data"] objectForKey:@"intelligent"];
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.selectAry) {
                [temp addObject:obj[@"name"]];
            }
            
            self.down1.listArray = temp;
            self.down1.selectedIndex = self.selectIndex;
            
        }
        
        if ([[dic objectForKey:@"friends"] isKindOfClass:[NSArray class]]) {
            
            
            if (self.page == 1) {
                [self.contentdataAry setArray:[dic objectForKey:@"friends"]];
            }else{
                [self.contentdataAry addObjectsFromArray:[dic objectForKey:@"friends"]];
            }
            
            
            
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSArray *temp = [dic objectForKey:@"friends"];
        if (temp.count < 10) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
       
        
        if (self.contentdataAry.count== 0) {
            MJWeakSelf
            self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"搜索空" titleStr:@"" detailStr:@"" btnTitleStr:@"" btnClickBlock:^{
                [weakSelf getDataAtIndex:0];
            }];
        }
        
        
    } faild:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        MJWeakSelf
        self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getDataAtIndex:2];
        }];
        
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return [_heightDic[@(indexPath.row)] doubleValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

//    return self.dropView;
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

#pragma mark - 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    判断
    NSUInteger type = [[self.contentdataAry[indexPath.row] objectForKey:@"is_advertise"] integerValue];
    if (type == 1) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = [self.contentdataAry[indexPath.row] objectForKey:@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
    }else{
        
        NSString *friendID = [[self.contentdataAry objectAtIndex:indexPath.row] objectForKey:@"id"];
        WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
        weiVC.friendID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
    
    
    
    
}



#pragma mark - 评论
- (void)chooseComment:(UIButton *)sender {
    
    NSString *friendID = [[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

#pragma mark - 个人主页
- (void)chooseIcon:(UIButton *)sender {
    
    NSUInteger level = [[[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"level"] integerValue];
    
    if (level == 3) {
        
        NSString *friendID = [[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
        UserDetailViewController *weiVC  = [[UserDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        NSString *friendID = [[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
    
}

#pragma mark - 私信
- (void)chooseMessege:(UIButton *)sender {
    
    NSString *uuid = [[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
    if ([PublicMethods isLogIn]) {
        
        ChatViewController *conversationVC = [[ChatViewController alloc]init];
        
        //聊天界面的聊天类型
        conversationVC.conversationType = ConversationType_PRIVATE;
        //需要打开和谁聊天的会话界面,和谁聊天其实是通过TargetId来联系的。
        conversationVC.targetId = uuid;
        conversationVC.conversationTitle =  [[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"nickname"];
        
        [self.navigationController pushViewController:conversationVC animated:YES];
        
        
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
    
}
#pragma mark - 商家
- (void)chooseShopAddress:(UIButton *)sender {
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = self.contentdataAry[sender.tag][@"shop_id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

#pragma mark - 点赞
- (void)chooseZan:(UIButton *)sender {
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    NSUInteger count = [sender.currentTitle integerValue];
    if ([PublicMethods isLogIn]) {
        
        sender.selected = !sender.selected;
        
        if (sender.selected ) {
            count += 1;
            [sender setTitle:[NSString stringWithFormat:@"%lu",count] forState:UIControlStateNormal];
        }else{
            count -= 1;
            [sender setTitle:[NSString stringWithFormat:@"%lu",count] forState:UIControlStateNormal];
        }
        
        CGFloat praiseWidth = [sender.currentTitle textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:13].lineHeight)].width + 20;
        
        sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, praiseWidth+6, sender.frame.size.height);
        [sender layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    }
    
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":[self.contentdataAry[sender.tag] objectForKey:@"id"],@"type":@"9"}];
    
    [YYNet POST:FriendPraise paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSLog(@"%@",dict);
        
        if ([dict[@"success"] boolValue]) {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:self.contentdataAry[sender.tag]];
            
            [data setObject:@(sender.selected) forKey:@"is_praises"];
            [data setObject:sender.currentTitle forKey:@"praises"];
            [self.contentdataAry replaceObjectAtIndex:sender.tag withObject:data];
            
            
        }
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

#pragma mark - 分享
- (void)moreBtnAction:(UIButton *)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@",[[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"share_url"]];
    NSUInteger shareType = [[[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"type"] integerValue];
    NSString *title = [NSString stringWithFormat:@"%@",[[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"shareTitle"]];
    NSString *pic = [NSString stringWithFormat:@"%@",[[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"sharePic"]];
    NSString *content = [NSString stringWithFormat:@"%@",[[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"shareContent"]];
    
    //    if ([[[_dataAry objectAtIndex:sender.tag] objectForKey:@"pic"] isKindOfClass:[NSArray class]]) {
    //        pic = [[[[_dataAry objectAtIndex:sender.tag] objectForKey:@"pic"] objectAtIndex:0] objectForKey:@"url"];
    //    }
    //
    
    [LWShareService shared].shareBtnClickBlock = ^(NSUInteger index) {
        NSLog(@"%lu",(unsigned long)index);
        [[LWShareService shared] hideSheetView];
        
        
        
        if ([PublicMethods isLogIn]) {
            
            //    分享界面
            SSDKPlatformType type = 0;
            
            switch (index) {
                case 0:
                    type = SSDKPlatformSubTypeWechatTimeline;
                    break;
                case 1:
                    type = SSDKPlatformSubTypeWechatSession;
                    break;
                case 2:
                    type = SSDKPlatformTypeSinaWeibo;
                    break;
                case 3:
                    type = SSDKPlatformSubTypeQQFriend;
                    break;
                case 4:
                    type = SSDKPlatformSubTypeQZone;
                    break;
                case 5:
                    type = SSDKPlatformTypeCopy;
                    break;
                case 6:
                {
                    NSString *friendID = [[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"id"];
                    ReportViewController *reportVC = [[ReportViewController alloc] init];
                    reportVC.ID = friendID;
                    [self.navigationController pushViewController:reportVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            
            
            if (shareType == 2) {
                
                [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeVideo copyUrl:url];
                
                
            }else{
                
                [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
            }
            
            
        }else{
            LoginViewController *log = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:log animated:YES];
        }
        
    };
    [[LWShareService shared] showInViewController:self];
    
}

- (void)playBtnAction:(UIButton *)sender {
    
    PlayViewController *vedioVC = [[PlayViewController alloc] init];
    NSString *fileUrl = [[[[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"pic"] objectAtIndex:0] objectForKey:@"original_url"];
    
    NSLog(@"fileUrl:%@",fileUrl);
    //        做判断
    vedioVC.urlStr = fileUrl;
    [self.navigationController pushViewController:vedioVC animated:YES];
    
    
}

- (void)chooseIconA:(UIButton *)sender{
    
    NSUInteger level = [[[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"level"] integerValue];
    
    if (level == 3) {
        
        NSString *friendID = [[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
        UserDetailViewController *weiVC  = [[UserDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        NSString *friendID = [[self.contentdataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
}

- (void)moreBtnActionA:(UIButton *)sender{
    
    [self moreBtnAction:sender];
    
}

- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    
    self.selectIndex = indexPath.row;
    
    self.intelligent = [self.selectAry[indexPath.row] objectForKey:@"id"];
    [self.tableView.mj_header beginRefreshing];
    
    
}

@end
