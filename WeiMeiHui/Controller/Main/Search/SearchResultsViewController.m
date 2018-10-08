//
//  SearchResultsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "WeiContentTableViewCell.h"
#import "HWDownSelectedView.h"
#import "PlayViewController.h"
#import "UserDetailViewController.h"
#import "AuthorDetailViewController.h"
#import "WeiFriendDetailViewController.h"
#import "ChatViewController.h"
#import "ShopViewController.h"
#import "LWShareService.h"
#import "ShareService.h"
#import "ReportViewController.h"

@interface SearchResultsViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,WeiContentCellDelegate,HWDownSelectedViewDelegate>

{
    NSMutableArray *_dataAry;
    NSMutableDictionary *_heightDic;
    NSUInteger page;
    YMRefresh *_ymRefresh;
    NSString*type;
    NSString *sequence;
    NSUInteger sequenceIndex;
}

@property (weak, nonatomic) IBOutlet UIView *dropView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;



@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchImg;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (strong, nonatomic)  HWDownSelectedView *down2;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    _dataAry = [NSMutableArray array];
    _heightDic = [NSMutableDictionary dictionary];
    sequence = @"1";
    type = @"";
    page = 1;
    _searchTF.delegate = self;
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);
//        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [_textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*4-48-buttonWidth);
        make.height.mas_equalTo(buttonHeight);
        make.left.mas_equalTo(self.backBtn.mas_right).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _textBgView.layer.cornerRadius = 14;
    _textBgView.layer.masksToBounds = YES;
    
    [_searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textBgView.mas_left).offset(Space);
        make.top.mas_equalTo(self.textBgView.mas_top).offset(5);
    }];
    
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*5-buttonWidth*3);
        make.height.mas_equalTo(buttonHeight);
        make.left.mas_equalTo(self.searchImg.mas_right).offset(Space);
        make.top.mas_equalTo(self.textBgView.mas_top).offset(0);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space+44, kWidth, kHeight-SafeAreaHeight-Space-44);
    
    _ymRefresh = [[YMRefresh alloc] init];
    __weak SearchResultsViewController *weakSelf = self;
    [_ymRefresh gifModelRefresh:_mainTableView refreshType:RefreshTypeDouble firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        self->page = 1;
        [self getData];
        
    } upDropBlock:^{
        
        if ([weakSelf.mainTableView.mj_footer isRefreshing]) {
            self->page++;
            [self getData];
        }
    }];
    
    [_dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(1);
    }];
    
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(1);
    }];
    
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    down.listArray = @[@"全部",@"精选", @"同城",@"关注"];
    [self.view addSubview:down];
    
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.dropView.mas_top).offset(0);
    }];
    down.delegate = self;
    down.tag = 1;
    self.down1 = down;
    
    HWDownSelectedView *downv = [HWDownSelectedView new];
    downv.backgroundColor = [UIColor whiteColor];
    downv.listArray = @[@"综合排序",@"最新发布", @"浏览最多",@"距离最近"];
    [self.view addSubview:downv];
    //    down.frame = CGRectMake(kWidth-100-Space, SafeAreaTopHeight-10, 100, 40);
    [downv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.down1.mas_left).offset(Space);
        make.top.mas_equalTo(self.dropView.mas_top).offset(0);
    }];
    downv.delegate = self;
    downv.tag = 2;
    self.down2 = downv;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        WeiContentTableViewCell *cell = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.delegate = self;
        
        cell.homeCellViewModel = [WeiContent contentListWithDict:_dataAry[indexPath.section]];
        cell.tag = indexPath.section;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return nil;
}

- (void)getData{
    
    //网络请求
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
    
    if (!city_id) {
        city_id = @"";
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":type,@"content":_content,@"sequence":sequence,@"lat":lat,@"lng":lng,@"page":@(page)}];
    
    [YYNet POST:SearchREsults paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        NSDictionary *headDic = dic[@"data"];
        
        NSArray *temp  = @[];
        
        self->_countLab.text = [NSString stringWithFormat:@"%@篇作品",headDic[@"count"]];
        
        if ([[headDic objectForKey:@"friends_data"] isKindOfClass:[NSArray class]]) {
            temp = [headDic objectForKey:@"friends_data"];
        }
        
        
        
        if (self->page == 1) {
            
            if (temp.count == 0) {
                self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"搜索内容为空"
                                                                            titleStr:@""
                                                                           detailStr:@""];
            }
            
            [self->_dataAry setArray:temp];
            
        }else{
            [self->_dataAry addObjectsFromArray:temp];
            
        }
        
        if (temp.count<10) {
            [self->_mainTableView.mj_footer endRefreshingWithNoMoreData];
            [self->_mainTableView.mj_header endRefreshing];
            self->_mainTableView.tableFooterView.hidden = YES;
        }else{
            self->_mainTableView.mj_footer.hidden = NO;
             self->_mainTableView.tableFooterView.hidden = NO;
            [self->_mainTableView.mj_header endRefreshing];
            [self->_mainTableView.mj_footer endRefreshing];
            
        }
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}

#pragma mark - 评论
- (void)chooseComment:(UIButton *)sender {
    
    NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

#pragma mark - 个人主页
- (void)chooseIcon:(UIButton *)sender {
    
    NSUInteger level = [[[_dataAry objectAtIndex:sender.tag] objectForKey:@"level"] integerValue];
    
    if (level == 3) {
        
        NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
        UserDetailViewController *weiVC  = [[UserDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        NSString *friendID = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
    
}

#pragma mark - 私信
- (void)chooseMessege:(UIButton *)sender {
    
    NSString *uuid = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"uuid"];
    if ([PublicMethods isLogIn]) {
        
        
        ChatViewController *weiVC  = [[ChatViewController alloc]init];
        weiVC.targetId = uuid;
        weiVC.conversationTitle = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"nickname"];;
        weiVC.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
    
}
#pragma mark - 商家
- (void)chooseShopAddress:(UIButton *)sender {
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = _dataAry[sender.tag][@"shop_id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

#pragma mark - 点赞
- (void)chooseZan:(UIButton *)sender {
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":[_dataAry[sender.tag] objectForKey:@"id"],@"type":@"9"}];
    
    [YYNet POST:FriendPraise paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSLog(@"%@",dict);
        
        //        [self.view setNeedsLayout];
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

#pragma mark - 分享
- (void)moreBtnAction:(UIButton *)sender {
    
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
    
    PlayViewController *vedioVC = [[PlayViewController alloc] init];
    NSString *fileUrl = [[[[_dataAry objectAtIndex:sender.tag] objectForKey:@"pic"] objectAtIndex:0] objectForKey:@"original_url"];
    
    NSLog(@"fileUrl:%@",fileUrl);
    //        做判断
    vedioVC.urlStr = fileUrl;
    [self.navigationController pushViewController:vedioVC animated:YES];
    
    
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


- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath {
    
    //    附近
    if (selectedView.tag == 1) {
        
        if (indexPath.row == 0) {
            
            type = @"";
            
        }else{
            
            type = [NSString stringWithFormat:@"%lu",indexPath.row];
            
        }
        
    }
    
    //    手艺人
    if (selectedView.tag == 2) {
        
            sequence = [NSString stringWithFormat:@"%lu",indexPath.row+1];
        
    }
    
    [self getData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _searchTF.text = _content;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

@end
