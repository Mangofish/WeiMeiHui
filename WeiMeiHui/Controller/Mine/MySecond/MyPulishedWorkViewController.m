//
//  MyPulishedWorkViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyPulishedWorkViewController.h"
#import "WeiContentTableViewCell.h"
#import "WeiFriendDetailViewController.h"
#import "ReportViewController.h"
#import "ShareService.h"
#import "LWShareService.h"
#import "ShopViewController.h"
#import "ChatViewController.h"

#import "UserDetailViewController.h"
#import "AuthorDetailViewController.h"

#import "HNPopMenuManager.h"
#import "HNPopMenuModel.h"

@interface MyPulishedWorkViewController ()<UITableViewDelegate,UITableViewDataSource,WeiContentCellDelegate>{
    
    NSMutableArray *_dataAry;
    NSUInteger page;
    NSMutableDictionary *_heightDic;
    NSString *path;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,copy) NSArray *dataArr;

@end

@implementation MyPulishedWorkViewController

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
    
    if (_type == 1) {
        _titleLab.text = @"我发布的作品";
        path = MinePublished;
    }else{
        _titleLab.text = @"我收藏的作品";
        path = MineCollected;
    }
    
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
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(page)}];
    
    [YYNet POST:path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSArray *temp = @[];
        
        if ( [[dic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            temp =  [dic objectForKey:@"data"];
        }
        
        if (self->page == 1) {
            if (self->_type == 1) {
                
                if (temp.count == 0) {
                    self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有作品"
                                                                                titleStr:@""
                                                                               detailStr:@""];
                }
                
            }else{
                
                if (temp.count == 0) {
                    self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有收藏"
                                                                                titleStr:@""
                                                                               detailStr:@""];
                }
                
            }
           
            
            
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
    
    cell.delegate = self;
    
    if (_type == 1) {
        cell.isDel = YES;
    }
    
    cell.tag = indexPath.section;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    NSString *friendID = [_dataAry[sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

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

- (void)chooseMessege:(UIButton *)sender {
    
        
        NSString *uuid = [_dataAry[sender.tag] objectForKey:@"uuid"];
        ChatViewController *weiVC  = [[ChatViewController alloc]init];
        weiVC.targetId = uuid;
        weiVC.conversationType = ConversationType_PRIVATE;
        weiVC.conversationTitle =[_dataAry[sender.tag] objectForKey:@"nickname"];
        [self.navigationController pushViewController:weiVC animated:YES];
        
    
    
}

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

- (void)playBtnAction:(UIButton *)sender{
    
    NSString *friendID = [_dataAry[sender.tag] objectForKey:@"id"];
    WeiFriendDetailViewController *weiVC  = [[WeiFriendDetailViewController alloc]init];
    weiVC.friendID = friendID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        
        NSArray *titleArr = @[];
        
        if (self.type != 1) {
            titleArr = @[@"分享", @"取消收藏"];
        }else{
            titleArr = @[@"分享", @"删除"];
        }
        
        for (int i = 0; i < titleArr.count; i++) {
            HNPopMenuModel *model = [[HNPopMenuModel alloc] init];
            model.title = titleArr[i];
//            model.imageName = titleArr[i];
            [tempArr addObject:model];
        }
        _dataArr = [tempArr mutableCopy];
    }
    return _dataArr;
}

- (void)moreBtnAction:(UIButton *)sender {
    
    WeiContentTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    
    [HNPopMenuManager showPopMenuWithView:cell items:self.dataArr action:^(NSInteger row) {
        
        NSLog(@"第%ld行被点击了",row);
        
        //        会员卡
        
        if (row == 0) {
           
            //    NSString *friendID = [[self->_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
            NSString *url = [NSString stringWithFormat:@"%@",[[self->_dataAry objectAtIndex:sender.tag] objectForKey:@"share_url"]];
            NSUInteger shareType = [[[self->_dataAry objectAtIndex:sender.tag] objectForKey:@"type"] integerValue];
            NSString *title = [[self->_dataAry objectAtIndex:sender.tag] objectForKey:@"shareTitle"];
            NSString *pic = [[self->_dataAry objectAtIndex:sender.tag] objectForKey:@"sharePic"];
            NSString *content = [[_dataAry objectAtIndex:sender.tag] objectForKey:@"shareContent"];
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
                    [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
                }else{
                    [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
                }
                
                
            };
            [[LWShareService shared] showInViewController:self];
            
        }
        
        if (row == 1) {
            
            if (self.type == 1) {
                
                NSString *cVStr = @"确定删除？";
                
                CKAlertViewController *cV =  [CKAlertViewController alertControllerWithTitle:@"" message:cVStr];
                
                CKAlertAction *action = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                    
                    
                    
                } ];
                
                CKAlertAction *action2 = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                    
                    
                    [self chooseDel:sender];
                    
                } ];
                
                [cV addAction:action];
                [cV addAction:action2];
                
                [self presentViewController:cV animated:YES completion:nil];
                
                
            }else{
                
//                添加弹窗
                NSString *cVStr = @"确定取消收藏";
                
                CKAlertViewController *cV =  [CKAlertViewController alertControllerWithTitle:@"" message:cVStr];
                
                CKAlertAction *action = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                    
                    
                    
                } ];
                
                CKAlertAction *action2 = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                    
                     [self likeAction:sender];
                    
                } ];
                
                [cV addAction:action];
                [cV addAction:action2];
                
                [self presentViewController:cV animated:YES completion:nil];
                
               
                
            }
            
            
        }
        
    } dismissAutomatically:YES];
    
    
    
    

    
}


#pragma mark - 喜欢
- (void)likeAction:(UIButton *)sender {
    NSString *ID = [[self->_dataAry objectAtIndex:sender.tag] objectForKey:@"id"];
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":ID,@"type":@"9"}];
    
    [YYNet POST:FriendCollect paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        if ([dict[@"success"] boolValue]) {
            
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionDefault;
            [toast show];
            [self.mainTableView.mj_header beginRefreshing];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionDefault;
            [toast show];
            
        }
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}



- (void)chooseShopAddress:(UIButton *)sender {
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = [_dataAry[sender.tag] objectForKey:@"shop_id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

#pragma mark - 删除帖子
- (void)chooseDel:(UIButton *)sender{
    
//    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"id":[_dataAry[sender.tag] objectForKey:@"id"]}];
    
    [YYNet POST:DElFridends paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        if ([dict[@"success"] boolValue]) {
            sender.selected = !sender.selected;
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionDefault;
            [toast show];
            
            [self.mainTableView.mj_header beginRefreshing];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionDefault;
            [toast show];
            
        }
        
        
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
    
}



@end
