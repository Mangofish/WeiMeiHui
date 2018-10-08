//
//  ChatViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChatViewController.h"


@interface ChatViewController ()

@property (strong, nonatomic)  UIButton *backBtn;
@property (strong, nonatomic)  UILabel *titleLab;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.conversationType =  ConversationType_PRIVATE;
   
    self.conversationMessageCollectionView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self customUI];
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    RCUserInfo *_currentUserInfo = [[RCUserInfo alloc] initWithUserId:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"] name:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"nickname"] portrait:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"image"]];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    
}

- (void)customUI{
    
    _backBtn = [[UIButton alloc]init];
    [self.view addSubview:_backBtn];
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
    }];
    
    _titleLab = [[UILabel alloc]init];
    [self.view addSubview:_titleLab];
    _titleLab.text = _conversationTitle;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.textColor = FontColor;
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
 
//    [self gethita];
    
}

- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}


/*
此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{

    
    //创建一个NSURL：请求路径
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":userId}];
    
    
    [YYNet POST:UserRCloud paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.name = [dic[@"data"] objectForKey:@"nickname"];
        user.portraitUri = [dic[@"data"] objectForKey:@"image"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefrshChatList" object:nil];
        
        return completion(user);
        
    } faild:^(id responseObject) {
        
    }];
    
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self refreshConversationTableViewIfNeeded];
    
    NSString *rong_token = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"rong_token"];
    //            连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:rong_token     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
    }];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:UNREAD];
    
    //    取消红点
    [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar  hideBadgeOnItemIndex:1];
    //    取消红点
    [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar  hideBadgeOnItemIndex:4];
    
}






@end
