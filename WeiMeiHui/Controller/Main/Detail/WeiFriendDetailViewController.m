//
//  WeiFriendDetailViewController.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiFriendDetailViewController.h"
#define COMMENTH 49

#import "CommentTableViewCell.h"
#import "WeiContentTableViewCell.h"
#import "YZInputView.h"
#import "UITextView+Placeholder.h"
#import "LWShareService.h"
#import "ShareService.h"

#import "UserDetailViewController.h"
#import "AuthorDetailViewController.h"

#import "PlayViewController.h"
#import "ChatViewController.h"
#import "ShopViewController.h"

#import "ReportViewController.h"

@interface WeiFriendDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WeiContentCellDelegate,WeiHeadViewDelegate>
{
    NSMutableArray *commentDataAry;
    NSDictionary *friendsData;
    CGFloat cellHeight;
    NSMutableDictionary *commentHeight;
    YYHud *hud;
    NSUInteger page;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic)  YZInputView *inputView;
@property (strong, nonatomic)  UIButton *pubBtn;

@property (strong, nonatomic)  UIView *commentView;
@end

@implementation WeiFriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    page = 1;
    commentHeight = [NSMutableDictionary dictionary];
    [self configNavView];
//    [self getData];
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
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [_like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.addBtn.mas_left).offset(-Space*2);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
//   tableview
    self.mainTableView.frame = CGRectMake(0, SafeAreaHeight + Space, kWidth, kHeight- SafeAreaHeight-Space-COMMENTH);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
//    加刷新
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->page++;
        [self getData];
    }];
    
    [_mainTableView.mj_header beginRefreshing];
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
    
    
    _commentView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-44, kWidth, 44)];
    [self.view addSubview:_commentView];
    _commentView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    [self.commentView addSubview:line];
    line.backgroundColor = [UIColor lightGrayColor];
    
    
    _pubBtn= [[UIButton alloc]init];
    [self.commentView addSubview:_pubBtn];
    [_pubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(34);
        make.right.mas_equalTo(self.commentView.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.commentView.mas_centerY);
    }];
    
    _pubBtn.layer.cornerRadius = 4;
    _pubBtn.layer.masksToBounds = YES;
    _pubBtn.backgroundColor= [UIColor redColor];
    [_pubBtn setTitle:@"评论" forState:UIControlStateNormal];
    _pubBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_pubBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 设置文本框占位文字
    _inputView = [[YZInputView alloc]init];
    [self.view addSubview:_inputView];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2-48);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.commentView.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.commentView.mas_centerY);
    }];
    
    _inputView.placeholder = @"发表评论";
    _inputView.placeholderColor = MJRefreshColor(102, 102, 102);
    // 监听文本框文字高度改变
    _inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        
    };
    
    _inputView.maxNumberOfLines = 4;
    commentDataAry = [NSMutableArray array];
}

// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
//    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 修改底部视图距离底部的间距
//    _bottomCons.constant = endFrame.origin.y != screenH?endFrame.size.height:0;
    
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        self->_commentView.frame = CGRectMake(0,endFrame.origin.y - 49, kWidth, 49);
        [self.view layoutIfNeeded];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return commentDataAry.count;
    }
    if (friendsData.count) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WeiContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell  = [[WeiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.homeCellViewModel = [WeiContent contentListWithDict:friendsData];
        cellHeight = cell.cellHeight;
        cell.delegate = self;
        
        
        
        return cell;
    }else{
        
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell  = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        
        cell.tag = indexPath.row;
        cell.headView.commentdelegate = self;
        cell.model = [CommentList commentListWithDict:commentDataAry[indexPath.row]];
        cell.modelHome = [WeiContent contentListWithDict:commentDataAry[indexPath.row]];
        [commentHeight setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
        
        return cell;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 43)];
        lab.textColor = MJRefreshColor(51, 51, 51);
        lab.font = [UIFont systemFontOfSize:14];
        lab.backgroundColor = [UIColor whiteColor];
        lab.text = @"   最新评论(0)";
        if (friendsData.count) {
             lab.text = [NSString stringWithFormat:@"   最新评论(%@)",friendsData[@"comments"]];
        }
        [v addSubview:lab];
        return v;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return cellHeight;
    }
    
    return [commentHeight[@(indexPath.row)] doubleValue];
}
- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加关注
- (IBAction)addFriendsAction:(UIButton *)sender {
    
    sender.highlighted = NO;
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    NSString *issue_uuid = friendsData[@"issue_uuid"];
    
   NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"from_uuid":uuid,@"to_uuid":issue_uuid}];
    
    [YYNet POST:FriendFollow paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        
        if ([dict[@"success"] boolValue]) {
            sender.selected = !sender.selected;
            if (sender.selected) {
                
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已关注" iconImage:[UIImage imageNamed:@"success"]];
                toast.toastType = FFToastTypeSuccess;
                toast.toastPosition = FFToastPositionDefault;
                [toast show];
                
            }else{
                
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已取消关注" iconImage:[UIImage imageNamed:@"success"]];
                toast.toastType = FFToastTypeSuccess;
                toast.toastPosition = FFToastPositionDefault;
                [toast show];
                
            }
            
    
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionDefault;
            [toast show];
            
        }
        
        
    } faild:^(id responseObject) {
        
         NSDictionary *dict = [solveJsonData changeType:responseObject];
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionDefault;
        [toast show];
        
    }];
    
}

#pragma mark - 喜欢
- (IBAction)likeAction:(UIButton *)sender {
    
    sender.highlighted = NO;
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":_friendID,@"type":@"9"}];
    
    [YYNet POST:FriendCollect paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        if ([dict[@"success"] boolValue]) {
            sender.selected = !sender.selected;
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionDefault;
            [toast show];
            
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionDefault;
            [toast show];
            
        }
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

#pragma mark - 提交评论
- (void)commentAction{
    
  
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    if (!self.inputView.text.length) {
        return;
    }
    
    hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    
    
    
    NSString *issue_uuid = friendsData[@"issue_uuid"];
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"from_uuid":uuid,@"friends_group_id":_friendID,@"content":_inputView.text,@"to_uuid":issue_uuid}];
    
    [YYNet POST:SendComment paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        [self->hud dismiss];
        
        NSLog(@"%@",dict);
        self->_inputView.text = @"";
        [self.view endEditing:YES];
        
        if ([dict[@"success"] boolValue]) {
            [self getData];
        }
        
        
        
    } faild:^(id responseObject) {
        
        [self->hud dismiss];
        
    }];
    
}

- (void)getData{
    
    hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":_friendID,@"lat":lat,@"lng":lng,@"page":@(page)}];
    
    [YYNet POST:FriendDetails paramters:@{@"json":url} success:^(id responseObject) {
        
        [self->hud dismiss];
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        self->friendsData = dict[@"data"];
        
        if (self->page == 1) {
            
            self->commentDataAry = [dict[@"data"] objectForKey:@"comments_list"];
            
        }else{
            
            [self->commentDataAry addObjectsFromArray: [dict[@"data"] objectForKey:@"comments_list"]];
            
        }
        
        self->_like.selected = NO;
        
        if ([self->friendsData[@"is_collect"] boolValue]) {
            self->_like.selected = YES;
        }
        
        if ([self->friendsData[@"is_relationship"] integerValue] == 0) {
            self->_addBtn.selected = NO;
        }
        
        if ([self->friendsData[@"is_relationship"] integerValue] == 1) {
            self->_addBtn.selected = YES;
        }
    
        if ([self->friendsData[@"is_relationship"] integerValue] == 2) {
            self->_addBtn.selected = YES;
        }
        
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        [self->hud dismiss];
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        
        
    }];
}

#pragma mark - 更多
- (void)moreBtnAction:(UIButton *)sender{
    
//    NSString *friendID = [friendsData objectForKey:@"id"];
    NSString *url = [NSString stringWithFormat:@"%@",[friendsData objectForKey:@"share_url"]];
    NSUInteger shareType = [[friendsData objectForKey:@"type"] integerValue];
    NSString *title = [friendsData objectForKey:@"shareTitle"];
    NSString *pic =  [friendsData objectForKey:@"sharePic"];;
    NSString *content =  [friendsData objectForKey:@"shareContent"];

    
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
//                    NSString *friendID = [self->friendsData objectForKey:@"id"];
                    ReportViewController *reportVC = [[ReportViewController alloc] init];
                    reportVC.ID = self.friendID;
                    [self.navigationController pushViewController:reportVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            
            
            if (shareType == 2) {
                [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
            }else{
                [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeVideo copyUrl:url];
            }
            
            
        }else{
            LoginViewController *log = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:log animated:YES];
        }
        
    };
    [[LWShareService shared] showInViewController:self];
    
}

#pragma mark - 评论
- (void)chooseComment:(UIButton *)sender {
    [_inputView becomeFirstResponder];
}


#pragma mark - 私信
- (void)chooseMessege:(UIButton *)sender {
    
    
    if ([PublicMethods isLogIn]) {
        
        NSString *uuid = [friendsData objectForKey:@"issue_uuid"];
        ChatViewController *weiVC  = [[ChatViewController alloc]init];
        weiVC.targetId = uuid;
        weiVC.conversationTitle = [friendsData objectForKey:@"nickname"];
        weiVC.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
}

#pragma mark - 点赞
- (void)chooseZan:(UIButton *)sender {
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
//    sender.selected = !sender.selected;
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":_friendID,@"type":@"9"}];
    
    [YYNet POST:FriendPraise paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSLog(@"%@",dict);
        
        [self.mainTableView.mj_header beginRefreshing];
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}



- (void)playBtnAction:(UIButton *)sender{
    PlayViewController *vedioVC = [[PlayViewController alloc] init];
    NSString *fileUrl = [[friendsData[@"pic"] objectAtIndex:0] objectForKey:@"original_url"];
    NSLog(@"fileUrl:%@",fileUrl);
    //        做判断
    vedioVC.urlStr = fileUrl;
    [self.navigationController pushViewController:vedioVC animated:YES];
    
}


- (void)chooseIcon:(UIButton *)sender{
    
    NSUInteger level = [[friendsData objectForKey:@"grade"] integerValue];
    
    if (level == 0) {
        
        NSString *friendID = [friendsData objectForKey:@"issue_uuid"];
        UserDetailViewController *weiVC  = [[UserDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        NSString *friendID = [friendsData objectForKey:@"issue_uuid"];
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
}

- (void)chooseShopAddress:(UIButton *)sender {
    
    ShopViewController *shopVC= [[ShopViewController alloc]init];
    shopVC.ID = friendsData[@"shop_id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}


- (void)didSelectedIconBtn:(UIButton *)sender{
    
    NSUInteger level = [[commentDataAry[sender.tag] objectForKey:@"grade"] integerValue];
    
    if (level == 0) {
        
        NSString *friendID = [commentDataAry[sender.tag] objectForKey:@"from_uuid"];
        UserDetailViewController *weiVC  = [[UserDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else{
        
        NSString *friendID = [commentDataAry[sender.tag] objectForKey:@"from_uuid"];
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = friendID;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
    
}


@end
