//
//  UserDetailViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UserDetailViewController.h"
#import "WeiContentTableViewCell.h"
#import "NormalUserHeaderView.h"
#import "LWShareService.h"
#import "LoginViewController.h"
#import "ReportViewController.h"
#import "ChatViewController.h"

#import "ShopViewController.h"
#import "PlayViewController.h"
#import "WeiFriendDetailViewController.h"

@interface UserDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WeiContentCellDelegate>{
    NSMutableArray *dataAry;
    NSDictionary *headDic;
    NSMutableDictionary *heightDic;
    NSUInteger page;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *message;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    [self customUI];
    
    if ([PublicMethods isLogIn]) {
        NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        
        if ([uuid isEqualToString:_ID]) {
            _bottomView.hidden = YES;
        }
    }
}

-(void)customUI{
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self->page++;
        [self getData];
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    heightDic = [NSMutableDictionary dictionary];
    dataAry = [NSMutableArray array];
    page = 1;
    [_mainTableView.mj_header beginRefreshing];
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(UIButton *)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@/uuid/%@",[headDic objectForKey:@"share_url"],_ID];
    NSUInteger shareType = [[headDic objectForKey:@"type"] integerValue];
    NSString *title = [headDic objectForKey:@"shareTitle"];
    NSString *pic = [headDic objectForKey:@"sharePic"];
    NSString *content = [headDic objectForKey:@"shareContent"];
    
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
                    
                    ReportViewController *reportVC = [[ReportViewController alloc] init];
                    reportVC.ID = self->_ID;
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
    [[LWShareService shared] showInViewControllerTwo:self];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (!cell) {
        cell = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }
    
    cell.delegate = self;
    cell.tag = indexPath.section;
    cell.homeCellViewModel = [WeiContent contentListWithDict:dataAry[indexPath.row]];
    [heightDic setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
    return cell;
    
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UIView *v = [UIView new];
//        NSArray *pics = headDic[@"user_pics"];
        CGFloat height = 0.39*kHeight;
        
        NormalUserHeaderView *head = [NormalUserHeaderView userHeaderViewWithFrame:CGRectMake(0, 0, kWidth,height)];
        head.homeCellViewModel = [UserHeader headWithDict:headDic];
        [v addSubview:head];
        UIView *headV = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil][1];
        headV.frame = CGRectMake(0, height, kWidth, 54);
        [v addSubview:headV];
        return v;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [heightDic[@(indexPath.row)] doubleValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
//        NSArray *pics = headDic[@"user_pics"];
//        if (pics.count) {
//            return 0.58*kHeight+54;
//        }
//        CGFloat width = (kWidth-Space*2-5*3)/4;
//        return 0.58*kHeight+54-width;
        return 0.39*kHeight+44+Space;
    }
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Space;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


#pragma mark- cell代理
- (void)moreBtnAction:(UIButton *)sender{
    
    NSString *url = [NSString stringWithFormat:@"%@",[[dataAry objectAtIndex:sender.tag] objectForKey:@"share_url"]];
    NSUInteger shareType = [[[dataAry objectAtIndex:sender.tag] objectForKey:@"type"] integerValue];
    NSString *title = [NSString stringWithFormat:@"%@",[[dataAry objectAtIndex:sender.tag] objectForKey:@"shareTitle"]];
    NSString *pic = [NSString stringWithFormat:@"%@",[[dataAry objectAtIndex:sender.tag] objectForKey:@"sharePic"]];
    NSString *content = [NSString stringWithFormat:@"%@",[[dataAry objectAtIndex:sender.tag] objectForKey:@"shareContent"]];
    
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
                    NSString *friendID = [[self->dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
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

-(void)chooseZan:(UIButton *)sender{
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":[dataAry[sender.tag] objectForKey:@"id"],@"type":@"9"}];
    
    [YYNet POST:FriendPraise paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSLog(@"%@",dict);
        
        //        [self.view setNeedsLayout];
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

-(void)chooseComment:(UIButton *)sender{
    
    NSString *friendID = [[dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

-(void)chooseMessege:(UIButton *)sender{
    
    if ([PublicMethods isLogIn]) {
        
        ChatViewController *weiVC  = [[ChatViewController alloc]init];
        weiVC.targetId = _ID;
        weiVC.conversationTitle = headDic[@"nickname"];
        weiVC.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
}


- (void)chooseShopAddress:(UIButton *)sender {
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = dataAry[sender.tag][@"shop_id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}



- (void)getData{
    
    //网络请求
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *uuid =@"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"use_uuid":uuid,@"uuid":_ID,@"lat":lat,@"lng":lng,@"page":@(page)}];
    
    [YYNet POST:UserDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->headDic = dic[@"data"];
        
        if ([self->headDic[@"is_relationship"] integerValue] == 0) {
            self->_followBtn.selected = NO;
        }
        
        if ([self->headDic[@"is_relationship"] integerValue] == 1) {
            self->_followBtn.selected = YES;
        }
        
        if ([self->headDic[@"is_relationship"] integerValue] == 2) {
            self->_followBtn.selected = YES;
        }
        
        NSArray *temp = [self->headDic objectForKey:@"friends_data"];
        if (self->page == 1) {
            [self->dataAry setArray:temp];
            
        }else{
            [self->dataAry addObjectsFromArray:temp];
            
            
        }
        
        if (temp.count<10) {
            [self->_mainTableView.mj_footer endRefreshingWithNoMoreData];
            self->_mainTableView.mj_footer.hidden = YES;
        }else{
            self->_mainTableView.mj_footer.hidden = NO;
            
            
        }
        
        [self.mainTableView reloadData];
        [self->_mainTableView.mj_header endRefreshing];
        [self->_mainTableView.mj_footer endRefreshing];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *friendID = [[dataAry objectAtIndex:indexPath.section] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}


- (IBAction)followAction:(UIButton *)sender {
    
    if (![PublicMethods isLogIn]) {
        
        LoginViewController *logVC= [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        return;
    }
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"from_uuid":uuid,@"to_uuid":_ID}];
    
    [YYNet POST:FriendFollow paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        
        if ([dict[@"success"] boolValue]) {
            
            self->_followBtn.selected = !self->_followBtn.selected;
        }
        
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (void)playBtnAction:(UIButton *)sender {
    
    PlayViewController *vedioVC = [[PlayViewController alloc] init];
    NSString *fileUrl = [[[[dataAry objectAtIndex:sender.tag] objectForKey:@"pic"] objectAtIndex:0] objectForKey:@"original_url"];
    
    NSLog(@"fileUrl:%@",fileUrl);
    //        做判断
    vedioVC.urlStr = fileUrl;
    [self.navigationController pushViewController:vedioVC animated:YES];
    
    
}

#pragma mark - 私信
- (IBAction)messageAction:(id)sender {
    
    if ([PublicMethods isLogIn]) {
        
        ChatViewController *weiVC  = [[ChatViewController alloc]init];
        weiVC.targetId = _ID;
        weiVC.conversationTitle = headDic[@"nickname"];
        weiVC.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
}

@end
