//
//  JFCityViewController.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFCityViewController.h"

#import "JFCityTableViewCell.h"
#import "JFCityHeaderView.h"
#import "JFAreaDataManager.h"
#import "JFLocation.h"
#import "JFSearchView.h"
#import "LocateAuthorityTableViewCell.h"
#import <CoreLocation/CLLocationManager.h>

#define kCurrentCityInfoDefaults [NSUserDefaults standardUserDefaults]

@interface JFCityViewController ()
<UITableViewDelegate,
UITableViewDataSource,
JFLocationDelegate,
JFCityHeaderViewDelegate,
JFSearchViewDelegate,LocateAuthorityDelegate>

{
    NSMutableArray   *_indexMutableArray;           //存字母索引下标数组
    NSMutableArray   *_sectionMutableArray;         //存处理过以后的数组
    NSInteger        _HeaderSectionTotal;           //头section的个数
    CGFloat          _cellHeight;                   //添加的(显示区县名称)cell的高度
}

@property (nonatomic, strong) UITableView *rootTableView;
@property (nonatomic, strong) JFCityTableViewCell *cell;
@property (nonatomic, strong) JFCityHeaderView *headerView;
@property (nonatomic, strong) JFAreaDataManager *manager;
@property (nonatomic, strong) JFLocation *locationManager;
@property (nonatomic, strong) JFSearchView *searchView;
@property (nonatomic, strong) LocateAuthorityTableViewCell *openCell;

/** 最近访问的城市*/
@property (nonatomic, strong) NSMutableArray *historyCityMutableArray;
/** 热门城市*/
@property (nonatomic, strong) NSMutableArray *hotCityArray;
/** 字母索引*/
@property (nonatomic, strong) NSMutableArray *characterMutableArray;
/** 所有“市”级城市名称*/
@property (nonatomic, strong) NSMutableArray *cityMutableArray;
/** 根据cityNumber在数据库中查到的区县*/
@property (nonatomic, strong) NSMutableArray *areaMutableArray;

@end

@implementation JFCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.hotCityArray = [NSMutableArray array];
    
  
    
    [self getHotCityAry];
//    [self.view addSubview:self.rootTableView];
    
   
    _HeaderSectionTotal = 2;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCityWithName:) name:JFCityTableViewCellDidChangeCityNotification object:nil];
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//
//    self.rootTableView.tableHeaderView = self.headerView;
    
    [self.view addSubview: self.headerView];
    
    [self backBarButtonItem];
    [self initWithJFAreaDataManaager];
    
    _indexMutableArray = [NSMutableArray array];
    _sectionMutableArray = [NSMutableArray array];
    
    
    self.rootTableView.sectionIndexColor=MainColor;
//    self.rootTableView.sectioninde
    
    if ([kCurrentCityInfoDefaults objectForKey:@"cityData"]) {
        self.characterMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[kCurrentCityInfoDefaults objectForKey:@"cityData"]];
        _sectionMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[kCurrentCityInfoDefaults objectForKey:@"sectionData"]];
        [_rootTableView reloadData];
        
        self.locationManager = [[JFLocation alloc] init];
        _locationManager.delegate = self;
        
    }else {
        //在子线程中异步执行汉字转拼音再转汉字耗时操作
        dispatch_queue_t serialQueue = dispatch_queue_create("com.city.www", DISPATCH_QUEUE_SERIAL);
        dispatch_async(serialQueue, ^{
            [self processData:^(id success) {
                //回到主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_rootTableView reloadData];
                    self.locationManager = [[JFLocation alloc] init];
                    _locationManager.delegate = self;
                });
            }];
        });
    }
    
    self.historyCityMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[kCurrentCityInfoDefaults objectForKey:@"historyCity"]];
    
    if (self.historyCityMutableArray.count == 0) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:WEILOCATION]) {
            [self.historyCityMutableArray addObject:[[NSUserDefaults standardUserDefaults] valueForKey:WEILOCATION]];
        }
    }
    
}

- (void)backBarButtonItem {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton addTarget:self action:@selector(backrootTableViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"Back" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

/// 初始化数据库，获取所有“市”级城市名称
- (void)initWithJFAreaDataManaager {
    _manager = [JFAreaDataManager shareInstance];
    [_manager areaSqliteDBData];
    __weak typeof(self) weakSelf = self;
    [_manager cityData:^(NSMutableArray *dataArray) {
        //立刻生成一个strong引用，以保证实例在执行期间持续存活
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.cityMutableArray = dataArray;
        }
    }];
}

/// 选择城市时调用通知函数（前提是点击cell的section < 3）
- (void)chooseCityWithName:(NSNotification *)info {
    NSDictionary *cityDic = info.userInfo;
    NSString *cityName = [[NSString alloc] init];
    if ([[cityDic valueForKey:@"cityName"] isEqualToString:@"全城"]) {
        __weak typeof(self) weakSelf = self;
        [_manager currentCity:[kCurrentCityInfoDefaults objectForKey:@"cityNumber"] currentCityName:^(NSString *name) {
            [kCurrentCityInfoDefaults setObject:name forKey:@"currentCity"];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
//                strongSelf.headerView.cityName = name;
                if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(cityName:)]) {
                    [strongSelf.delegate cityName:name];
                }
            }

        }];
    }else {
        cityName = [cityDic valueForKey:@"cityName"];

        
//        存储当前选择城市
        [kCurrentCityInfoDefaults setObject:[cityDic valueForKey:@"cityName"] forKey:WEICurrentCity];
        
        [_manager cityNumberWithCity:[cityDic valueForKey:@"cityName"] cityNumber:^(NSString *cityNumber) {
//            存储当前城市ID
            [kCurrentCityInfoDefaults setObject:cityNumber forKey:WEICITYID];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
                [self.delegate cityName:cityName];
            }
            
        }];
        
        [self historyCity:cityName];
    }
    
    //销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)areaMutableArray {
    if (!_areaMutableArray) {
        _areaMutableArray = [NSMutableArray arrayWithObject:@"全城"];
    }
    return _areaMutableArray;
}

- (JFCityHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JFCityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SafeAreaHeight)];
        _headerView.delegate = self;
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.cityName = [kCurrentCityInfoDefaults objectForKey:@"currentCity"] ? [kCurrentCityInfoDefaults objectForKey:@"currentCity"] : [kCurrentCityInfoDefaults objectForKey:@"locationCity"];
    }
    return _headerView;
}

- (JFSearchView *)searchView {
    if (!_searchView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _searchView = [[JFSearchView alloc] initWithFrame:CGRectMake(0, 104, frame.size.width, frame.size.height  - 104)];
        _searchView.backgroundColor = [UIColor colorWithRed:155 / 255.0 green:155 / 255.0 blue:155 / 255.0 alpha:0.5];
        _searchView.delegate = self;
    }
    return _searchView;
}

/// 移除搜索界面
- (void)deleteSearchView {
    [_searchView removeFromSuperview];
    _searchView = nil;
}

- (NSMutableArray *)historyCityMutableArray {
    if (!_historyCityMutableArray) {
        _historyCityMutableArray = [[NSMutableArray alloc] init];
    }
    return _historyCityMutableArray;
}

//- (NSArray *)hotCityArray {
//    if (!_hotCityArray) {
//        _hotCityArray = @[@"北京市", @"上海市", @"广州市", @"深圳市", @"武汉市", @"天津市", @"西安市", @"南京市", @"杭州市", @"成都市", @"重庆市"];
//    }
//    return _hotCityArray;
//}

- (NSMutableArray *)characterMutableArray {
    if (!_characterMutableArray) {
        _characterMutableArray = [NSMutableArray arrayWithObjects:@"定位", @"热门", nil];
    }
    return _characterMutableArray;
}

/// 汉字转拼音再转成汉字
-(void)processData:(void (^) (id))success {
    for (int i = 0; i < _cityMutableArray.count; i ++) {
        NSString *str = _cityMutableArray[i]; //一开始的内容
        if (str.length) {  //下面那2个转换的方法一个都不能少
            NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
            //汉字转拼音
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            //拼音转英文
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //字符串截取第一位，并转换成大写字母
                NSString *firstStr = [[ms substringToIndex:1] uppercaseString];
                //如果不是字母开头的，转为＃
                BOOL isLetter = [self matchLetter:firstStr];
                if (!isLetter)
                    firstStr = @"#";
                
                //如果还没有索引
                if (_indexMutableArray.count <= 0) {
                    //保存当前这个做索引
                    [_indexMutableArray addObject:firstStr];
                    //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                    NSMutableArray *array = [NSMutableArray arrayWithObject:str];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                    [_sectionMutableArray addObject:dic];
                }else{
                    //如果索引里面包含了当前这个字母，直接保存数据
                    if ([_indexMutableArray containsObject:firstStr]) {
                        //取索引对应的数组，保存当前标题到数组里面
                        NSMutableArray *array = _sectionMutableArray[0][firstStr];
                        [array addObject:str];
                        //重新保存数据
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                        [_sectionMutableArray addObject:dic];
                    }else{
                        //如果没有包含，说明是新的索引
                        [_indexMutableArray addObject:firstStr];
                        //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                        NSMutableArray *array = [NSMutableArray arrayWithObject:str];
                        NSMutableDictionary *dic = _sectionMutableArray[0];
                        [dic setObject:array forKey:firstStr];
                        [_sectionMutableArray addObject:dic];
                    }
                }
            }
        }
    }
    
    //将字母排序
    NSArray *compareArray = [[_sectionMutableArray[0] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    _indexMutableArray = [NSMutableArray arrayWithArray:compareArray];
    
    //判断第一个是不是字母，如果不是放到最后一个
    BOOL isLetter = [self matchLetter:_indexMutableArray[0]];
    if (!isLetter) {
        //获取数组的第一个元素
        NSString *firstStr = [_indexMutableArray firstObject];
        //移除第一项元素
        [_indexMutableArray removeObjectAtIndex:0];
        //插入到最后一个位置
        [_indexMutableArray insertObject:firstStr atIndex:_indexMutableArray.count];
    }
    
    [self.characterMutableArray addObjectsFromArray:_indexMutableArray];
    NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:self.characterMutableArray];
    NSData *sectionData = [NSKeyedArchiver archivedDataWithRootObject:_sectionMutableArray];
    
    //拼音转换太耗时，这里把第一次转换结果存到单例中
    [kCurrentCityInfoDefaults setValue:cityData forKey:@"cityData"];
    [kCurrentCityInfoDefaults setObject:sectionData forKey:@"sectionData"];
    success(@"成功");
}

#pragma mark - 匹配是不是字母开头
- (BOOL)matchLetter:(NSString *)str {
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}

- (void)backrootTableViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)rootTableView {
    if (!_rootTableView) {
        
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
            
            //定位功能可用
              _rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-Space-SafeAreaHeight) style:UITableViewStylePlain];
        }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
            
            //定位不能用
              _rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaHeight+Space+70, kWidth, kHeight-Space-SafeAreaHeight-70) style:UITableViewStylePlain];
            [self.view addSubview:self.openCell];
            
        }
        
      
        _rootTableView.backgroundColor = [UIColor whiteColor];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [_rootTableView registerClass:[JFCityTableViewCell class] forCellReuseIdentifier:@"cityCell"];
        [_rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityNameCell"];
    }
    return _rootTableView;
}

- (LocateAuthorityTableViewCell *)openCell{
    
    if (!_openCell) {
        _openCell = [[LocateAuthorityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locate"];
        _openCell.delegate = self;
        _openCell.frame = CGRectMake(0, SafeAreaHeight, kWidth, 70);
    }
    
    return _openCell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _characterMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section < _HeaderSectionTotal ? 1 : [_sectionMutableArray[0][_characterMutableArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _HeaderSectionTotal) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
            _cell.cityNameArray = _areaMutableArray;
        }
        if (indexPath.section == _HeaderSectionTotal - 3) {
            NSString *locationCity = [kCurrentCityInfoDefaults objectForKey:WEILOCATION];
            _cell.cityNameArray = locationCity ? @[locationCity] : @[@"正在定位..."];
        }
        if (indexPath.section == _HeaderSectionTotal - 2) {
            
            
            _cell.cityNameArray = self.historyCityMutableArray;
        }
        if (indexPath.section == _HeaderSectionTotal - 1) {
            _cell.cityNameArray = self.hotCityArray;
        }
    return _cell;
        
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityNameCell" forIndexPath:indexPath];
        NSArray *currentArray = _sectionMutableArray[0][_characterMutableArray[indexPath.section]];
        cell.textLabel.text = currentArray[indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.separatorInset = UIEdgeInsetsMake(44, 0, 0, 30);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
        return _cellHeight;
    }else {
        return indexPath.section == (_HeaderSectionTotal - 1) ? _hotCityArray.count%3 == 0 ? (_hotCityArray.count/3)*54 : (_hotCityArray.count/3+1)*54  : 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_HeaderSectionTotal == 4 && section == 0) {
        return 0;
    }else{
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    lab.font = [UIFont systemFontOfSize:12];
    lab.backgroundColor = MJRefreshColor(240, 240, 240);
    lab.textColor = MJRefreshColor(153, 153, 153);
    switch (section) {
        case 0:
            lab.text = @"   最近访问的城市";
            break;
        case 1:
            lab.text = @"   热门城市";
            break;
        default:
            lab.text = [NSString stringWithFormat:@"    %@",_characterMutableArray[section]];
            break;
    }
    [v addSubview:lab];
    return v;
}

//设置右侧索引的标题，这里返回的是一个数组哦！
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _characterMutableArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    _headerView.cityName = cell.textLabel.text;
    [kCurrentCityInfoDefaults setObject:cell.textLabel.text forKey:WEICurrentCity];
    
    [_manager cityNumberWithCity:cell.textLabel.text cityNumber:^(NSString *cityNumber) {
        
        [kCurrentCityInfoDefaults setObject:cityNumber forKey:WEICITYID];

//        NSLog( @"%@%@",cityNumber,cell.textLabel.text);
        
    }];
    
    if ([PublicMethods isLogIn]) {

        NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        NSString *city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];

        NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id}];

        [YYNet POST:ChangeCity paramters:@{@"json":url} success:^(id responseObject) {

            [self.navigationController popViewControllerAnimated:YES];

        } faild:^(id responseObject) {



        }];

    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
                [self.delegate cityName:cell.textLabel.text];
    
    }
    [self historyCity:cell.textLabel.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- JFCityHeaderViewDelegate

- (void)cityNameWithSelected:(BOOL)selected {
    //获取当前城市的所有辖区
    if (selected) {
        [_manager areaData:[kCurrentCityInfoDefaults objectForKey:WEICITYID] areaData:^(NSMutableArray *areaData) {
            [self.areaMutableArray addObjectsFromArray:areaData];
            if (0 == (self.areaMutableArray.count % 3)) {
                self->_cellHeight = self.areaMutableArray.count / 3 * 50;
            }else {
                self->_cellHeight = (self.areaMutableArray.count / 3 + 1) * 50;
            }
            if (self->_cellHeight > 300) {
                self->_cellHeight = 300;
            }
        }];
        
        //添加一行cell
        [_rootTableView endUpdates];
        [_characterMutableArray insertObject:@"*" atIndex:0];
        _HeaderSectionTotal = 4;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.rootTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        [_rootTableView endUpdates];
    }else {
        //清空区县名称数组
        self.areaMutableArray = nil;
        //删除一行cell
        [_rootTableView endUpdates];
        [_characterMutableArray removeObjectAtIndex:0];
        _HeaderSectionTotal = 3;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.rootTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        [_rootTableView endUpdates];
    }
}

- (void)beginSearch {
    [self.view addSubview:self.searchView];
}

- (void)endSearch {
    [self deleteSearchView];
}

- (void)searchResult:(NSString *)result {
    [_manager searchCityData:result result:^(NSArray *result) {
        if ([result count] > 0) {
            self->_searchView.backgroundColor = [UIColor whiteColor];
            self->_searchView.resultMutableArray = result ;
        }
    }];
}

#pragma mark - JFSearchViewDelegate

- (void)searchResults:(NSDictionary *)dic {
    
    [kCurrentCityInfoDefaults setObject:[dic valueForKey:@"super"] forKey:WEICurrentCity];
    
//    存当前城市ID
    [kCurrentCityInfoDefaults setValue:[dic valueForKey:@"city_number"] forKey:WEICITYID];
    
    NSString *nameStr = [dic valueForKey:@"super"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
        [self.delegate cityName:nameStr];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self historyCity:[dic valueForKey:@"super"]];
}

- (void)touchViewToExit {
    [_headerView cancelSearch];
}

#pragma mark - JFLocationDelegate

- (void)locating {
    NSLog(@"定位中。。。");
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSString *city = [locationDictionary valueForKey:@"City"];
    [kCurrentCityInfoDefaults setObject:city forKey:WEILOCATION];
    [_manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
        [kCurrentCityInfoDefaults setObject:cityNumber forKey:WEILocationCITYID];
    }];
    _headerView.cityName = city;
//    [self historyCity:city];
//    [_rootTableView reloadData];
}

/// 添加历史访问城市
- (void)historyCity:(NSString *)city {
    //避免重复添加，先删除再添加
    [_historyCityMutableArray removeObject:city];
    [_historyCityMutableArray insertObject:city atIndex:0];
    if (_historyCityMutableArray.count > 3) {
        [_historyCityMutableArray removeLastObject];
    }
    NSData *historyCityData = [NSKeyedArchiver archivedDataWithRootObject:self.historyCityMutableArray];
    [kCurrentCityInfoDefaults setObject:historyCityData forKey:@"historyCity"];
    [kCurrentCityInfoDefaults synchronize];
    
    
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
    
    [kCurrentCityInfoDefaults setObject:@"无权限" forKey:WEICurrentCity];
    [kCurrentCityInfoDefaults setObject:@"220100" forKey:WEICITYID];
    
    if ([PublicMethods isLogIn]) {
        
        NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        NSString *city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
        
        NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id}];
        
        [YYNet POST:ChangeCity paramters:@{@"json":url} success:^(id responseObject) {
            
//            [self.navigationController popViewControllerAnimated:YES];
            
        } faild:^(id responseObject) {
            
            
            
        }];
        
    }
    
    _headerView.cityName = @"未开启定位权限";
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
        [self.delegate cityName:@"未开启定位权限"];
        
    }
    //    [self historyCity:cell.textLabel.text];
    
   
    
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
    
    
    //    _headerView.cityName = cell.textLabel.text;
    [kCurrentCityInfoDefaults setObject:@"定位失败" forKey:WEICurrentCity];
    [kCurrentCityInfoDefaults setObject:@"220100" forKey:WEICITYID];
    
    if ([PublicMethods isLogIn]) {
        
        NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        NSString *city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
        
        NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id}];
        
        [YYNet POST:ChangeCity paramters:@{@"json":url} success:^(id responseObject) {
            
//            [self.navigationController popViewControllerAnimated:YES];
            
        } faild:^(id responseObject) {
            
            
            
        }];
        
    }
    
    _headerView.cityName = @"定位失败";
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
        [self.delegate cityName:@"定位失败"];
        
    }
//    [self historyCity:cell.textLabel.text];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"JFCityViewController dealloc");
}

- (void)popAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getHotCityAry{
    
    
//    NSString *url = [PublicMethods dataTojsonString:@{@"lat":@(0),@"lng":@(0),@"page":@(1)}];
    
    [YYNet POST:HotCityList paramters:@{@"json":@""} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *obj in dic[@"data"]) {
            [temp addObject:obj[@"area"]];
        }
        [self.hotCityArray setArray:temp];
        [self.view addSubview:self.rootTableView];
        [self->_rootTableView reloadData];
            
       
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (void)choosecity{
    
    NSString *city = [kCurrentCityInfoDefaults valueForKey:WEILOCATION];
    
    NSString *cityid = [kCurrentCityInfoDefaults valueForKey:WEILocationCITYID];
    [kCurrentCityInfoDefaults setValue:cityid forKey:WEICITYID];
    [kCurrentCityInfoDefaults setValue:city forKey:WEICurrentCity];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
        [self.delegate cityName:city];
        
    }
    
    [self historyCity:city];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 开启定位权限
- (void)openAction{
    
     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
}
@end
