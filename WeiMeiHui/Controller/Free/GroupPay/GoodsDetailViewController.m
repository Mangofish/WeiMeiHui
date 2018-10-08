//
//  GoodsDetailViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsGroupTableViewCell.h"
#import "GoodsTitleTableViewCell.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "PackageTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "GroupPayViewController.h"
#import "GoodsPaySingleViewController.h"
#import "WeiJoinGroupViewController.h"
#import "BaseAlertController.h"
#import "ReportViewController.h"
#import "AuthorDetailHead.h"
#import "LWShareService.h"
#import "ShareService.h"
#import "NextFreeNewViewController.h"
#import "CommentOrderTableViewCell.h"
#import "FamousGoodsTableViewCell.h"
#import "SearchFooterTableViewCell.h"
#import "ALLCommentViewController.h"
#import "SecondKillsOrderViewController.h"
#import "AuthorDetailViewController.h"

@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,GoodsGroupTableViewCellDelegate,SearchFooterDelegate>

@property (nonatomic, assign) CFAbsoluteTime start;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *groupPayBtn;

@property (copy, nonatomic)  NSArray *dataAry;
@property (assign, nonatomic)  NSUInteger page;
@property (strong, nonatomic)  NSMutableDictionary *heightDic;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (weak, nonatomic) IBOutlet UILabel *groupText;
@property (weak, nonatomic) IBOutlet UILabel *groupTitle;
@property (strong, nonatomic) NSMutableDictionary *commentHeightDic;
@property (strong, nonatomic)  AuthorDetailHead *head ;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic)  GoodsDetail *goodsDetail;
@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentHeightDic = [NSMutableDictionary dictionary];
    self.heightDic = [NSMutableDictionary dictionary];
//    self.sessionID = @"";
    [self customUI];
//    [self getData];
}

-(void)customUI{
    
    self.tabBarController.tabBar.hidden = YES;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        page = 1;
        [self getData];
    }];
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
        make.height.equalTo(@(20));
        make.width.equalTo(@(kWidth-Space*2));
    }];
    
    self.page = 1;
    
    if (self.isGroup == 1) {
        
        self.groupBtn.hidden = NO;
        self.groupText.hidden = NO;
        self.priceLab.hidden = NO;
        
    }else{
        
        self.groupBtn.hidden = YES;
        self.groupText.hidden = YES;
        self.priceLab.hidden = YES;
        
    }
  
    
//    [_mainTableView.mj_header beginRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 20 ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView.backgroundColor = [UIColor whiteColor];
            [self.backBtn setImage:[UIImage imageNamed:@"返回新"] forState:(UIControlStateNormal)];
            [self.shareBtn setImage:[UIImage imageNamed:@"分享"] forState:(UIControlStateNormal)];
            self.titleLab.hidden = NO;
        }];
    }
    
    if (scrollView.contentOffset.y <= 0 ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView.backgroundColor = [UIColor clearColor];
            [self.backBtn setImage:[UIImage imageNamed:@"返回白"] forState:(UIControlStateNormal)];
            [self.shareBtn setImage:[UIImage imageNamed:@"分享白"] forState:(UIControlStateNormal)];
            self.titleLab.hidden = YES;
        }];
    }
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(UIButton *)sender {
    
    
    NSString *url = [NSString stringWithFormat:@"%@",self.goodsDetail.share_url];
    
    NSString *title = self.goodsDetail.shareTitle;
    NSString *pic = self.goodsDetail.sharePic;
    NSString *content = self.goodsDetail.shareContent;
    
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

                    ReportViewController *reportVC = [[ReportViewController alloc] init];
                    reportVC.ID = self->_ID;
                    [self.navigationController pushViewController:reportVC animated:YES];

                }
                    break;
                default:
                    break;
            }


            [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
            



        }else{
            LoginViewController *log = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:log animated:YES];
        }

    };
    [[LWShareService shared] showInViewControllerTwo:self];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 8;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 && [self.goodsDetail.is_activity integerValue] == 1) {
        
        if (self.goodsDetail.coupon_list.count) {
            return 4;
        }
        
        return 3;
        
    }else if (section == 0 && self.goodsDetail.coupon_list.count){
        
        return 3;
        
    }else if(section == 0 && !self.goodsDetail.coupon_list.count){
        
        return 2;
        
    }
    
    if (section == 1) {
        
        if ([_goodsDetail.is_group integerValue] == 2 && !_goodsDetail.recent_order.count && !_goodsDetail.recent_in.count) {
            return 0;
            
        }else{
            
            if ([_goodsDetail.is_group integerValue] == 1 && _goodsDetail.recent_order.count && _goodsDetail.recent_in.count) {
                return 2;
            }
            
            if ([_goodsDetail.is_group integerValue] == 1 && _goodsDetail.recent_in.count) {
                return 1;
            }
            
            if ([_goodsDetail.is_group integerValue] == 1 && _goodsDetail.recent_order.count) {
                return 1;
            }
            
            return 0;
            
        }
    
    }
    
    if (section == 2) {
        
        if ([_goodsDetail.is_group integerValue] == 1) {
            return 2;
        }
    
        return 0;
    }
    
    if (section == 3) {
        
        if (_goodsDetail.grade.length == 0) {
            return 0;
        }
        
        return 1;
    }
    
//    评价
    if (section == 4) {
        
        return self.goodsDetail.evaluate_list.count;
    }
    
    if (section == 5) {
        
        if (self.goodsDetail) {
            return self.goodsDetail.goods_detail_list.count;
        }else{
            
            return 0;
            
        }
        
    }
    
   
    
    if (section == 6) {
        
        if (self.goodsDetail.need_know.count) {
            return self.goodsDetail.need_know.count;
            
        }else{
            
            return 0;
            
        }
        
    }
    
    if (section == 7) {
        
        if (self.goodsDetail) {
            return self.goodsDetail.other_goods_list.count;
        }else{
            return 0;
        }
        
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    头部
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0) {
            
            GoodsTitleTableViewCell *cell = nil;
            
            if ([self.goodsDetail.is_group integerValue] == 3) {
                
                cell = [GoodsTitleTableViewCell goodsTitleTableViewCellKill];
                
            }else{
                
                cell = [GoodsTitleTableViewCell goodsTitleTableViewCell];
                
            }
            
            if (self.goodsDetail) {
                cell.goodsDetail = _goodsDetail;
            }
            
            return cell;
            
        }
        
            
            if ([self.goodsDetail.is_activity integerValue] == 1) {
                
                if (indexPath.row == 1) {
                    //            活动
                    GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOne];
                    if (self.goodsDetail) {
                        cell.goodsDetail = _goodsDetail;
                    }
                    return cell;
                }
                
                //        随便退
                if (indexPath.row == 2) {
                    
                    GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                    return cell;
                    
                }
                
                //        优惠券
                if (indexPath.row == 3) {
                    
                    GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellTwo];
                    if (self.goodsDetail) {
                        cell.goodsDetail = _goodsDetail;
                    }
                    return cell;
                    
                }
                
                
            }else{
                
                //        随便退
                if (indexPath.row == 1) {
                    
                    GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                    return cell;
                    
                }
                
                //        优惠券
                if (indexPath.row == 2) {
                    
                    GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellTwo];
                    if (self.goodsDetail) {
                        cell.goodsDetail = _goodsDetail;
                    }
                    return cell;
                    
                }
                
            }
            

    }

    
//    参团
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if (self.goodsDetail.recent_in.count) {
                GoodsGroupTableViewCell *cell = [GoodsGroupTableViewCell goodsGroupTableViewCellPink];
                if (self.goodsDetail) {
                    cell.goodsDetail = _goodsDetail;
                }
                return cell;
            }
            
            if (self.goodsDetail.recent_order.count) {
                
                GoodsGroupTableViewCell *cell = [GoodsGroupTableViewCell goodsGroupTableViewCellYellow];
                if (self.goodsDetail) {
                    cell.goodsDetail = _goodsDetail;
                }
                cell.order = [RecentOrder recentOrderWithDict:self.goodsDetail.recent_order];
                
                NSInteger rest = [self.goodsDetail.recent_order[@"end_time"] integerValue];
                //        NSInteger second = rest - round(CFAbsoluteTimeGetCurrent()-_start);
                [cell setConfigWithSecond:rest];
                cell.delegate = self;
                return cell;
                
            }
            
        }else{
            
            GoodsGroupTableViewCell *cell = [GoodsGroupTableViewCell goodsGroupTableViewCellYellow];
            if (self.goodsDetail) {
                cell.goodsDetail = _goodsDetail;
            }
            cell.order = [RecentOrder recentOrderWithDict:self.goodsDetail.recent_order];
            
            NSInteger rest = [self.goodsDetail.recent_order[@"end_time"] integerValue];
            //        NSInteger second = rest - round(CFAbsoluteTimeGetCurrent()-_start);
            [cell setConfigWithSecond:rest];
            cell.delegate = self;
            return cell;
            
        }
//        GoodsGroupTableViewCell *cell = [GoodsGroupTableViewCell goodsGroupTableViewCellYellow];
//        cell.goodsDetail = self.goodsDetail;
//        cell.order = [RecentOrder recentOrderWithDict:self.goodsDetail.recent_order];
//
//        NSInteger rest = [self.goodsDetail.recent_order[@"end_time"] integerValue];
////        NSInteger second = rest - round(CFAbsoluteTimeGetCurrent()-_start);
//        [cell setConfigWithSecond:rest];
//        cell.delegate = self;
//        return cell;
        
    }
    

//        拼团玩法
        if (indexPath.section == 2) {
            
            if (indexPath.row == 0) {
                GoodsGroupTableViewCell *cell = [GoodsGroupTableViewCell goodsGroupTableViewCellTwo];
                return cell;
            }
            
            if (indexPath.row == 1) {
                GoodsGroupTableViewCell *cell = [GoodsGroupTableViewCell goodsGroupTableViewCellThree];
                return cell;
            }
            
        }
    
    if (indexPath.section == 3 ) {
        //            手艺人信息
        ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
        if (self.goodsDetail) {
            cell.goodsDetailOne = _goodsDetail;
        }
        
        return cell;
    }
    
//    套餐详情
        if (indexPath.section == 5) {
            PackageTableViewCell *cell = [PackageTableViewCell packageTableViewCellOne];
            
            if (self.goodsDetail) {
                
                cell.goodsDetail = [RulesItem authorGoodsWithDict:_goodsDetail.goods_detail_list[indexPath.row]];
                
            }
            
           
            return cell;
        }
    
//    评价
    
    if (indexPath.section == 4) {
        
        CommentOrderTableViewCell *cell = [CommentOrderTableViewCell commentOrderTableViewCell];
        cell.comment = [OrderComment orderCommentWithDict:self.goodsDetail.evaluate_list[indexPath.row]];
        _commentHeightDic[@(indexPath.row)] = @(cell.cellHeight);
        return cell;
        
    }
    
//    购买须知
        if (indexPath.section == 6) {
            PackageTableViewCell *cell = [PackageTableViewCell packageTableViewCellTwo];
            cell.needknow = [RulesItem authorGoodsWithDict:_goodsDetail.need_know[indexPath.row]];
            _heightDic[@(indexPath.row)] =  @(cell.cellHeight);
            return cell;
        }
    
//    其他套餐
        if (indexPath.section == 7) {
            
            FamousGoodsTableViewCell *cell = [FamousGoodsTableViewCell  famousGoodsTableViewCellDetailT];
            cell.goods = [AuthorGoods authorGoodsWithDict:self.goodsDetail.other_goods_list[indexPath.row]];
            
            return cell;
        }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    头部
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if ([self.goodsDetail.is_group integerValue] == 3){
                
                return kWidth*200/375+80;
                
            }
            
            return kWidth*200/375+60;
            
        }
        
        return 44;
    }
    
//    拼团信息
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0 ) {
            
            if (self.goodsDetail.recent_in.count) {
                return 40;
            }
            
            if (self.goodsDetail.recent_order.count) {
                return 60;
            }
        }else{
            return 60;
        }
        
    }
    
//    拼团玩法
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            return 44;
        }else{
            return 49;
        }
        
    }
    
//    手艺人详情
    if (indexPath.section == 3) {
        
        return 88;
        
        
    }
    
    
//    评价
    if (indexPath.section == 4) {
        return [_commentHeightDic[@(indexPath.row)] doubleValue];
    }
    
//须知
    if (indexPath.section == 6) {
        return [_heightDic[@(indexPath.row)] doubleValue];
    }
    
//    商品
    if (indexPath.section == 7) {
        return 88;
    }
    
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0 ) {
        
        if ([_goodsDetail.is_group integerValue] == 2 || (![_goodsDetail.recent_order isKindOfClass:[NSDictionary class]] && !_goodsDetail.recent_in.count)) {
            return 0.000001;
        }
        
    }
    
    if (section == 1) {
        if ([_goodsDetail.is_group integerValue] == 2 || (![_goodsDetail.recent_order isKindOfClass:[NSDictionary class]] && !_goodsDetail.recent_in.count)) {
            return 0.000001;
        }
    }
    
    if (section == 3 && self.goodsDetail.grade.length  == 0) {
        return 0.00001;
    }
    
    if (section == 4 && self.goodsDetail.evaluate_list.count) {
        return 54;
    }
    
    if (section == 5 && !self.goodsDetail.goods_detail_list.count) {
        return 0.00001;
        
    }else if( section == 5 && self.goodsDetail.goods_detail_list.count) {
        
        if (self.goodsDetail.remark.length) {
            return 44;
        }
        
    }
    
    if (section == 6 && !self.goodsDetail.need_know.count) {
        return 0.00001;
    }
    
    if (section == 7 && !self.goodsDetail.other_goods_list.count) {
        return 0.00001;
    }
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 4 && self.goodsDetail.evaluate_list.count) {
        
//        return 200;
        
        return [self.heightDic[@"head"] doubleValue];
    }
    
    if (section == 5 && self.goodsDetail.goods_detail_list.count) {
        return 44;
    }
    
    if (section == 6 && self.goodsDetail.need_know.count) {
        return 44;
    }
    
    if (section == 7 && self.goodsDetail.other_goods_list.count) {
        return 44;
    }
    
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [v addSubview:line];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(Space, 0, kWidth-Space*2, 44)];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = FontColor;
    [v addSubview:lab];
    
    if (section == 5 && self.goodsDetail.goods_detail_list.count) {
        lab.text = @"套餐详情";
        return v;
    }
    
    if (section == 6 && self.goodsDetail.need_know.count) {
        lab.text = @"购买须知";
        return v;
    }
    
    if (section == 7 && self.goodsDetail.other_goods_list.count) {
        lab.text = @"其他套餐";
        return v;
    }
    
    if (section == 4  && self.goodsDetail.evaluate_list.count) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, [_heightDic[@"head"] doubleValue])];
        self.head.frame = CGRectMake(0, 0, kWidth, [_heightDic[@"head"] doubleValue]);
        [view addSubview:self.head];
        return view;
    }
    
    
    return nil;
}

- (AuthorDetailHead *)head{
    
    if (!_head) {
        
        _head = [AuthorDetailHead authorDetailHead];
        
    }
    
    return _head;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 5 && self.goodsDetail.goods_detail_list.count) {
        
        if (self.goodsDetail.remark.length) {
            PackageTableViewCell *cell = [PackageTableViewCell packageTableViewCellRemark];
            cell.remarkLab.text = self.goodsDetail.remark;
            return cell;
        }
        
    }
    
    if (section == 4 && self.goodsDetail.evaluate_list.count) {
        
        UIView *v = [UIView new];
        v.backgroundColor= [UIColor groupTableViewBackgroundColor];
        
        SearchFooterTableViewCell *cell = [SearchFooterTableViewCell searchFooterTableViewCellFooter];
        cell.countLab.text = [NSString stringWithFormat:@"共%@条",self.goodsDetail.evaluate_count];
        cell.frame = CGRectMake(0, 0, kWidth, 44);
        [v addSubview:cell];
        cell.delegate = self;
        return v;
        
        
        
        
    }
    
    return nil;
    
    
}


#pragma mark - 查看全部评价
- (void)lookMore:(NSUInteger)index{
    
    ALLCommentViewController *shopVC= [[ALLCommentViewController alloc]init];
    
    if (self.goodsDetail.author_uuid.length) {
        
        shopVC.type = @"2";
        shopVC.uuid = _goodsDetail.author_uuid;
        
    }else{
        
        shopVC.type = @"1";
        shopVC.uuid = _goodsDetail.shop_uuid;
        
    }
    
    
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if ( [self.goodsDetail.is_activity integerValue] == 1) {
            
            //        领取优惠券
            if (indexPath.row == 3) {
                
                if (![PublicMethods isLogIn]) {
                    LoginViewController *logVC = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:logVC animated:YES];
                    
                    return;
                }
                
                BaseAlertController *ctrl = [[BaseAlertController alloc]init];
                
                ctrl.selectComplete = ^(NSUInteger index) {
                    
                    [self couponAction:index];
                    
                };
                
                ctrl.dataAry = self.goodsDetail.coupon_list;
                [self presentViewController:ctrl animated:YES completion:nil];
                
            }
            
        }else{
            //        领取优惠券
            if (indexPath.row == 2) {
                
                if (![PublicMethods isLogIn]) {
                    LoginViewController *logVC = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:logVC animated:YES];
                    
                    return;
                }
                
                BaseAlertController *ctrl = [[BaseAlertController alloc]init];
                
                ctrl.selectComplete = ^(NSUInteger index) {
                    
                [self couponAction:index];
                    
                };
                
                ctrl.dataAry = self.goodsDetail.coupon_list;
                [self presentViewController:ctrl animated:YES completion:nil];
        }
        
        }
    }
    
//    发起拼团
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            GroupPayViewController *groupVC = [[GroupPayViewController alloc]init];
            groupVC.ID = _ID;
            [self.navigationController pushViewController:groupVC animated:YES];
            
        }
        
    }
    
    
//    拼团规则
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
            NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
            adVC.url = self.goodsDetail.group_rule_url;
            [self.navigationController pushViewController:adVC animated:YES];
            
        }
    }
    
//    手艺人详情
    if (indexPath.section == 3 ) {
        
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = self.goodsDetail.author_uuid;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }
    
//    商品详情
    if (indexPath.section == 7) {
        
        NSString *uuid = [self.goodsDetail.other_goods_list[indexPath.row] objectForKey:@"id"];
        GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
        detailVc.ID = uuid;
        detailVc.isGroup = [[self.goodsDetail.other_goods_list[indexPath.row] objectForKey:@"is_group"] integerValue];
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }
    
}

- (void)couponAction:(NSUInteger)index{
    
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
    
    NSString *coupon_id = [self.goodsDetail.coupon_list[index] objectForKey:@"id"];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"coupon_id":coupon_id}];
    
    [YYNet POST:UsergetCoupon paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"success"]];
        toast.toastType = FFToastTypeSuccess;
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        return ;
       
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (void)getData{
    
    //网络请求
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    if (!self.sessionID) {
        self.sessionID = @"";
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"goods_id":_ID,@"lat":lat,@"lng":lng,@"session_id":self.sessionID}];
    
    [YYNet POST:GoodsDetailNEW paramters:@{@"json":url} success:^(id responseObject) {
        
       NSDictionary *dic = [solveJsonData changeType:responseObject];
        self.goodsDetail = [GoodsDetail authorGoodsWithDict:dic[@"data"]];
        
        self.head.tagAry = dic[@"data"][@"service_tag"];
        self.head.modelGoods = [ShopModel shopModeltWithDict:dic[@"data"]];
        self.heightDic[@"head"] = @(self.head.cellHeight);
        
        if ([self.goodsDetail.is_group integerValue] == 2) {
            
             self.groupPriceLab.text = [NSString stringWithFormat:@"¥%@  立即购买",self.goodsDetail.dis_price];
            
            if ([self.goodsDetail.is_activity integerValue] == 1) {
                self.groupPriceLab.text = [NSString stringWithFormat:@"¥%@  限时抢购",self.goodsDetail.activity_price];
            }
            
            self.groupTitle.text = @"立即购买";
            
        }else{
            
            self.priceLab.text = [NSString stringWithFormat:@"¥%@  立即购买",self.goodsDetail.dis_price];
            
//            样式
//            NSString *pushString = [NSString stringWithFormat:@"拼团最低¥%@",self.goodsDetail.group_price];
//
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:pushString];
//
//            [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(0, 5)];
           
            self.groupPriceLab.text = [NSString stringWithFormat:@"¥%@  限时抢购",self.goodsDetail.group_price];
            
        }
        
        if (self.sessionID.length && self.isSecKill != 1) {
            self.groupPayBtn.backgroundColor = [UIColor lightGrayColor];
            self.groupPayBtn.enabled = NO;
            self.groupPriceLab.text = [NSString stringWithFormat:@"¥%@  未开始",self.goodsDetail.dis_price];
        }
        
        if (self.sessionID.length && self.isSecKill == 1) {
             self.groupPriceLab.text = [NSString stringWithFormat:@"¥%@  限时抢购",self.goodsDetail.dis_price];
        }
        
        if (self.sessionID.length && self.isSoldKill == 0) {
            self.groupPayBtn.backgroundColor = [UIColor lightGrayColor];
            self.groupPayBtn.enabled = NO;
            self.groupPriceLab.text = @"已抢完";
        }
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        
    }];
    
}



- (IBAction)telAction:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",self.goodsDetail.customer_service]]]];
    [self.view addSubview:callWebview];
    
}


- (IBAction)groupPay:(UIButton *)sender {
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    if ([self.goodsDetail.is_group integerValue] == 1) {
        
        GroupPayViewController *groupVC = [[GroupPayViewController alloc]init];
        groupVC.ID = _ID;
        [self.navigationController pushViewController:groupVC animated:YES];
        
    }else if (self.sessionID.length && self.isSecKill == 1){
        
        SecondKillsOrderViewController *killVC= [[SecondKillsOrderViewController alloc]init];
        
        killVC.name = self.goodsDetail.goods_name;
        killVC.sec_price = self.goodsDetail.dis_price;
        killVC.ID = self.ID;
        killVC.activity_id = self.goodsDetail.activity_id;
        killVC.session_id = self.sessionID;
        killVC.org_price = self.goodsDetail.sec_org_price;
        [self.navigationController pushViewController:killVC animated:YES];
        
    }else{
        
        GoodsPaySingleViewController *groupVC = [[GoodsPaySingleViewController alloc]init];
        groupVC.ID = _ID;
        groupVC.type = @"2";
        if ( [self.goodsDetail.is_activity integerValue] == 1) {
            groupVC.isActivity = @"1";
        }else{
            groupVC.isActivity = @"2";
        }
        
        
        [self.navigationController pushViewController:groupVC animated:YES];
        
    }
    
    
}

- (IBAction)payAction:(UIButton *)sender {
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    GoodsPaySingleViewController *groupVC = [[GoodsPaySingleViewController alloc]init];
    groupVC.ID = _ID;
    groupVC.isActivity = @"2";
    groupVC.type = @"1";
    [self.navigationController pushViewController:groupVC animated:YES];
    
}

- (void)didClickJoin{
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
        return;
    }
    
    WeiJoinGroupViewController *weiVC = [[WeiJoinGroupViewController alloc]init];
    weiVC.ID = self.goodsDetail.recent_order[@"common_order_num"];
    weiVC.goodsID = self.ID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.mainTableView.mj_header beginRefreshing];
    
}

@end
