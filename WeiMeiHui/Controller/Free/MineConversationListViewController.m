//
//  MineConversationListViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MineConversationListViewController.h"
#import "ChatViewController.h"

@interface MineConversationListViewController ()
@property (strong, nonatomic)  UIButton *backBtn;
@property (strong, nonatomic)  UILabel *titleLab;

@property (strong, nonatomic)  UIView *bgView;
@end

@implementation MineConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
     NSString *rong_token = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"rong_token"];
//                连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:rong_token     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);

    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
    }];
    
    
    
    [self configNavView];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        ]];

    if (self.conversationListDataSource.count == 0) {
        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    self.emptyConversationView = [LYEmptyView emptyViewWithImageStr:@"暂时没有消息"
                                                           titleStr:@""
                                                          detailStr:@""];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.conversationListTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight - SafeAreaHeight);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toRefesh:) name:@"RefrshChatList" object:nil];
}

- (void)configNavView {
    _bgView = [[UIView alloc]init];
    [self.view addSubview:_bgView];
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _backBtn = [[UIButton alloc]init];
    [self.bgView addSubview:_backBtn];
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-Space);
    }];
    
    _titleLab = [[UILabel alloc]init];
    [self.bgView addSubview:_titleLab];
    _titleLab.text = @"我的消息";
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:18];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    
    //聊天界面的聊天类型
    conversationVC.conversationType = model.conversationType;
    //需要打开和谁聊天的会话界面,和谁聊天其实是通过TargetId来联系的。
    conversationVC.targetId = model.targetId;
    conversationVC.conversationTitle = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
   
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:UNREAD];
}


- (void)toRefesh:(NSNotification *)info{
    [self refreshConversationTableViewIfNeeded];
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
