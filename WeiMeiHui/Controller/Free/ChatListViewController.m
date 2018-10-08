//
//  ChatListViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"

@interface ChatListViewController ()


@property (strong, nonatomic)  UILabel *titleLab;
@property (strong, nonatomic)  UIView *bgView;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
  
    
    [self configNavView];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        ]];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.conversationListTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight - SafeAreaHeight-44);
    
    if (self.conversationListDataSource.count == 0) {
        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
            self.emptyConversationView = [LYEmptyView emptyViewWithImageStr:@"暂时没有消息"
                                                                        titleStr:@""
                                                                       detailStr:@""];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toRefesh:) name:@"RefrshChatList" object:nil];
    
//    self.conversationListTableView.backgroundView
}



- (void)toRefesh:(NSNotification *)info{
    [self refreshConversationTableViewIfNeeded];
}

- (void)configNavView {
    _bgView = [[UIView alloc]init];
    [self.view addSubview:_bgView];
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    _bgView.backgroundColor = [UIColor whiteColor];
    
    
    _titleLab = [[UILabel alloc]init];
    [self.bgView addSubview:_titleLab];
    _titleLab.text = @"消息";
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:18];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-Space);
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
    
    //    取消红点
    [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar  hideBadgeOnItemIndex:1];
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self refreshConversationTableViewIfNeeded];
    
    NSString *rong_token = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"rong_token"];
    //            连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:rong_token     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
    }];
    

    
}




@end
