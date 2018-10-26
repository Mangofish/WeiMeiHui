//
//  InformationBaseTableViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "InformationBaseTableViewController.h"
#import "WeiContentTableViewCell.h"
#import "WeiAdvertTableViewCell.h"
#import "UserDetailViewController.h"
#import "AuthorDetailViewController.h"
#import "NextFreeNewViewController.h"
#import "WeiFriendDetailViewController.h"
#import "ChatViewController.h"
#import "ShopViewController.h"
#import "LWShareService.h"
#import "ReportViewController.h"
#import "PlayViewController.h"

@interface InformationBaseTableViewController ()<WeiContentCellDelegate,WeiAdvertTableViewCellDelegate>{
    
    NSMutableDictionary *_heightDic;
    
}

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger page;

@end

@implementation InformationBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    _heightDic = [NSMutableDictionary dictionary];
    self.page = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        
    }
    
    
//    [self getData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger type = [[self.dataArr[indexPath.row] objectForKey:@"is_advertise"] integerValue];
    
    
    
    if (type == 1) {
        
        WeiAdvertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WeiAdTableViewCell"];
        if (!cell) {
            cell = [[WeiAdvertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeiAdTableViewCell"];
        }
        
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.homeCellViewModel = [WeiContent contentListWithDict:_dataArr[indexPath.row]];
        
        [_heightDic setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
        return cell;
        
    }else{
        
        WeiContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WeiContentTableViewCell"];
        if (!cell) {
            cell = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeiContentTableViewCell"];
        }
        
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.homeCellViewModel = [WeiContent contentListWithDict:_dataArr[indexPath.row]];
        
        [_heightDic setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
        return cell;
        
    }
    
    
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(self.page),@"type":self.type,@"city_id":city_id}];
    
    [YYNet POST:GroupList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([[dic[@"data"] objectForKey:@"friends"] isKindOfClass:[NSArray class]]) {
            
            if (self.page == 1) {
                
                 [self.dataArr setArray: [dic[@"data"] objectForKey:@"friends"]];
                
            }else{
                
                 [self.dataArr addObjectsFromArray: [dic[@"data"] objectForKey:@"friends"]];
                
            }
            
        }else{
            
            MJWeakSelf
            self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有作品" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
                [weakSelf getData];
            }];
            
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    判断
    NSUInteger type = [[self.dataArr[indexPath.row] objectForKey:@"is_advertise"] integerValue];
    if (type == 1) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = [self.dataArr[indexPath.row] objectForKey:@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
    }else{
        
        NSString *friendID = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
        WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
        weiVC.friendID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
    
    
    
    
}



#pragma mark - 评论
- (void)chooseComment:(UIButton *)sender {
    
    NSString *friendID = [[self.dataArr objectAtIndex:sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

#pragma mark - 个人主页
- (void)chooseIcon:(UIButton *)sender {
    
    NSUInteger level = [[[self.dataArr objectAtIndex:sender.tag] objectForKey:@"level"] integerValue];
    
    if (level == 3) {
        
        NSString *friendID = [[self.dataArr objectAtIndex:sender.tag] objectForKey:@"uuid"];
        UserDetailViewController *weiVC  = [[UserDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        NSString *friendID = [[self.dataArr objectAtIndex:sender.tag] objectForKey:@"uuid"];
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
    
}

#pragma mark - 私信
- (void)chooseMessege:(UIButton *)sender {
    
    NSString *uuid = [[self.dataArr objectAtIndex:sender.tag] objectForKey:@"uuid"];
    if ([PublicMethods isLogIn]) {
        
        ChatViewController *conversationVC = [[ChatViewController alloc]init];
        
        //聊天界面的聊天类型
        conversationVC.conversationType = ConversationType_PRIVATE;
        //需要打开和谁聊天的会话界面,和谁聊天其实是通过TargetId来联系的。
        conversationVC.targetId = uuid;
        conversationVC.conversationTitle =  [[self.dataArr objectAtIndex:sender.tag] objectForKey:@"nickname"];
        
        [self.navigationController pushViewController:conversationVC animated:YES];
        
        
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
    
}
#pragma mark - 商家
- (void)chooseShopAddress:(UIButton *)sender {
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = self.dataArr[sender.tag][@"shop_id"];
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
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":[self.dataArr[sender.tag] objectForKey:@"id"],@"type":@"9"}];
    
    [YYNet POST:FriendPraise paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSLog(@"%@",dict);
        
        if ([dict[@"success"] boolValue]) {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[sender.tag]];
            
            [data setObject:@(sender.selected) forKey:@"is_praises"];
            [data setObject:sender.currentTitle forKey:@"praises"];
            [self.dataArr replaceObjectAtIndex:sender.tag withObject:data];
            
            
        }
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

#pragma mark - 分享
- (void)moreBtnAction:(UIButton *)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@",[[self.dataArr objectAtIndex:sender.tag] objectForKey:@"share_url"]];
    NSUInteger shareType = [[[self.dataArr objectAtIndex:sender.tag] objectForKey:@"type"] integerValue];
    NSString *title = [NSString stringWithFormat:@"%@",[[self.dataArr objectAtIndex:sender.tag] objectForKey:@"shareTitle"]];
    NSString *pic = [NSString stringWithFormat:@"%@",[[self.dataArr objectAtIndex:sender.tag] objectForKey:@"sharePic"]];
    NSString *content = [NSString stringWithFormat:@"%@",[[self.dataArr objectAtIndex:sender.tag] objectForKey:@"shareContent"]];
    
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
                    NSString *friendID = [[self.dataArr objectAtIndex:sender.tag] objectForKey:@"id"];
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
    NSString *fileUrl = [[[[self.dataArr objectAtIndex:sender.tag] objectForKey:@"pic"] objectAtIndex:0] objectForKey:@"original_url"];
    
    NSLog(@"fileUrl:%@",fileUrl);
    //        做判断
    vedioVC.urlStr = fileUrl;
    [self.navigationController pushViewController:vedioVC animated:YES];
    
    
}

- (void)chooseIconA:(UIButton *)sender{
    
    NSUInteger level = [[[self.dataArr objectAtIndex:sender.tag] objectForKey:@"level"] integerValue];
    
    if (level == 3) {
        
        NSString *friendID = [[self.dataArr objectAtIndex:sender.tag] objectForKey:@"uuid"];
        UserDetailViewController *weiVC  = [[UserDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        NSString *friendID = [[self.dataArr objectAtIndex:sender.tag] objectForKey:@"uuid"];
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
}

- (void)moreBtnActionA:(UIButton *)sender{
    
    [self moreBtnAction:sender];
    
}




@end
