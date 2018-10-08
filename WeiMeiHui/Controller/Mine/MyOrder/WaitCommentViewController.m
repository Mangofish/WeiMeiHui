//
//  WaitCommentViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WaitCommentViewController.h"
#import "UITextView+Placeholder.h"
#import "MainOrderStatusAlready.h"
#import "UIButton+WebCache.h"
#import "XHStarRateView.h"
#import "GBTagListView.h"
#import "ZYLineProgressView.h"

@interface WaitCommentViewController ()<XHStarRateViewDelegate>{
    
    MainOrderStatusAlready *orderAlready;
    XHStarRateView *starRateView;
    NSArray *tagAry;
    NSMutableArray *finalTag;
    
//    参数
    NSUInteger eva_starts;
    NSString *tagId;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

//订单
@property (weak, nonatomic) IBOutlet UIView *orderbg;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UIView *authorBg;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *nickBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *shopName;

//评价
@property (weak, nonatomic) IBOutlet UIView *commentBg;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (weak, nonatomic) IBOutlet UILabel *titlel;

@property (weak, nonatomic) IBOutlet UILabel *tagLab;

@property (strong, nonatomic)  GBTagListView *bubbleView;
@end

@implementation WaitCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    finalTag = [NSMutableArray array];
    tagId = @"";
    [self configNavView];
    [self getData];
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    
    
}

-(void)locationUI{
    
    _orderbg.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, 44);
    _orderNum.frame = CGRectMake(Space, 0, kWidth-Space*2, 44);
    _orderNum.text = [NSString stringWithFormat:@"订单编号：%@",orderAlready.order_number];
    _authorBg.frame = CGRectMake(0, CGRectGetMaxY(_orderbg.frame)+1, kWidth, 88);
   
    
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.height.width.mas_equalTo(68);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self->_authorBg.mas_top).offset(Space);
    
    }];
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:orderAlready.image] forState:UIControlStateNormal];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.iconBtn.mas_right).offset(Space);
        make.top.mas_equalTo(self.iconBtn.mas_top).offset(5);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(self->orderAlready.nameWidth));
    }];
    _nameLab.text = orderAlready.nickname;
    
    [_nickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.nameLab.mas_right).offset(Space);
        make.top.mas_equalTo(self.iconBtn.mas_top).offset(5);
        
    }];
    
//    判断级别
    
    
    [_orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.iconBtn.mas_right).offset(Space);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(self->orderAlready.countWidth));
        
    }];
    _orderCount.text = [NSString stringWithFormat:@"%@",orderAlready.order_num];
    
    ZYLineProgressView *progressView = [[ZYLineProgressView alloc] init];
    
//    progressView.score.text =
    [progressView updateConfig:^(ZYLineProgressViewConfig *config) {
        config.isShowDot = NO;
    }];
    progressView.progressText = [NSString stringWithFormat:@"%@分",orderAlready.score];
    [self.authorBg addSubview:progressView];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.orderCount.mas_right).offset(0);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(12));
        make.width.mas_equalTo(@(100));
        
    }];
    
    progressView.progress = [orderAlready.score integerValue]/100.0;
    
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.iconBtn.mas_right).offset(5);
        make.top.mas_equalTo(self.orderCount.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(kWidth/2));
        
    }];
    
    _shopName.text = orderAlready.shop_name;
    
    starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(kWidth/3, 12, kWidth/3, 20)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = HalfStar;
    starRateView.currentScore = 5;
    [self.commentBg addSubview:starRateView];
    
    
    [_titlel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self->starRateView.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(kWidth));
        
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.titlel.mas_bottom).offset(15);
        make.height.mas_equalTo(@(1));
        make.width.mas_equalTo(@(kWidth));
        
    }];
    
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(kWidth));
        
    }];
    
    [self.commentBg addSubview:self.bubbleView];
    
    [self.bubbleView setTagWithTagArray:finalTag];
//    _bubbleView.frame = CGRectMake(0, 118, kWidth, self.bubbleView.finalHeight);
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.bubbleView.mas_bottom).offset(15);
        make.height.mas_equalTo(@(1));
        make.width.mas_equalTo(@(kWidth));
        
    }];
    
    [_contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(self.line2.mas_bottom).offset(Space);
        make.height.equalTo(@(80));
        make.width.equalTo(@(kWidth-Space*2));
        
    }];
    
    [ZZLimitInputManager limitInputView:self.contentTF maxLength:120];
    self.contentTF.placeholder = @"请输入要评价的内容";
    [self addToolTab];
    _commentBg.frame = CGRectMake(0, CGRectGetMaxY(_authorBg.frame)+Space, kWidth, CGRectGetMaxY(_bubbleView.frame)+Space*2+100);
    
}

- (void)addToolTab{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    //        [topView setBarStyle:UIBarStyleBlackTranslucent];//设置增加控件的基本样式，UIBarStyleDefault为默认样式。
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(doneWithIt) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"确定" forState:(UIControlStateNormal)];
    btn.backgroundColor = MainColor;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [self.contentTF setInputAccessoryView:topView];
    
}

- (void)doneWithIt{
    [self.view endEditing:YES];
    
    
}

- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 118, kWidth, 0)];
        /**允许点击 */
        _bubbleView.canTouch=YES;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=NO;
        _bubbleView.canTouchNum = 3;
        _bubbleView.signalTagColor=MJRefreshColor(242, 242, 242);
        
        __block NSArray *fina = finalTag;
        __block NSArray *tag = tagAry;
        _bubbleView.didselectItemBlock = ^(NSArray *arr) {

            NSMutableString *temp = [NSMutableString string];
            for (int i=0; i<arr.count ; i++) {

                NSString *obj = arr[i];
                NSUInteger index = [fina indexOfObject:obj];
                NSString *ids = [tag[index] objectForKey:@"id"];
                [temp appendString:ids];

                if (i == arr.count-1) {

                }else{
                    [temp appendString:@","];
                }

            }

            self->tagId = temp;
            self->_tagLab.text = [NSString stringWithFormat:@"选择标签：（%lu/3）",(unsigned long)arr.count];
        };
        
    }
    
    return _bubbleView;
    
}

- (IBAction)sendComment:(UIButton *)sender {
    [self sendData];
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark - 联系客服
- (IBAction)serviceConnect:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",orderAlready.service_tel]]]];
    [self.view addSubview:callWebview];
    
    
}



- (void)getData{
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":_ID}];
    
    [YYNet POST:WaitComments paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        self->orderAlready = [MainOrderStatusAlready mainOrderStatusWithDict:dict[@"data"]];
        self->tagAry = [dict[@"data"] objectForKey:@"service_tag"];
        
        for (NSDictionary *obj in self->tagAry) {
            [self->finalTag addObject:obj[@"name_num"]];
        }
        
        [self locationUI];
        
    } faild:^(id responseObject) {
        
        
        
    }];
}

- (void)sendData{
    
    NSString *uuid= [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"eva_starts":@(starRateView.currentScore),@"order_id":_ID,@"tag_id":tagId,@"content":_contentTF.text}];
    
    [YYNet POST:SendOrderComments paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        if ([dict[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"评价成功！" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
}

- (void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore {
    
}



@end
