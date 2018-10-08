//
//  AllSearchResultViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AllSearchResultViewController.h"
#import "FamousShopTableViewCell.h"
#import "FamousGoodsTableViewCell.h"
#import "WeiContentTableViewCell.h"
#import "SearchFooterTableViewCell.h"
#import "UIButton+ImageTitleSpacing.h"
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
#import "GoodsDetailViewController.h"
#import "ALLAuthorsTableViewCell.h"

@interface AllSearchResultViewController () <WeiContentCellDelegate,SearchFooterDelegate>

@property(nonatomic,strong) NSMutableArray *goodsdataAry;
@property(nonatomic,strong) NSMutableArray *contentdataAry;
@property(nonatomic,strong) NSMutableArray *shopdataAry;
@property(nonatomic,strong) NSMutableArray *authordataAry;
@property (nonatomic, strong) YYHud *hud;
@property (nonatomic,strong) NSMutableDictionary *heightDic;

@end

@implementation AllSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-SafeAreaBottomHeight-SafeAreaHeight-44) style:UITableViewStyleGrouped];
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
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [self refreshMoreData:1];
//    }];
    
    self.goodsdataAry =[NSMutableArray array];
    self.contentdataAry =[NSMutableArray array];
    self.shopdataAry =[NSMutableArray array];
    self.authordataAry = [NSMutableArray array];
    _heightDic = [NSMutableDictionary dictionary];
    
    [self getDataAtIndex:1];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
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
    
    return 4;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.goodsdataAry.count;
    }
    
    if (section == 1) {
        return self.contentdataAry.count;
    }
    
    if (section == 2) {
        return self.shopdataAry.count;
    }
    
    if (section == 3) {
        return self.authordataAry.count;
    }
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        FamousGoodsTableViewCell *cell = [FamousGoodsTableViewCell  famousGoodsTableViewCellSearch];
        cell.goodsSearch = [AuthorGoods authorGoodsWithDict:self.goodsdataAry[indexPath.row]];
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        
        WeiContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WeiContentTableViewCell"];
        if (!cell) {
            cell = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeiContentTableViewCell"];
        }
        
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.homeCellViewModel = [WeiContent contentListWithDict:self.contentdataAry[indexPath.row]];
        
        [_heightDic setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
        return cell;
        
    }else if(indexPath.section == 2){
        
        FamousShopTableViewCell *cell = [FamousShopTableViewCell famousShopTableViewCellMain];
        cell.authorMain = [ShopAndAuthor shopAuthorWithDict:self.shopdataAry[indexPath.row]];
        return cell;
        
    }else{
        
        ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell == nil) {
            cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
        }
        
        cell.author = [ShopAuthor shopAuthorWithDict:self.authordataAry[indexPath.row]];
        return cell;
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 3) {
        
        return 88;
        
    }else if (indexPath.section == 1 ){
        
         return [_heightDic[@(indexPath.row)] doubleValue];
        
    }else{
        
        return 189*(kWidth-20)/355+80;
        
    }
    
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
    
    self.hud = [[YYHud alloc]init];
    [self.hud showInView:self.view];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":@"1",@"lat":lat,@"lng":lng,@"page":@(self.page),@"dump_id":self.dump_id,@"intelligent":self.intelligent,@"grade":self.grade,@"tag_id":self.tag_id,@"content":self.content,@"cut_id":self.cut_id}];
    
    [YYNet POST:SearchREsultsN paramters:@{@"json":url} success:^(id responseObject) {
        
        [self.hud dismiss];
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        
        if ([[dic objectForKey:@"goods"] isKindOfClass:[NSArray class]]) {
            
            [self.goodsdataAry setArray:[dic objectForKey:@"goods"]];
            
        }
        
        if ([[dic objectForKey:@"friends"] isKindOfClass:[NSArray class]]) {
            
            [self.contentdataAry setArray:[dic objectForKey:@"friends"]];
            
        }
        
        if ([[dic objectForKey:@"shop"] isKindOfClass:[NSArray class]]) {
            
            [self.shopdataAry setArray:[dic objectForKey:@"shop"]];
            
        }
        
        
        if ([[dic objectForKey:@"author"] isKindOfClass:[NSArray class]]) {
            
            [self.authordataAry setArray:[dic objectForKey:@"author"]];
            
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.goodsdataAry.count== 0 && self.contentdataAry.count == 0 && self.shopdataAry.count ==0 && self.authordataAry.count ==0) {
            MJWeakSelf
            self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"搜索空" titleStr:@"" detailStr:@"" btnTitleStr:@"" btnClickBlock:^{
                [weakSelf getDataAtIndex:0];
            }];
        }
        
        
        
        
    } faild:^(id responseObject) {
        [self.hud dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        MJWeakSelf
        self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getDataAtIndex:2];
        }];
        
        
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.goodsdataAry.count && section == 0) {
        return Space;
    }
    
    if (self.contentdataAry.count && section == 1) {
        return Space;
    }
    
    if (self.shopdataAry.count && section == 2) {
        return Space;
    }
    
    if (self.authordataAry.count && section == 3) {
        return Space;
    }
    
    return 0.000001;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (self.goodsdataAry.count && section == 0) {
        return 44;
    }
    
    if (self.contentdataAry.count && section == 1) {
        return 44;
    }
    
    if (self.shopdataAry.count && section == 2) {
        return 44;
    }
    
    if (self.authordataAry.count && section == 3) {
        return 44;
    }
    
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    if (self.goodsdataAry.count && section == 0) {
        
        SearchFooterTableViewCell *cell = [SearchFooterTableViewCell searchFooterTableViewCell];
        [cell.titleBtn setTitle:@"查看更多服务" forState:UIControlStateNormal];
        cell.titleBtn.tag = section;
        cell.delegate = self;
        [cell.titleBtn layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:4];
        return cell;
    }
    
    if (self.contentdataAry.count && section == 1) {
        SearchFooterTableViewCell *cell = [SearchFooterTableViewCell searchFooterTableViewCell];
        [cell.titleBtn setTitle:@"查看更多作品" forState:UIControlStateNormal];
        cell.titleBtn.tag = section;
        cell.delegate = self;
        [cell.titleBtn layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:4];
        return cell;
    }
    
    if (self.shopdataAry.count && section == 2) {
        SearchFooterTableViewCell *cell = [SearchFooterTableViewCell searchFooterTableViewCell];
        [cell.titleBtn setTitle:@"查看更多商家" forState:UIControlStateNormal];
         cell.titleBtn.tag = section;
        cell.delegate = self;
        [cell.titleBtn layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:4];
        return cell;
    }
    
    if (self.authordataAry.count && section == 3) {
        SearchFooterTableViewCell *cell = [SearchFooterTableViewCell searchFooterTableViewCell];
        [cell.titleBtn setTitle:@"查看更多名师" forState:UIControlStateNormal];
        cell.titleBtn.tag = section;
        cell.delegate = self;
        [cell.titleBtn layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:4];
        return cell;
    }
    
    return nil;
    
}

#pragma mark - 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    朋友圈
    if (indexPath.section == 1) {
        
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
    
//    商品
    if (indexPath.section == 0) {
        
        NSString *temp = [self.goodsdataAry[indexPath.row] objectForKey:@"id"];
        
        GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
        detailVc.ID = temp;
        detailVc.isGroup = [[self.goodsdataAry[indexPath.row] objectForKey:@"is_group"] integerValue];
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }
    
    
//    商家
    if (indexPath.section == 2) {
        
        ShopViewController *shopVC = [[ShopViewController alloc]init];
        shopVC.ID = [self.shopdataAry[indexPath.row] objectForKey:@"id"];
        [self.navigationController pushViewController:shopVC animated:YES];
        
    }
    
    if (indexPath.section == 3) {
        
        NSString *temp = [self.authordataAry[indexPath.row] objectForKey:@"author_uuid"];
        
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = temp;
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

- (void)chooseDel:(UIButton *)sender {
    
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

#pragma mark - 查看更多
- (void)lookMore:(NSUInteger)index{
    
    //    商品
    if (index == 0) {
        
        [self.delegate didClickMoreIndex:index];
        
    }
    
    //    作品
    if (index == 1) {
        [self.delegate didClickMoreIndex:index];
    }
    
    //    商家
    if (index == 2) {
        [self.delegate didClickMoreIndex:index];
    }
    
    //    商家
    if (index == 3) {
        [self.delegate didClickMoreIndex:index];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.hud dismiss];
    
}

@end
