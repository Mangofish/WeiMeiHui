//
//  ALLCommentViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ALLCommentViewController.h"
#import "CommentOrderTableViewCell.h"

@interface ALLCommentViewController () <UITableViewDelegate,UITableViewDataSource>{
    
    NSString *typekey;
    NSMutableDictionary *_commentHeightDic;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *redLine;

@property (weak, nonatomic) IBOutlet UIView *selectBgView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;

@property (weak, nonatomic) IBOutlet UIButton *picBrn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
@property (strong, nonatomic) NSMutableArray *dataAry;

@property (copy, nonatomic) NSDictionary *dataDic;
@end

@implementation ALLCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _commentHeightDic = [NSMutableDictionary dictionary];
    typekey = @"all_list";
    
    [self customUI];
    [self getData];
    
}

-(void)customUI{
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+44+1, kWidth, kHeight-SafeAreaHeight-44);
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    _selectBgView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, 44);
   
    
    _allBtn.frame = CGRectMake(0, 0, kWidth/4, 44);
    _picBrn.frame = CGRectMake(kWidth/4, 0, kWidth/4, 44);
    _goodBtn.frame = CGRectMake(kWidth/2, 0, kWidth/4, 44);
    _badBtn.frame = CGRectMake(3*kWidth/4, 0, kWidth/4, 44);
     _redLine.center = CGPointMake(_allBtn.center.x, 44);
//    _redLine.center = CGPointMake(_allBtn.center.x, _redLine.center.y);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(40));
        make.width.equalTo(@(40));
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
        make.height.equalTo(@(20));
        make.width.equalTo(@(kWidth-Space*2));
    }];
    
    
    
}
- (IBAction)allAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.redLine.center = CGPointMake(sender.center.x, 44);
    }];
    
    if (sender.tag == 0) {
        sender.selected = YES;
        _picBrn.selected = NO;
        _goodBtn.selected = NO;
        _badBtn.selected = NO;
        self.dataAry = [self.dataDic objectForKey:@"all_list"];
        
    }
    
    if (sender.tag == 1) {
        
        sender.selected = YES;
        _allBtn.selected = NO;
        _goodBtn.selected = NO;
        _badBtn.selected = NO;
        
        self.dataAry = [self.dataDic objectForKey:@"pic_list"];
        
    }
    
    if (sender.tag == 2) {
        sender.selected = YES;
        _picBrn.selected = NO;
        _allBtn.selected = NO;
        _badBtn.selected = NO;
        self.dataAry = [self.dataDic objectForKey:@"favorable_list"];
        
    }
    
    if (sender.tag == 3) {
        sender.selected = YES;
        _picBrn.selected = NO;
        _goodBtn.selected = NO;
        _allBtn.selected = NO;
        self.dataAry = [self.dataDic objectForKey:@"bad_list"];
        
    }
    
    
    [self.mainTableView reloadData];
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getData{
    
//    //网络请求
//    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
//    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
//    NSString *uuid = @"";
//    if ([PublicMethods isLogIn]) {
//        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
//    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":self.uuid,@"type":self.type}];
    
    [YYNet POST:ALLCom paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        self.dataDic = dict[@"data"];
        self.dataAry = [self.dataDic objectForKey:self->typekey];
        
        NSString *str1 = [NSString stringWithFormat:@"全部(%lu)",self.dataAry.count];

        NSString *str2 = [NSString stringWithFormat:@"有图(%lu)",((NSArray *)self.dataDic[@"pic_list"]).count];
        NSString *str3 = [NSString stringWithFormat:@"好评(%lu)",((NSArray *)self.dataDic[@"favorable_list"]).count];
        NSString *str4 = [NSString stringWithFormat:@"差评(%lu)",((NSArray *)self.dataDic[@"bad_list"]).count];
        
        [self.allBtn setTitle:str1 forState:UIControlStateSelected];
         [self.picBrn setTitle:str2 forState:UIControlStateSelected];
         [self.goodBtn setTitle:str3 forState:UIControlStateSelected];
         [self.badBtn setTitle:str4 forState:UIControlStateSelected];
        
        [self.allBtn setTitle:str1 forState:UIControlStateNormal];
        [self.picBrn setTitle:str2 forState:UIControlStateNormal];
        [self.goodBtn setTitle:str3 forState:UIControlStateNormal];
        [self.badBtn setTitle:str4 forState:UIControlStateNormal];
      
        [self.mainTableView reloadData];
        
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataAry.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentOrderTableViewCell *cell = [CommentOrderTableViewCell commentOrderTableViewCell];
    cell.comment = [OrderComment orderCommentWithDict:self.dataAry[indexPath.row]];
    _commentHeightDic[@(indexPath.row)] = @(cell.cellHeight);
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_commentHeightDic[@(indexPath.row)] doubleValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}



@end
