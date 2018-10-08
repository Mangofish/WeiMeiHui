//
//  AuthorWorkListsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorWorkListsViewController.h"
#import "WeiContentTableViewCell.h"
#import "WeiFriendDetailViewController.h"
#import "AuthorDetailViewController.h"
#import "ShopViewController.h"
#import "ChatViewController.h"

#import "ReportViewController.h"
#import "ShareService.h"
#import "LWShareService.h"

@interface AuthorWorkListsViewController ()<UITableViewDelegate,UITableViewDataSource,WeiContentCellDelegate>{
    
    NSMutableArray *_dataAry;
    NSUInteger page;
    NSMutableDictionary *_heightDic;
    NSString *path;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


@end

@implementation AuthorWorkListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self configNavView];
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
    
    
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space);
    
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
    
    _dataAry = [NSMutableArray array];
    _heightDic = [NSMutableDictionary dictionary];
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"a_uuid":_authorUuid,@"lat":lat,@"lng":lng,@"page":@(page)}];
    
    [YYNet POST:AuthorPublished paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSArray *temp ;
        if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            temp = [dic objectForKey:@"data"];
        }else{
            
            return ;
            
        }
        if (self->page == 1) {
            [self->_dataAry setArray:temp];
            
        }else{
            [self->_dataAry addObjectsFromArray:temp];
            
        }
        
        [self.mainTableView reloadData];
        
        if (temp.count<10) {
            
            [self->_mainTableView.mj_header endRefreshing];
            [self->_mainTableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self->_mainTableView.mj_header endRefreshing];
            [self->_mainTableView.mj_footer endRefreshing];
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (!cell) {
        cell = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }
    
    cell.tag = indexPath.section;
    cell.delegate = self;
    
    cell.homeCellViewModel = [WeiContent contentListWithDict:_dataAry[indexPath.section]];
    
    
    [_heightDic setObject:@(cell.cellHeight) forKey:@(indexPath.section)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_heightDic[@(indexPath.section)] doubleValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *friendID = [[_dataAry objectAtIndex:indexPath.section] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 代理
- (void)chooseComment:(UIButton *)sender {
    
    NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

- (void)chooseIcon:(UIButton *)sender {
    
//        NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"issue_uuid"];
//        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
//        weiVC.ID = friendID;
        [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)chooseMessege:(UIButton *)sender {
//    NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"issue_uuid"];
    if ([PublicMethods isLogIn]) {
        
//        NSString *uuid = friendID;
        ChatViewController *weiVC  = [[ChatViewController alloc]init];
        weiVC.targetId = _authorUuid;
        weiVC.conversationType = ConversationType_PRIVATE;
        weiVC.conversationTitle = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"nickname"];
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
}

- (void)chooseZan:(UIButton *)sender {
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    //    sender.selected = !sender.selected;
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":friendID,@"type":@"9"}];
    
    [YYNet POST:FriendPraise paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSLog(@"%@",dict);
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (void)moreBtnAction:(UIButton *)sender {
    
//    NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
//    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
//    weiVC.friendID = friendID;
//    [self.navigationController pushViewController:weiVC animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@",[[_dataAry objectAtIndex:sender.tag] objectForKey:@"share_url"]];
    NSUInteger shareType = [[[_dataAry objectAtIndex:sender.tag] objectForKey:@"type"] integerValue];
    NSString *title = [NSString stringWithFormat:@"%@",[[_dataAry objectAtIndex:sender.tag] objectForKey:@"shareTitle"]];
    NSString *pic = [NSString stringWithFormat:@"%@",[[_dataAry objectAtIndex:sender.tag] objectForKey:@"sharePic"]];
    NSString *content = [NSString stringWithFormat:@"%@",[[_dataAry objectAtIndex:sender.tag] objectForKey:@"shareContent"]];
   
    
    
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
                    NSString *friendID = [[self->_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
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
    
    NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

- (void)chooseShopAddress:(UIButton *)sender {
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"shop_id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}


@end
