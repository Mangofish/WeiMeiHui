//
//  BaseViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () 
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
  
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSStringFromClass([self class]) stringByAppendingString:@"cell"]];
    
    return cell;
}

//#pragma mark- 重点，敲黑板
//- (instancetype)init{
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    return self;
//}


@end
