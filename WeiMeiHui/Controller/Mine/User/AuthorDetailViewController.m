//
//  AuthorDetailViewController.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorDetailViewController.h"
#import "LWShareService.h"
#import "UserHeaderView.h"

#import "UserShopTableViewCell.h"
#import "ShopViewController.h"
#import "AuthorWorkListTableViewCell.h"
#import "AuthorDetailHead.h"
#import "CommentOrderTableViewCell.h"
#import "AuthorWorkListsViewController.h"
#import "AuthorGoodsItemTableViewCell.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "ReportViewController.h"
#import "ShopLocationViewController.h"
#import "GoodsDetailViewController.h"

#import "FamousGoodsTableViewCell.h"
#import "SearchFooterTableViewCell.h"
#import "WeiContentTableViewCell.h"
#import "WeiFriendDetailViewController.h"

#import "ALLCommentViewController.h"

@interface AuthorDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UserShopTableViewCellDelegate,AuthorGoodsItemTableViewCellDelegate,UserHeaderViewDelegate,WeiContentCellDelegate,SearchFooterDelegate>{
    NSMutableArray *dataAry;
    NSDictionary *headDic;
    NSMutableDictionary *heightDic;
    NSMutableDictionary *friendHeightDic;
    NSUInteger page;
    NSArray *authorData;
    NSArray *tagData;
    
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *message;
@property (copy, nonatomic) NSString *friendsCount;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic)  AuthorDetailHead *head ;
@property (assign, nonatomic)  NSUInteger selectIndex ;
@property (strong, nonatomic) NSMutableArray *friendsdataAry;
@property (copy, nonatomic) NSString *commsCount;

@end

@implementation AuthorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.selectIndex = 0;
    [self customUI];
   
    if ([PublicMethods isLogIn]) {
        NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        
        if ([uuid isEqualToString:_ID]) {
            _message.hidden = YES;
        }
    }
    
    _friendsdataAry = [NSMutableArray array];
    friendHeightDic = [NSMutableDictionary dictionary];
    
}

-(void)customUI{
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight-49);
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
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
        make.height.equalTo(@(20));
        make.width.equalTo(@(kWidth-Space*2));
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
    NSUInteger shareType = [[self->headDic objectForKey:@"type"] integerValue];
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
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return dataAry.count;
    }
    
    if (section == 4) {
        return self.friendsdataAry.count;
    }
    
    if (section == 1) {
        
        NSArray *temp = headDic[@"price_list"];
//        if (temp.count == 0) {
//            return 0;
//        }
//        NSArray *finalAry = [temp[self.selectIndex] objectForKey:@"goods_list"];
        return temp.count;
    }
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UserShopTableViewCell *cell = [UserShopTableViewCell userShopTableViewCell];
        cell.model = [ShopModel shopModeltWithDict:headDic];
        cell.delegate = self;
        return cell;
    }
    //价目表
    if (indexPath.section == 1) {
        
        FamousGoodsTableViewCell *cell = [FamousGoodsTableViewCell  famousGoodsTableViewCellDetailT];
         NSArray *temp = headDic[@"price_list"];
        cell.goods = [AuthorGoods authorGoodsWithDict:temp[indexPath.row]];
        
        return cell;
        
//        AuthorGoodsItemTableViewCell *cell = [AuthorGoodsItemTableViewCell authorGoodsItemTableViewCell];
//        cell.delegate = self;
//        cell.tag = indexPath.row;
//        NSArray *temp = headDic[@"price_list"];
////        NSArray *finalAry = [temp[self.selectIndex] objectForKey:@"goods_list"];
//        cell.goods = [AuthorGoods authorGoodsWithDict:temp[indexPath.row]];
//        return cell;
    }
    
    if (indexPath.section == 2) {
        AuthorWorkListTableViewCell *cell = [AuthorWorkListTableViewCell authorWorkListTableViewCell:authorData];
        cell.title.text = [NSString stringWithFormat:@"作品（%@）",headDic[@"product_num"]];
        return cell;
    }
    
    if (indexPath.section == 3) {
        CommentOrderTableViewCell *cell = [CommentOrderTableViewCell commentOrderTableViewCell];
        cell.comment = [OrderComment orderCommentWithDict:dataAry[indexPath.row]];
        heightDic[@(indexPath.row)] = @(cell.cellHeight);
        return cell;
    }
    
    if (indexPath.section == 4) {
        
        WeiContentTableViewCell *cell = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.homeCellViewModel = [WeiContent contentListWithDict:_friendsdataAry[indexPath.row]];
        
        [friendHeightDic setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
        return cell;
        
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 144+66+Space)];
        UserHeaderView *head = [UserHeaderView userHeaderViewWithFrame:CGRectMake(0, 0, kWidth,144+66)];
        
        if (headDic.count) {
            head.homeCellViewModel = [UserHeader headWithDict:headDic];
        }
        
        [v addSubview:head];
        head.delegate = self;
        return v;
    }
    
    if (section == 1) {
//        NSArray *temp = headDic[@"price_list"];
//        if (!temp.count) {
//            return nil;
//        }
        UserShopTableViewCell *cell = [UserShopTableViewCell userShopTableViewPriceCell];
//        cell.priceAry = headDic[@"price_list"];
//
//        for (int i = 0; i < cell.priceAry.count; i++) {
//            UIButton *btn = [cell.itemBgView viewWithTag:i+1];
//            btn.selected = NO;
//            if (i == self.selectIndex) {
//                btn.selected = YES;
//            }
//        }
//
//        cell.delegate = self;
        return cell;
    }
    
    if (section == 3) {
        
        UIView *v = [UIView new];
        [v addSubview:self.head];
        return v;
    }
    
    if (section == 4) {
        
        UIView *v = [UIView new];
        //        NSArray *pics = headDic[@"user_pics"];
        UserHeaderView *headV = [UserHeaderView userHeadView];
        headV.frame = CGRectMake(0, 0, kWidth, 54);
        headV.countLab.text = [NSString stringWithFormat:@"作品（%@）",_friendsCount];
        [v addSubview:headV];
        return v;
    }
    
    return nil;
}

- (AuthorDetailHead *)head{
    
    if (!_head) {
        
        _head = [AuthorDetailHead authorDetailHead];
        
    }
    
    return _head;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80;
    }
    
    if (indexPath.section == 1) {
        return 88;
    }
    
    if (indexPath.section == 2) {
        return 112;
    }
    
    if (indexPath.section == 4) {
        return [friendHeightDic[@(indexPath.row)] doubleValue];;
    }
    
    return [heightDic[@(indexPath.row)] doubleValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
    
        return 144+66;
    }
    
    if (section == 1) {
        NSArray *temp = headDic[@"price_list"];
        if (temp.count == 0) {
            return 0.00001;
        }
        return 44;
        
        return 0.00001;
    }
    
    
    if (section == 3) {
        
        return [heightDic[@"head"] doubleValue];
    }
    
    if (section == 4) {
        
        return 54;
    }
    
    return 0.00001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section == 3) {
        
        return 54;
    }
    
    return Space;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 3 && dataAry.count) {
        
        UIView *v = [UIView new];
        v.backgroundColor= [UIColor groupTableViewBackgroundColor];
        
        SearchFooterTableViewCell *cell = [SearchFooterTableViewCell searchFooterTableViewCellFooter];
        cell.countLab.text = [NSString stringWithFormat:@"共%@条",self.commsCount];
        cell.frame = CGRectMake(0, 0, kWidth, 44);
        cell.delegate = self;
        [v addSubview:cell];
        
        return v;
        
        
    }
    
    return nil;
}


- (void)getData{
    
    //网络请求
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"author_uuid":_ID,@"lat":lat,@"lng":lng,@"page":@(page)}];
    
    [YYNet POST:AuthorUserDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->headDic = dic[@"data"];
        NSArray *temp = [self->headDic objectForKey:@"evaluate_list"];
        
        [self->dataAry setArray:temp];
        
        self->authorData = [self->headDic objectForKey:@"product_pic"];
        self->tagData = [self->headDic objectForKey:@"service_tag"];
        self.titleLab.text = self->headDic[@"nickname"];
        self.friendsCount = self->headDic[@"friends_count"];
        self.commsCount = self->headDic[@"evaluate_count"];
        self.head.tagAry = self->tagData;
        self.head.model = [ShopModel shopModeltWithDict:self->headDic];
        self->heightDic[@"head"] = @(self.head.cellHeight);
        self.head.frame = CGRectMake(0, 0, kWidth, self.head.cellHeight);
        
        if ([self->headDic[@"is_relationship"] integerValue] == 0) {
            self->_followBtn.selected = NO;
        }
        
        if ([self->headDic[@"is_relationship"] integerValue] == 1) {
            self->_followBtn.selected = YES;
        }
        
        if ([self->headDic[@"is_relationship"] integerValue] == 2) {
            [self->_followBtn setTitle: @"互相关注"forState:UIControlStateNormal];
            [self->_followBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
        NSArray *temp2  = @[];
        
        if ([[self->headDic objectForKey:@"friends_list"] isKindOfClass:[NSArray class]]) {
            temp2 = [self->headDic objectForKey:@"friends_list"];
        }
        
        
        
        if (self->page == 1) {
            
            [self.friendsdataAry setArray:temp2];
        }else{
            [self.friendsdataAry addObjectsFromArray:temp2];
            
            
        }
        
        if (temp2.count<10) {
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            self.mainTableView.mj_footer.hidden = YES;
        }else{
            self.mainTableView.mj_footer.hidden = NO;
        }
        
        
            
       
    
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
    }];
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ShopViewController *shopVC= [[ShopViewController alloc]init];
        shopVC.ID = headDic[@"shop_id"];
        [self.navigationController pushViewController:shopVC animated:YES];
    }
    
    
    if (indexPath.section == 1) {
        
        NSArray *temp = headDic[@"price_list"];
       
        NSString *IDs = [temp[indexPath.row] objectForKey:@"id"];
        
        GoodsDetailViewController *shopVC= [[GoodsDetailViewController alloc]init];
        shopVC.ID = IDs;
        shopVC.isGroup = [[temp[indexPath.row] objectForKey:@"is_group"] integerValue];
        
        [self.navigationController pushViewController:shopVC animated:YES];
    }
    
    
    if (indexPath.section == 3) {
        
        AuthorWorkListsViewController *shopVC= [[AuthorWorkListsViewController alloc]init];
        shopVC.authorUuid = _ID;
        [self.navigationController pushViewController:shopVC animated:YES];
        
    }
    
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
            
            [self.mainTableView.mj_header beginRefreshing];
           
            
        }
        
    } faild:^(id responseObject) {
        
    }];
}

#pragma mark - 私信
- (IBAction)messageAction:(UIButton *)sender {
    
    
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

-(void)didselectTel{
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",headDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
}

- (void)didselectLocation{
    
    double lat = [headDic[@"lat"] doubleValue];
    double lng = [headDic[@"lng"] doubleValue];
    
    ShopLocationViewController *locate = [[ShopLocationViewController alloc]init];
    locate.la = lat;
    locate.lo = lng;
    locate.name = headDic[@"shop_name"];
    locate.address = headDic[@"shop_address"];
    locate.matterAry = headDic[@"error_data"];
    locate.ID = headDic[@"shop_id"];
    [self.navigationController pushViewController:locate animated:YES];
    
}

- (void)didselectMainPage{
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = headDic[@"shop_id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 20 ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView.backgroundColor = [UIColor whiteColor];
            [self.backBtn setImage:[UIImage imageNamed:@"返回新"] forState:(UIControlStateNormal)];
            [self.shareBtn setImage:[UIImage imageNamed:@"分享"] forState:(UIControlStateNormal)];
            self.titleLab.hidden = NO;
        }];
    }
    
    if (scrollView.contentOffset.y <= 0 ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView.backgroundColor = [UIColor clearColor];
//            [self.backBtn setImage:[UIImage imageNamed:@"返回2"] forState:(UIControlStateNormal)];
//            [self.shareBtn setImage:[UIImage imageNamed:@"更多2"] forState:(UIControlStateNormal)];
            self.titleLab.hidden = YES;
        }];
    }
    
}


- (void)didselectItem:(NSUInteger)index{
    
    _selectIndex = index-1;
    [self.mainTableView reloadData];
    
}



- (IBAction)telAppointAction:(UIButton *)sender {
    
    NSString *tel = headDic[@"tel"];
    
    if (tel.length) {
        
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",headDic[@"tel"]]]]];
        [self.view addSubview:callWebview];
        
    }
    

}

- (void)payAuthor:(NSUInteger)index{
    
    
    
}


#pragma mark - 查看全部评价
- (void)lookMore:(NSUInteger)index{
    
    ALLCommentViewController *shopVC= [[ALLCommentViewController alloc]init];
    shopVC.type = @"2";
    shopVC.uuid = self.ID;
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

- (void)didselectfollow{
    
    [self followAction:nil];
}

#pragma mark - 代理
- (void)chooseComment:(UIButton *)sender {
    
    NSString *friendID = [self.friendsdataAry[sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}


- (void)chooseMessege:(UIButton *)sender {
    
    
    NSString *uuid = [self.friendsdataAry[sender.tag] objectForKey:@"uuid"];
    ChatViewController *weiVC  = [[ChatViewController alloc]init];
    weiVC.targetId = uuid;
    weiVC.conversationType = ConversationType_PRIVATE;
    weiVC.conversationTitle =[self.friendsdataAry[sender.tag] objectForKey:@"nickname"];
    [self.navigationController pushViewController:weiVC animated:YES];
    
    
    
}

- (void)chooseIcon:(UIButton *)sender{
    
    
    
}

- (void)chooseZan:(UIButton *)sender {
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":[self.friendsdataAry[sender.tag] objectForKey:@"id"],@"type":@"9"}];
    
    [YYNet POST:FriendPraise paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSLog(@"%@",dict);
        
        //        [self.view setNeedsLayout];
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (void)playBtnAction:(UIButton *)sender{
    
    NSString *friendID = [self.friendsdataAry[sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

- (void)moreBtnAction:(UIButton *)sender {
    
    //    NSString *friendID = [[self->_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    NSString *url = [NSString stringWithFormat:@"%@",[[self.friendsdataAry objectAtIndex:sender.tag] objectForKey:@"share_url"]];
    NSUInteger shareType = [[[self.friendsdataAry objectAtIndex:sender.tag] objectForKey:@"type"] integerValue];
    NSString *title = [[self.friendsdataAry objectAtIndex:sender.tag] objectForKey:@"shareTitle"];
    NSString *pic = [[self.friendsdataAry objectAtIndex:sender.tag] objectForKey:@"sharePic"];
    NSString *content = [[self.friendsdataAry objectAtIndex:sender.tag] objectForKey:@"shareContent"];
    //    if ([[[_dataAry objectAtIndex:sender.tag] objectForKey:@"pic"] isKindOfClass:[NSArray class]]) {
    //        pic = [[[[_dataAry objectAtIndex:sender.tag] objectForKey:@"pic"] objectAtIndex:0] objectForKey:@"url"];
    //    }
    //
    [LWShareService shared].shareBtnClickBlock = ^(NSUInteger index) {
        NSLog(@"%lu",(unsigned long)index);
        [[LWShareService shared] hideSheetView];
        
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
                NSString *friendID = [[self.friendsdataAry objectAtIndex:sender.tag] objectForKey:@"id"];
                ReportViewController *reportVC = [[ReportViewController alloc] init];
                reportVC.ID = friendID;
                [self.navigationController pushViewController:reportVC animated:YES];
            }
                break;
            default:
                break;
        }
        
        
        if (shareType == 2) {
            [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
        }else{
            [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
        }
        
        
    };
    [[LWShareService shared] showInViewController:self];
    
}



- (void)chooseShopAddress:(UIButton *)sender {
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = [self.friendsdataAry[sender.tag] objectForKey:@"shop_id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}


@end
