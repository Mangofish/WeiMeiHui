//
//  AuthorDetailViewController.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorDetailViewController : UMClickViewController
@property (nonatomic,copy)NSString *ID;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end
