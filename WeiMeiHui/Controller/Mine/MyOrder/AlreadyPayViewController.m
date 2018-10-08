//
//  AlreadyPayViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AlreadyPayViewController.h"
#import "NormalContentLabel.h"
#import "TYTextContainer.h"
#import "AlertView.h"
#import "MainOrderStatusAlready.h"
#import "UIButton+WebCache.h"
#import "ZYLineProgressView.h"
#import "AuthorWorkCollectionViewCell.h"
#import "AuthorDetailViewController.h"
#import "ChatViewController.h"
#import "LHPhotoBrowser.h"

@interface AlreadyPayViewController ()<AlertViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    NormalContentLabel *_contentAttributedLabel;//自身内容
    TYTextContainer * textContainer;
    double contentHeight;
    AlertView *alert;
    UIView *bgTapView;
    MainOrderStatusAlready *orderAlready;
    NSDictionary *dataDic;
    NSArray *imgData;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UIView *erBg;
@property (weak, nonatomic) IBOutlet UIImageView *erImg;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *inforLab;

@property (weak, nonatomic) IBOutlet UIView *orderNumBg;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UIView *introBg;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;


@property (weak, nonatomic) IBOutlet UIView *authorBg;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *nickBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@property (strong, nonatomic)  UICollectionView *imgCollectionView;

@end

@implementation AlreadyPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    [self getData];
    if (_titleStr.length) {
        _titleLab.text = _titleStr;
    }
    
    if (_infoStr.length) {
        self.inforLab.text = _infoStr;
    }
    
    if (self.btnStatus == 9 || self.btnStatus == 16) {
        self.cancelBtn.hidden = YES;
    }
    
    if (self.btnStatus == 10) {
        [self.cancelBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tabBarController.tabBar.hidden = YES;
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

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData{
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":_orderID}];
    
    [YYNet POST:MyPayOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        self->dataDic = dict[@"data"];
        self->orderAlready = [MainOrderStatusAlready mainOrderStatusWithDict:self->dataDic[@"author_data"]];
        self->imgData = self->dataDic[@"custom_pic"];
       
        self->_tagLab.text = [NSString stringWithFormat:@"%@",self->dataDic[@"service_type"]];
        self->_orderNum.text = [NSString stringWithFormat:@"订单编号：%@",self->dataDic[@"order_number"]];
        [self calculateHegihtAndAttributedString:self->dataDic[@"content"]];
        [self changeFrame];
        
        
    } faild:^(id responseObject) {
        
        
    }];
}


- (void)changeFrame{
    
    _orderNumBg.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, 44);
    _orderNum.frame = CGRectMake(Space, 0, kWidth-Space*2, 44);
    _statusLab.frame = CGRectMake(kWidth-Space-kWidth/2, 0, kWidth/2, 44);
    if (_statustr.length) {
        _statusLab.text = _statustr;
    }
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.introBg.mas_top).offset(Space*2);
    }];
    
    if (imgData.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        CGFloat itemW = (kWidth - Space*4)/4;
        
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumInteritemSpacing = 5;
        
        if (imgData.count>4) {
             self.imgCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(Space, 55, kWidth-Space*2, itemW*2+Space) collectionViewLayout:layout];
            _introBg.frame = CGRectMake(0, 45+SafeAreaHeight+Space, kWidth, 80+contentHeight+itemW*2+20);
        }else{
             self.imgCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(Space, 55, kWidth-Space*2, itemW) collectionViewLayout:layout];
            _introBg.frame = CGRectMake(0, 45+SafeAreaHeight+Space, kWidth, 80+contentHeight+itemW);
        }
        
        [self.introBg addSubview:self.imgCollectionView];
        self.imgCollectionView.delegate = self;
        self.imgCollectionView.dataSource = self;
        self.imgCollectionView.backgroundColor = [UIColor whiteColor];
        [self.imgCollectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.imgCollectionView.scrollEnabled = NO;
        
    }else{
        _introBg.frame = CGRectMake(0, 45+SafeAreaHeight+Space, kWidth, 80+contentHeight);
    }
    
    _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(self.imgCollectionView.frame)+Space, kWidth-Space*2, contentHeight)];
    
    _contentAttributedLabel.text = dataDic[@"content"];
    
    [self.introBg addSubview:_contentAttributedLabel];
    
    
//    二维码
    _erBg.frame = CGRectMake(0, CGRectGetMaxY(_introBg.frame)+1, kWidth, 204);
    [_erImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.top.mas_equalTo(self.erBg.mas_top).offset(30);
    }];
    
    [_erImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:dataDic[@"goodsCode"]]];
    
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(14);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.top.mas_equalTo(self.erImg.mas_bottom).offset(6);
    }];
    
    _numberLab.text = [NSString stringWithFormat:@"%@",dataDic[@"code"]];
    
    [_inforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(14);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.bottom.mas_equalTo(self.erBg.mas_bottom).offset(-30);
    }];
   
    _authorBg.frame = CGRectMake(0, CGRectGetMaxY(_erBg.frame)+Space, kWidth, 88);
    
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
        make.left.mas_equalTo(self.nameLab.mas_right).offset(5);
        make.top.mas_equalTo(self.iconBtn.mas_top).offset(5);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(60));
    }];
    
    
    [_orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.iconBtn.mas_right).offset(Space);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(self->orderAlready.countWidth));
        
    }];
    _orderCount.text = [NSString stringWithFormat:@"%@",orderAlready.order_num];
    
    ZYLineProgressView *progressView = [[ZYLineProgressView alloc] init];
    
    [progressView updateConfig:^(ZYLineProgressViewConfig *config) {
        config.isShowDot = NO;
    }];
    
    [self.authorBg addSubview:progressView];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.orderCount.mas_right).offset(0);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(12));
        make.width.mas_equalTo(@(100));
        
    }];
    
    progressView.progressText = orderAlready.score;
    progressView.progress = [orderAlready.score integerValue]/100.0;
    
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.iconBtn.mas_right).offset(5);
        make.top.mas_equalTo(self.orderCount.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(kWidth/2));
        
    }];
    
    _shopName.text = orderAlready.shop_name;
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.top.mas_equalTo(self.nameLab.mas_top).offset(0);
    }];
    _priceLab.text = [NSString stringWithFormat: @"%@",orderAlready.price];;
    
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.bottom.mas_equalTo(self.shopName.mas_bottom).offset(0);
    }];
    
}

- (IBAction)cancelOrderAction:(UIButton *)sender {
    
    bgTapView = [[UIView alloc]initWithFrame:self.view.bounds];
    bgTapView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:bgTapView];
    
    AlertView *alertView = [AlertView alertViewWithFrame:CGRectMake(Space, kHeight-131-20, kWidth-Space*2, 131)];
    alertView.delegate = self;
    alert = alertView;
    [self.view addSubview:alertView];
    
}



- (void)didClickMenuIndex:(NSInteger)index{
    
    
    if (index == 1 && bgTapView.tag == 100 ) {
//        退款
        [self payback];
    }else if(index == 1){
        //          取消订单
        [self cancelNet];
    }
    
    //          移除
    [UIView animateWithDuration:0.3 animations:^{
        self->alert.frame  =  CGRectMake(Space, kHeight, kWidth-Space*2, 131);
        self->bgTapView.hidden  = YES;
    }completion:^(BOOL finished) {
        [self->bgTapView removeFromSuperview];
        [self->alert removeFromSuperview];
    }];
    
    
}

- (void)cancelNet{
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"custom_id":_ID,@"type":@"2"}];
    
    [YYNet POST:CancelOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        if ([dict[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已取消！" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } faild:^(id responseObject) {
        
        
        
    }];
}

#pragma 计算高度
-(void)calculateHegihtAndAttributedString:(NSString *)content
{
    textContainer = [[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=6;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:14];
    textContainer.text = content;
    textContainer.textColor = MJRefreshColor(51, 51, 51);
    
    textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
    contentHeight = textContainer.textHeight;
    
    if (textContainer.textHeight > 46) {
        contentHeight = 46;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return imgData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthorWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.workImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:imgData[indexPath.item]]];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return imgData.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthorWorkCollectionViewCell *cell = (AuthorWorkCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
    
    bc.imgsArray = @[cell.workImg];
    bc.imgUrlsArray = @[ imgData[indexPath.item] ];
    bc.tapImgIndex = 0;
    bc.hideStatusBar = NO;
    [bc show];
    
}


- (IBAction)messageAction:(UIButton *)sender {
    
    ChatViewController *chatvc = [[ChatViewController alloc]init];
    chatvc.targetId = orderAlready.author_uuid;
    chatvc.conversationTitle = orderAlready.nickname;
    chatvc.conversationType = ConversationType_PRIVATE;
    [self.navigationController pushViewController:chatvc animated:YES];
    
}

#pragma mark - 申请退款
- (IBAction)applyForMoney:(UIButton *)sender {
    
    if (self.btnStatus == 10) {
        
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",dataDic[@"Service_tel"]]]]];
        [self.view addSubview:callWebview];
        
        return;
    }
    
    if (!_orderID.length) {
        return;
    }
    
    bgTapView = [[UIView alloc]initWithFrame:self.view.bounds];
    bgTapView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    bgTapView.tag = 100;
    [self.view addSubview:bgTapView];
    
    CGSize size = CGSizeMake(100, MAXFLOAT);
    //设置高度宽度的最大限度
    CGRect rect = [@"平台客服会在24小时内与店家沟通进行退款，申请成功后款项将原路退回，是否确认退款？" boundingRectWithSize:size options: NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
    
    AlertView *alertView = [AlertView alertViewWithFrame:CGRectMake(Space, kHeight-rect.size.height-20, kWidth-Space*2, rect.size.height)];
    alertView.delegate = self;
    alert = alertView;
//    alert.titleLab.frame = CGRectMake(Space, Space, kWidth-Space*2, rect.size.height);
    alert.titleLab.text = @"平台客服会在24小时内与店家沟通进行退款，申请成功后款项将原路退回，是否确认退款？";
    [self.view addSubview:alertView];
    
    
}

- (void)payback{
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_id":_orderID}];
    
    [YYNet POST:UserApply paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        if ([dict[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (IBAction)chooseIconAction:(UIButton *)sender {
    
    AuthorDetailViewController *detailVC = [[AuthorDetailViewController alloc]init];
    detailVC.ID = orderAlready.author_uuid;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
