//
//  UserHeaderView.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UserHeaderView.h"
#import "XHStarRateView.h"

@interface UserHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *timeLast;

@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (strong, nonatomic)   XHStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UILabel *followLab;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *zanLab;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@end
@implementation UserHeaderView

+(instancetype)userHeaderViewWithFrame:(CGRect)frame{
    UserHeaderView *instance = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil][0];
    instance.frame = frame;
    instance.nickName.layer.cornerRadius = 3;
    instance.nickName.layer.masksToBounds = YES;
    
    CGRect rect = CGRectMake(86, 123, 85, 12);
//

    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:rect];
    [instance addSubview:starRateView];
    
    [starRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(85));
        make.height.equalTo(@(12));
        make.left.mas_equalTo(instance.mas_left).offset(Space);
        make.bottom.mas_equalTo(instance.mas_bottom).offset(-80);
    }];
    
    instance.starRateView = starRateView;
    instance.starRateView.rateStyle = HalfStar;
    return instance;
}

+ (instancetype)userHeadView{
    
   return  [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil][1];
    
}

- (void)setHomeCellViewModel:(UserHeader *)homeCellViewModel{
    
    _homeCellViewModel = homeCellViewModel;
    if (homeCellViewModel.image.length) {
        [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:homeCellViewModel.image] placeholderImage:[UIImage imageNamed:@"test.png"]];
       
    }else{
        _iconImg.image = [UIImage imageNamed:@"test.png"];
        
    }
    self.starRateView.currentScore = [homeCellViewModel.score doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    _nameLabel.text = homeCellViewModel.nickname;
    _introLabel.text = homeCellViewModel.intro;
    _followLab.text = [NSString stringWithFormat:@"%@",homeCellViewModel.attention_count];
     _fansLab.text = [NSString stringWithFormat:@"%@",homeCellViewModel.fans_count];
     _zanLab.text = [NSString stringWithFormat:@"%@",homeCellViewModel.praise_count];
    
    _timeLast.text = [NSString stringWithFormat:@"从业：%@年",homeCellViewModel.obtain];
    _scoreLab.text = [NSString stringWithFormat:@"%@分",homeCellViewModel.score];
    _orderCount.text = [NSString stringWithFormat:@"(%@单)",homeCellViewModel.order_num];
    _nickName.text = [NSString stringWithFormat:@" %@ ",homeCellViewModel.grade];
    _introLabel.text = homeCellViewModel.intro;
    
    if ([homeCellViewModel.is_relationship integerValue] == 1) {
        _followBtn.selected = YES;
    }else{
        _followBtn.selected = NO;
    }
    

}

- (IBAction)followAction:(UIButton *)sender {
    
    [self.delegate didselectfollow];
    
}


@end
