//
//  AuthorSearchResultViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/12.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorSearchResultViewController.h"

#import "HWDownSelectedView.h"
#import "ALLAuthorsTableViewCell.h"
#import "AuthorDetailViewController.h"
#import "SPPageMenu.h"
#import "GoodsDetailViewController.h"
#import "BaseViewController.h"

@interface AuthorSearchResultViewController ()<UITextFieldDelegate,SPPageMenuDelegate, UIScrollViewDelegate,AllSearchResultDelegate>
{
    NSUInteger page;
    NSMutableArray *_dataAry;
    NSString *tag_id;
    NSString *grade;
    NSString *intelligent;
    NSString *type;
    NSString *dump_id;
    NSString *cut_id;
}


@property (nonatomic, strong) YMRefresh *ymRefresh;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *textBg;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (strong, nonatomic)  HWDownSelectedView *down2;
@property (strong, nonatomic)  HWDownSelectedView *down3;
@property (strong, nonatomic)  HWDownSelectedView *down4;

@property (strong, nonatomic)  NSMutableDictionary *footerState;

@property (copy, nonatomic)  NSMutableArray *nearbyAry;
@property (copy, nonatomic)  NSMutableArray *intelligentAry;
@property (copy, nonatomic)  NSMutableArray *gradeAry;
@property (copy, nonatomic)  NSMutableArray *filtrateAry;

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation AuthorSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    page = 1;
    _dataAry = [NSMutableArray array];
    _myChildViewControllers = [NSMutableArray array];
    _nearbyAry = [NSMutableArray array];
    _gradeAry = [NSMutableArray array];
    _intelligentAry = [NSMutableArray array];
    _filtrateAry = [NSMutableArray array];
    
    _footerState = [NSMutableDictionary dictionary];
    grade = @"";
    intelligent = @"";
    cut_id = @"";
    dump_id = @"";
    tag_id = @"";
    
    [self configUI];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaHeight+44, kWidth, kHeight-SafeAreaHeight-44-SafeAreaBottomHeight)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
   
    
    NSArray *controllerClassNames = [NSArray arrayWithObjects:@"AllSearchResultViewController",@"ServiceResultViewController",@"WorkResultsViewController",@"ShopResultsViewController",@"AuthorResultsViewController", nil];
    
    for (int i = 0; i < controllerClassNames.count; i++) {
    
            BaseViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            
            baseVc.content = self.content;
            baseVc.grade = grade;
            baseVc.tag_id = tag_id;
            baseVc.dump_id = dump_id;
            baseVc.cut_id = cut_id;
//            baseVc.type = [NSString stringWithFormat:@"%d",i];
            baseVc.intelligent = intelligent;
        
        if (i == 0) {
            baseVc.delegate = self;
        }
//        baseVc.view.frame = CGRectMake(kWidth*i, 0, kWidth, scrollView.frame.size.height);
//        [self.scrollView addSubview:baseVc.view];
        
        [self addChildViewController:baseVc];
      [self.myChildViewControllers addObject:baseVc];
        
    }
    
   
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        BaseViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(kWidth*self.pageMenu.selectedItemIndex, 0, kWidth, kHeight-SafeAreaHeight-44-SafeAreaBottomHeight);
        scrollView.contentOffset = CGPointMake(kWidth*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.dataArr.count*kWidth, 0);
    }
    
    
}

#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(kWidth * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(kWidth * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}

    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;

    targetViewController.view.frame = CGRectMake(kWidth * toIndex, 0, kWidth, kHeight-SafeAreaHeight-44-SafeAreaBottomHeight);
    [_scrollView addSubview:targetViewController.view];
    
}




- (void)configUI{
    _titleView.frame = CGRectMake(0, 0, kWidth, 88+SafeAreaTopHeight);
    
    [_textBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2 - 40);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(self.titleView.mas_left).offset(40);
        make.top.mas_equalTo(self.titleView.mas_top).offset(SafeAreaTopHeight);
    }];
    _textBg.layer.cornerRadius = 18;
    _textBg.layer.masksToBounds = NO;
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.textBg.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.textBg.mas_centerY).offset(0);
    }];
    
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.searchBtn.mas_right).offset(Space);
        make.centerY.mas_equalTo(self.textBg.mas_centerY).offset(0);
    }];
    
    _searchTF.delegate = self;
    _searchTF.text = self.content;
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.textBg.mas_centerY).offset(0);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.textBg.mas_bottom).offset(10);
    }];

    self.dataArr = @[@"综合",@"服务",@"作品",@"名店",@"名师"];
    
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaHeight, kWidth, 44) trackerStyle:SPPageMenuTrackerStyleLine];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.dataArr selectedItemIndex:0];
    pageMenu.needTextColorGradients = NO;
    
    // 设置代理
    pageMenu.delegate = self;
    [self.titleView addSubview:pageMenu];
    _pageMenu = pageMenu;
    

    
}

- (void)didClickMoreIndex:(NSInteger)index
{
    if (index == 0 ) {
        [self.scrollView setContentOffset:CGPointMake(kWidth , 0) animated:YES];
    }
    
    if (index == 1 ) {
        [self.scrollView setContentOffset:CGPointMake(kWidth*2 , 0) animated:YES];
    }
    
    if (index == 2 ) {
        [self.scrollView setContentOffset:CGPointMake(kWidth*3 , 0) animated:YES];
    }
    
    if (index == 3 ) {
        [self.scrollView setContentOffset:CGPointMake(kWidth*4 , 0) animated:YES];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)popAction:(UIButton *)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
