//
//  ShopViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopViewController.h"
#import "FamousShopTitleTableViewCell.h"
#import "AuthorListTableViewCell.h"
#import "AuthorDetailHead.h"
#import "FamousGoodsTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "WeiContentTableViewCell.h"
#import "UserHeaderView.h"
#import "WeiFriendDetailViewController.h"
#import "AuthorDetailViewController.h"
#import "ChatViewController.h"
#import "LWShareService.h"
#import "ReportViewController.h"
#import "PlayViewController.h"
#import "GBTagListView.h"
#import "CommentOrderTableViewCell.h"
#import "SearchFooterTableViewCell.h"
#import "ALLCommentViewController.h"
#import "ShopLocationViewController.h"
#import "ShopCardTableViewCell.h"
#import "PayStyleViewController.h"
#import "FamousShopGoodsViewController.h"
#import "NextFreeNewViewController.h"

@interface ShopViewController ()<UITableViewDelegate,UITableViewDataSource,WeiContentCellDelegate,AuthorListTableViewCellDelegate,FamousShopTitleTableViewCellDelegate,SearchFooterDelegate>{
    
    
//    NSMutableDictionary *_heightDic;
//    NSUInteger page;
    NSDictionary *headDic;
//    NSArray *authorData;
    NSString *filtID;
    
}

//@property (strong, nonatomic)  NSMutableDictionary *footerState;
@property (strong, nonatomic) NSMutableArray *dataAry;
@property (copy, nonatomic) NSArray *orderdataAry;
@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (copy, nonatomic) NSArray *carddataAry;
@property (strong, nonatomic) NSMutableDictionary *heightDic;
@property (strong, nonatomic) NSMutableDictionary *commentHeightDic;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (copy, nonatomic) NSArray *authorData;
@property (copy, nonatomic) NSArray *goodsData;
@property (assign, nonatomic) NSUInteger page;
@property (copy, nonatomic) NSString *friendsCount;
@property (copy, nonatomic) NSArray *shopErrorData;
@property (copy, nonatomic) NSString *goodsCount;
@property (copy, nonatomic) NSString *commsCount;
@property (strong, nonatomic)  AuthorDetailHead *head ;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (copy, nonatomic) NSArray *tagAry;
@property (strong, nonatomic) GBTagListView *bubbleView;
@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.commentHeightDic = [NSMutableDictionary dictionary];
//    self.footerState = [NSMutableDictionary dictionary];
    _page = 1;
    filtID = @"";
    
    _friendsCount = @"";
    [self configNavView];
    
}
- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configNavView {
    
    MJWeakSelf
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.view.mas_right).offset(-Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.centerY.equalTo(self.backBtn.mas_centerY).offset(0);
        make.height.equalTo(@(20));
        make.width.equalTo(@(kWidth-Space*2));
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, 0, kWidth, kHeight);
    
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
//    卡
    if (section == 1) {
        
        return self.carddataAry.count;
    }
    
    if (section == 2) {
        if (_authorData.count == 0) {
            return 0;
        }
        
        return 1;
    }
    
    if (section == 3) {
        if (_goodsData.count == 0) {
            return 0;
        }
        
        return _goodsData.count;
    }
    
    if (section == 4) {
        if (_orderdataAry.count == 0) {
            return 0;
        }
        
        return _orderdataAry.count;
    }
    
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        FamousShopTitleTableViewCell *cell = [FamousShopTitleTableViewCell famousShopTitleTableViewCell];
        cell.author = [ShopAndAuthor shopAuthorWithDict:_dataDic];
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 1){//卡
        
        ShopCardTableViewCell *cell = [ShopCardTableViewCell shopCardTableViewCell];
        cell.card = [ShopCard shopCardWithDict:self.carddataAry[indexPath.row]];
        return cell;
        
    }else if (indexPath.section == 2){
        
        AuthorListTableViewCell *cell = [[AuthorListTableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.author = _authorData;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 3){
        
        FamousGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailT"];
        
        if (!cell) {
            
            cell = [FamousGoodsTableViewCell  famousGoodsTableViewCellSearch];
        }
        
        cell.goodsSearch = [AuthorGoods authorGoodsWithDict:self.goodsData[indexPath.row]];
        
        return cell;
        
    }else if (indexPath.section == 4){
        
        CommentOrderTableViewCell *cell = [CommentOrderTableViewCell commentOrderTableViewCell];
        cell.comment = [OrderComment orderCommentWithDict:self.orderdataAry[indexPath.row]];
        _commentHeightDic[@(indexPath.row)] = @(cell.cellHeight);
        return cell;
        
    }else{
        
        WeiContentTableViewCell *cell = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.homeCellViewModel = [WeiContent contentListWithDict:_dataAry[indexPath.row]];
    
        [_heightDic setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return kWidth*200/375+80;
    }
    
    if (indexPath.section == 1 && _carddataAry.count) {

        return 100;
    
    }
    
    if (indexPath.section == 2 && _authorData.count) {
 
        return 174;
    }
    
    if (indexPath.section == 3 && _goodsData.count) {
        return 88;
    }
    
    if (indexPath.section == 4 && _orderdataAry.count) {
        
        return [_commentHeightDic[@(indexPath.row)] doubleValue];;
    }
    
    return [_heightDic[@(indexPath.row)] doubleValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return Space;
    }
    
    if (section == 4) {
        return 54;
    }
    
    if (section == 3&& self.orderdataAry.count) {
        return 54;
    }
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2 && _authorData.count) {
        return 44;
    }
    
    if (section == 3 && _goodsData.count) {
        return 44+44+1;
    }
    
    if (section == 4) {
        return [_heightDic[@"head"] doubleValue];
    }
    
    if (section == 5) {
        return 54;
    }
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        
        UIView *v = [[UIView alloc]init];
        v.backgroundColor =[UIColor groupTableViewBackgroundColor];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
            
            [btn setTitle:self.goodsCount forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"向下红"] forState:UIControlStateNormal];
            
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
            btn.tag = section;
            [btn addTarget:self action:@selector(lookMoreGoods:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            btn.backgroundColor = [UIColor whiteColor];
        [v addSubview:btn];
            return v;
        
        
    }
    
    
    if (section == 4 && self.orderdataAry.count) {
        
            UIView *v = [UIView new];
            v.backgroundColor= [UIColor groupTableViewBackgroundColor];
            
            SearchFooterTableViewCell *cell = [SearchFooterTableViewCell searchFooterTableViewCellFooter];
            cell.countLab.text = [NSString stringWithFormat:@"共%@条",self.commsCount];
            cell.frame = CGRectMake(0, 0, kWidth, 44);
            [v addSubview:cell];
        cell.delegate = self;
            return v;

        
    }
    
    return nil;
}

- (void)lookMoreGoods:(UIButton *)sender{
    
    
    FamousShopGoodsViewController *detailVc = [[FamousShopGoodsViewController alloc]init];
    detailVc.ID = _dataDic[@"uuid"];
    detailVc.name =_dataDic[@"shop_name"];
    detailVc.tagID = @"";
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

#pragma mark - 查看全部评价
- (void)lookMore:(NSUInteger)index{
    
    ALLCommentViewController *shopVC= [[ALLCommentViewController alloc]init];
    
    shopVC.type = @"1";
    shopVC.uuid = _dataDic[@"uuid"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        lab.text = @"   手艺人团队";
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = MJRefreshColor(51, 51, 51);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kWidth, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [v addSubview:line];
        [v addSubview:lab];
        
        return v;
    }
    
    if (section == 3) {
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        lab.text = @"   热卖服务";
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = MJRefreshColor(51, 51, 51);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kWidth, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 43+44, kWidth, 1)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [v addSubview:line];
        [v addSubview:lab];
        [v addSubview:self.bubbleView];
        [v addSubview:line2];
        
        return v;
    }
    
    if (section == 4) {
        
        UIView *v = [UIView new];
        self.head.frame = CGRectMake(0, 0, kWidth, [_heightDic[@"head"] doubleValue]);
        [v addSubview:self.head];
        return v;
    }
    
    
    if (section == 5) {
        
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

#pragma mark- 滑动
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
            [self.backBtn setImage:[UIImage imageNamed:@"返回白"] forState:(UIControlStateNormal)];
            [self.shareBtn setImage:[UIImage imageNamed:@"分享白"] forState:(UIControlStateNormal)];
            self.titleLab.hidden = YES;
        }];
    }
    
}



#pragma mark- 获取数据
- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":_ID,@"lat":lat,@"lng":lng,@"order":@"",@"page":@(_page)}];
    
    [YYNet POST:ShopDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->headDic = dic[@"data"];
        
        
        self.shopErrorData = self->headDic[@"error_data"];
        self.friendsCount = self->headDic[@"friends_count"];
        self.goodsCount = self->headDic[@"group_count"];
        self.commsCount = self->headDic[@"evaluate_count"];
        self.carddataAry = self->headDic[@"hair_data"];
        self.head.tagAry = self->headDic[@"service_tag"];
        
        self.head.model = [ShopModel shopModeltWithDict:self->headDic];
        self.heightDic[@"head"] = @(self.head.cellHeight);
        
        if ([self->headDic[@"author_data"] isKindOfClass:[NSArray class]]) {
            self.authorData = self->headDic[@"author_data"];
        }
        
        if ([self->headDic[@"evaluate_list"] isKindOfClass:[NSArray class]]) {
            self.orderdataAry = self->headDic[@"evaluate_list"];
        }
        
        if ([self->headDic[@"group_data"] isKindOfClass:[NSArray class]]) {
            self.goodsData = self->headDic[@"group_data"];
        }
        
        self.dataDic = self->headDic[@"shop_data"];
        self.titleLab.text = self.dataDic[@"shop_name"];
        
        NSArray *temp  = @[];
        
        if ([[self->headDic objectForKey:@"friends_data"] isKindOfClass:[NSArray class]]) {
            temp = [self->headDic objectForKey:@"friends_data"];
        }
        
        if (self.page == 1) {
            [self.dataAry setArray:temp];
            
        }else{
            [self.dataAry addObjectsFromArray:temp];
            
        }
        
        
        
        if (temp.count<10) {
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            [self.mainTableView.mj_header endRefreshing];
            self.mainTableView.mj_footer.hidden = YES;
        }else{
            self.mainTableView.mj_footer.hidden = NO;
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            
        }
        
        if ([[dic[@"data"] objectForKey:@"tag_name"] isKindOfClass:[NSArray class]]) {
            
            self.tagAry = [dic[@"data"] objectForKey:@"tag_name"];
            
        }
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        
    }];
    
}


- (void)chooseComment:(UIButton *)sender {
    
    NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

#pragma mark - 点击头像加参数
- (void)chooseIcon:(UIButton *)sender {
    
    NSString *uuid = [_dataAry[sender.tag] objectForKey:@"uuid"];
    AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
    detailVc.ID = uuid;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}
#pragma mark - 私信
- (void)chooseMessege:(UIButton *)sender {
    
    NSString *uuid = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
    if ([PublicMethods isLogIn]) {
        
        //            连接融云服务器
        
        //            [[RCIM sharedRCIM] setUserInfoDataSource:self];
        
        ChatViewController *weiVC  = [[ChatViewController alloc]init];
        weiVC.targetId = uuid;
        weiVC.conversationType = ConversationType_PRIVATE;
        weiVC.conversationTitle = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"nickname"];
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
    
}
#pragma mark - 赞
- (void)chooseZan:(UIButton *)sender {
    
    if ([PublicMethods isLogIn]) {
        
        NSString *friendID = [[self.dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
        
        NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":friendID,@"type":@"9"}];
        
        [YYNet POST:FriendPraise paramters:@{@"json":url} success:^(id responseObject) {
            
            NSDictionary *dict = [solveJsonData changeType:responseObject];
            
            NSLog(@"%@",dict);
            
        } faild:^(id responseObject) {
            
            
            
        }];
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
}
#pragma mark - 更多
- (void)moreBtnAction:(UIButton *)sender {
    
//    NSString *friendID = [[_dataAry objectAtIndex:sender.tag-2] objectForKey:@"id"];
    NSString *url = [NSString stringWithFormat:@"%@",[[_dataAry objectAtIndex:sender.tag] objectForKey:@"share_url"]];
    NSUInteger shareType = [[[_dataAry objectAtIndex:sender.tag] objectForKey:@"type"] integerValue];
    NSString *title = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"shareTitle"];
    NSString *pic = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"sharePic"];;
  NSString *content = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"shareContent"];
    
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
                    NSString *friendID = [[self.dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
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
    [[LWShareService shared] showInViewControllerTwo:self];
    
}

#pragma mark - 播放视频
- (void)playBtnAction:(UIButton *)sender {
    
    PlayViewController *vedioVC = [[PlayViewController alloc] init];
    NSString *fileUrl = [[[[_dataAry objectAtIndex:sender.tag] objectForKey:@"pic"] objectAtIndex:0] objectForKey:@"original_url"];
    
    NSLog(@"fileUrl:%@",fileUrl);
    //        做判断
    vedioVC.urlStr = fileUrl;
    [self.navigationController pushViewController:vedioVC animated:YES];
    
}

- (void)chooseShopAddress:(UIButton *)sender {
    
}

#pragma mark - 调地图
- (void)didselectLocation{
    
    double lat = [_dataDic[@"lat"] doubleValue];
    double lng = [_dataDic[@"lng"] doubleValue];
    
    ShopLocationViewController *locate = [[ShopLocationViewController alloc]init];
    locate.la = lat;
    locate.lo = lng;
    locate.name = _dataDic[@"shop_name"];
    locate.address = _dataDic[@"address"];
    locate.matterAry = self.shopErrorData;
    locate.ID = self.ID;
    [self.navigationController pushViewController:locate animated:YES];
    
}

-(void)didselectTel{
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",_dataDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return;
    }
    
//    卡
    if (indexPath.section == 1) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = self.carddataAry[indexPath.row][@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
//        [self payAction:self.carddataAry[indexPath.row][@"id"]];
    }
    
    
//    商品
    if (indexPath.section == 3) {
        
        NSString *temp = [_goodsData[indexPath.row] objectForKey:@"id"];
        
        GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
        detailVc.ID = temp;
        detailVc.isGroup = [[_goodsData[indexPath.row] objectForKey:@"is_group"] integerValue];
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }
    
//
    if (indexPath.section == 5) {
     
        NSString *friendID = [[_dataAry objectAtIndex:indexPath.row] objectForKey:@"id"];
        WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
        weiVC.friendID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
   
    
}


#pragma mark- 支付
- (void)payAction:(NSString *)cardID{
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":cardID}];
    
    [YYNet POST:CardsBuy paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
            payVC.ordernumber = [dic[@"data"] objectForKey:@"order_number"];
            payVC.price = [dic[@"data"] objectForKey:@"price"];
            
            payVC.notifyUrlAli = AliCardsNotifyUrl;
            payVC.notifyUrlWeixin = WXCardsNotifyUrl;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            return ;
            
        }
        
        
    } faild:^(id responseObject) {
        
    }];
    
}


- (void)selectAuthor:(NSUInteger)index{
    
    NSString *friendID = [[_authorData objectAtIndex:index] objectForKey:@"uuid"];
    AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
    weiVC.ID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

- (void)locationAction{
    
    [self didselectLocation];
    
}

#pragma mark- 关注手艺人
- (void)followAction:(NSUInteger)index{
    
    if (![PublicMethods isLogIn]) {
        
        LoginViewController *logVC= [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        return;
    }
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *to_uuid = [self.authorData[index] objectForKey:@"uuid"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"from_uuid":uuid,@"to_uuid":to_uuid}];
    
    [YYNet POST:FriendFollow paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        
        if ([dict[@"success"] boolValue]) {
            
            [self.mainTableView.mj_header beginRefreshing];
            
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
}


- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 55, kWidth, 44)];
        /**允许点击 */
        _bubbleView.canTouch=YES;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=YES;
        _bubbleView.signalTagColor=[UIColor whiteColor];
        [_bubbleView setMarginBetweenTagLabel:20 AndBottomMargin:12];
//        _bubbleView.selectedIndex = 0;
//        _bubbleView.isDefaultSelect = YES;
        
        MJWeakSelf
        _bubbleView.didselectItemBlock = ^(NSArray *arr) {
            if (!arr.count) {
                return ;
            }
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *name in weakSelf.tagAry) {
                
                [temp addObject:name[@"name"]];
                
            }
            
            NSUInteger index = [temp indexOfObject:arr[0]];
            self->filtID = [self.tagAry[index] objectForKey:@"id"];
//            [weakSelf.mainTableView.mj_header beginRefreshing];
            
            FamousShopGoodsViewController *detailVc = [[FamousShopGoodsViewController alloc]init];
            detailVc.ID = self->_dataDic[@"uuid"];
            detailVc.name =self->_dataDic[@"shop_name"];
            detailVc.tagID = self->filtID;
            [weakSelf.navigationController pushViewController:detailVc animated:YES];
        };
        
    }
    
    return _bubbleView;
}

- (void)setTagAry:(NSArray *)tagAry{
    
    _tagAry = tagAry;
    [self.bubbleView removeFromSuperview];
    self.bubbleView = nil;
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSDictionary *obj in tagAry) {
        [temp addObject:obj[@"name"]];
    }
    
    [self.bubbleView setTagWithTagArray:temp];
    
}


- (IBAction)shareAction:(UIButton *)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@",headDic[@"share_url"]];
    
    NSString *title = headDic[@"shareTitle"];
    NSString *pic = headDic[@"sharePic"];
    NSString *content = headDic[@"shareContent"];
    
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
            
            
            [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
            
            
            
            
        }else{
            LoginViewController *log = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:log animated:YES];
        }
        
    };
    [[LWShareService shared] showInViewControllerTwo:self];
    
}

@end
