//
//  ChangeUserDataViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChangeUserDataViewController.h"
#import "WeiUserInfo.h"
#import "UIButton+WebCache.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"
#import "LXDatePickerViewController.h"
#import "TZImagePickerController.h"
#import "ChangeSignViewController.h"
#import "UITextView+Placeholder.h"
#import "ZYKeyboardUtil.h"

@interface ChangeUserDataViewController ()<UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UITextViewDelegate>{
    WeiUserInfo *user;
//    参数
    NSString *finalSex;
    NSString *finalBirth;
    NSString *finalPersonalsign;
    NSString *finalName;
}
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;
@property (nonatomic,copy) NSString *finalcityid;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *iconLab;
@property (weak, nonatomic) IBOutlet UIView *iconBg;
@property (weak, nonatomic) IBOutlet UILabel *signTitle;

@property (weak, nonatomic) IBOutlet UIView *inforBg;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *sextitle;
@property (weak, nonatomic) IBOutlet UILabel *citytitle;
@property (weak, nonatomic) IBOutlet UILabel *birthTitle;


@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *birth;
@property (weak, nonatomic) IBOutlet UIButton *rightOne;
@property (weak, nonatomic) IBOutlet UIButton *rightTwo;
@property (weak, nonatomic) IBOutlet UIButton *manSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *man;
@property (weak, nonatomic) IBOutlet UIButton *womenSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *women;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLab;
@property (weak, nonatomic) IBOutlet UITextView *sign;

@property (weak, nonatomic) IBOutlet UITextField *lastTF;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;


@end

@implementation ChangeUserDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    user = [WeiUserInfo weiUserInfoWithDict:data];
    
    self.tabBarController.tabBar.hidden = YES;
    [self configNavView];
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
    
    [_pubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
//    头像
    _iconBg.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, 154);
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(self.iconBg.mas_top).offset(24);
        make.centerX.mas_equalTo(self.iconBg.mas_centerX);
    }];
    
    if (user.image.length) {
        
        [_icon sd_setImageWithURL:[NSURL urlWithNoBlankDataString:user.image]];
        
    }
    
    _iconBtn.frame = _icon.frame;
    [_iconLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self.iconBg.mas_centerX);
    }];
    
//    项目
   
    if (_isAuthor) {
        
        _inforBg.frame = CGRectMake(0, Space*2+154+SafeAreaHeight, kWidth, 325-44);
        
    }else{
        _inforBg.frame = CGRectMake(0, Space*2+154+SafeAreaHeight, kWidth, 325);
    }

    
    
//    昵称
    [_nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.inforBg.mas_top).offset(0);
        make.left.mas_equalTo(self.inforBg.mas_left).offset(Space);
    }];
    
    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.inforBg.mas_top).offset(0);
        make.right.mas_equalTo(self.inforBg.mas_right).offset(-Space);
    }];
    
     [ZZLimitInputManager limitInputView:self.nameTF maxLength:10];
    
    if (user.nickname.length) {
        _nameTF.text = user.nickname;
    }
    
   
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.inforBg.mas_top).offset(44);
        make.right.mas_equalTo(self.inforBg.mas_right).offset(0);
    }];
    
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.inforBg.mas_top).offset(44*2);
        make.right.mas_equalTo(self.inforBg.mas_right).offset(0);
    }];
    
//    性别
    if ([user.sex integerValue] == 1) {
        _manSelectBtn.selected = YES;
        _womenSelectBtn.selected = YES;
        finalSex = @"1";
    }else{
        _manSelectBtn.selected = NO;
        _womenSelectBtn.selected = NO;
        finalSex = @"2";
    }
    
    [_sextitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.inforBg.mas_left).offset(Space);
    }];
    
    [_women mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(0);
        make.right.mas_equalTo(self.inforBg.mas_right).offset(-Space);
    }];
    
    [_womenSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(self.women.mas_centerY).offset(0);
        make.right.mas_equalTo(self.women.mas_left).offset(-8);
    }];
    
    [_man mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(0);
        make.right.mas_equalTo(self.womenSelectBtn.mas_left).offset(-24);
    }];
    
    [_manSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(self.women.mas_centerY).offset(0);
        make.right.mas_equalTo(self.man.mas_left).offset(-8);
    }];
    
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.inforBg.mas_top).offset(44*3);
        make.right.mas_equalTo(self.inforBg.mas_right).offset(0);
    }];
    
//所在城市
//    从业年份
    if (_isAuthor) {
        
        [_lastTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line2.mas_bottom).offset(0);
            make.left.mas_equalTo(self.inforBg.mas_left).offset(Space);
        }];
        
        [_lastTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line2.mas_bottom).offset(0);
            make.right.mas_equalTo(self.inforBg.mas_right).offset(-Space*3);
        }];
//        从业时间
        _lastTF.text = [NSString stringWithFormat:@"%@年",user.obtain];
        _finalcityid = user.city_id;
        _city.hidden = YES;
        _citytitle.hidden = YES;
        _rightOne.hidden = YES;
        
    }else{
        
        [_citytitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line2.mas_bottom).offset(0);
            make.left.mas_equalTo(self.inforBg.mas_left).offset(Space);
        }];
        
        [_rightOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(7);
            make.height.mas_equalTo(22);
            make.top.mas_equalTo(self.line2.mas_bottom).offset(11);
            make.right.mas_equalTo(self.inforBg.mas_right).offset(-Space);
        }];
        
        [_city mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line2.mas_bottom).offset(0);
            make.right.mas_equalTo(self.rightOne.mas_left).offset(-8);
        }];
        
        _city.text = user.city_name;
        _finalcityid = user.city_id;
        
        if (!_finalcityid) {
            _finalcityid = @"";
        }
        
        _lastTimeLab.hidden = YES;
        _lastTF.hidden = YES;
        
    }
    
    
    
    [_line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.inforBg.mas_top).offset(44*4);
        make.right.mas_equalTo(self.inforBg.mas_right).offset(0);
    }];
    
    if (_isAuthor) {
        
        _birthTitle.hidden = YES;
        _birth.hidden = YES;
        _rightTwo.hidden = YES;
        _btn3.hidden = YES;
        _btn4.hidden = YES;
        
    }else{
        
        //    生日
        [_birthTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line3.mas_bottom).offset(0);
            make.left.mas_equalTo(self.inforBg.mas_left).offset(Space);
        }];
        
        [_rightTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(7);
            make.height.mas_equalTo(22);
            make.top.mas_equalTo(self.line3.mas_bottom).offset(11);
            make.right.mas_equalTo(self.inforBg.mas_right).offset(-Space);
        }];
        
        [_birth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line3.mas_bottom).offset(0);
            make.right.mas_equalTo(self.rightTwo.mas_left).offset(-8);
        }];
        
        if (user.age.length) {
            _birth.text = [self convertTimeSpToSting:user.age];
            finalBirth = user.age;
        }else{
             finalBirth = @"";
        }
       
        
        [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line2.mas_bottom).offset(0);
            make.right.mas_equalTo(self.inforBg.mas_right).offset(0);
        }];
        
        [_btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line3.mas_bottom).offset(0);
            make.right.mas_equalTo(self.inforBg.mas_right).offset(0);
        }];
    }
    
    if (_isAuthor) {
        
        //    签名
        [_signTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line3.mas_bottom).offset(0);
            make.left.mas_equalTo(self.inforBg.mas_left).offset(Space);
        }];
        
        [_sign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth -Space*2);
            make.height.mas_equalTo(80);
            make.top.mas_equalTo(self.line3.mas_bottom).offset(45);
            make.right.mas_equalTo(self.inforBg.mas_right).offset(-Space);
        }];
        
    }else{
        
        //    签名
        [_signTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.line4.mas_bottom).offset(0);
            make.left.mas_equalTo(self.inforBg.mas_left).offset(Space);
        }];
        
        [_sign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth -Space*2);
            make.height.mas_equalTo(80);
            make.top.mas_equalTo(self.line4.mas_bottom).offset(45);
            make.right.mas_equalTo(self.inforBg.mas_right).offset(-Space);
        }];
        
        
        
    }
    
    _sign.delegate = self;
    if (user.personal_sign.length) {
        _sign.text = user.personal_sign;
        finalPersonalsign = user.personal_sign;
        
    }else{
        finalPersonalsign = @"";
        _sign.placeholder = @"输入你的签名";
    }
    
    [self addToolTab];
    
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:5];
    MJWeakSelf
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.sign, nil];
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    _sign.placeholder = @"输入你的签名";
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
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
    [self.sign setInputAccessoryView:topView];
    [self.nameTF setInputAccessoryView:topView];
}

- (void)doneWithIt{
    [self.view endEditing:YES];
}



- (IBAction)changeCity:(UIButton *)sender {
    
    [[CitiesDataTool sharedManager] requestGetData];
    
    self.cover.hidden = NO;
    self.chooseLocationView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.chooseLocationView.frame = CGRectMake(0, kHeight/2, kWidth, kHeight/2);
    }];
    
}

- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self.view addSubview:_cover];
        
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0,   kHeight/2, [UIScreen mainScreen].bounds.size.width, kHeight/2)];
        [self.view addSubview:_chooseLocationView];
        
        __block typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                if (weakSelf.chooseLocationView.code.length) {
                    weakSelf.city.text = weakSelf.chooseLocationView.address;
                    weakSelf.finalcityid = weakSelf.chooseLocationView.code;
                }
                weakSelf.cover.hidden = YES;
                weakSelf.chooseLocationView.frame = CGRectMake(0, kHeight, kWidth, kHeight/2);
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return _cover;
}

- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}



- (IBAction)changeBirth:(UIButton *)sender {
    
    [self showDatePickerViewControllerWithSelectedDate:[NSDate date] uploadLabel:_birth];
    
}

- (void)showDatePickerViewControllerWithSelectedDate:(NSDate *)date uploadLabel:(UILabel *)label {
    
    NSString *birthdayStr=@"1990-01-01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *birthdayDate = [dateFormatter dateFromString:birthdayStr];
    
    LXDatePickerViewController *pickerVC = [[LXDatePickerViewController alloc] initWithSelectedDate:birthdayDate];
    pickerVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    pickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self  presentViewController:pickerVC animated:NO completion:^{
        
    }];
    
    //    __weak typeof(pickerVC)weakVC = pickerVC;
    pickerVC.cancleBlock = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
        
    };
    pickerVC.selectBlock = ^(NSString *dateString) {
        [self dismissViewControllerAnimated:NO completion:nil];
        label.text = dateString;
        
        //转时间戳
        [self convertTimeSp:dateString];
    };
    
    
}

- (void)convertTimeSp:(NSString *)timeStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    
    //设置时区
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeStr]; //将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    finalBirth = timeSp;
}

- (NSString *)convertTimeSpToSting:(NSString *)timeStr{
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = [timeStr integerValue];
    NSDate *date  = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    
    return dateString;
}



- (IBAction)nan:(UIButton *)sender {
    
    sender.selected = YES;
    _womenSelectBtn.selected = YES;
    
    if (sender.selected) {
        finalSex = @"1";
    }
    
}

- (IBAction)nv:(UIButton *)sender {
    
    sender.selected = NO;
    _manSelectBtn.selected = NO;
    if (!sender.selected) {
        finalSex = @"2";
    }
}
- (IBAction)changeIcon:(UIButton *)sender {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.photoWidth = kWidth-20;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowCrop = YES;
//    imagePickerVc.needCircleCrop = YES;
    //    // 设置竖屏下的裁剪尺寸
    NSInteger left = 55;
    NSInteger widthHeight = kWidth - 2 * left;
    NSInteger top = (kHeight - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    //     You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count) {
            
            //            做上传保存
            [self->_icon setImage:photos[0]];
            
            YYNetModel *model = [[YYNetModel alloc]init];
            model.fileData = [self imageToData:photos[0]];
            model.fileName = [NSString stringWithFormat:@"%i.png",arc4random()%10];
            model.name = [NSString stringWithFormat:@"image%i",1];
            model.mimeType = @"image/png";
            
            NSString *url = [PublicMethods dataTojsonString:@{@"uuid":self->user.uuid}];
            
            [YYNet upLoad:SavePersonalData paramter:@{@"json":url} fileModelOne:model success:^(id responseObject) {
        
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *dict = [solveJsonData changeType:dic];
                
                if ([dic[@"success"] boolValue]) {
                    
                    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"success"]];
                    toast.toastType = FFToastTypeSuccess;
                    toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
                    [toast show];
//                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSUserDefaults standardUserDefaults] setValue:dict[@"data"] forKey:@"user"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }else{
                    
                    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
                    toast.toastType = FFToastTypeWarning;
                    toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
                    [toast show];
                    
                }
                
            } faild:^(id responseObject) {
                
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"网络连接超时" iconImage:[UIImage imageNamed:@"warning"]];
                toast.toastType = FFToastTypeWarning;
                toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
                [toast show];
                
                
            }];
            
        }
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

#pragma mark- 压缩图像，裁剪图像
-(NSData *)imageToData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 0.5);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//3M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//1.5M-3M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-1.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    
    NSLog(@"图片压缩%lu",data.length/1024);
    return data;
}


- (IBAction)saveAction:(UIButton *)sender {
    
    NSString *url = @"";
    
    
    
    if (_isAuthor) {
        url = [PublicMethods dataTojsonString:@{@"uuid":user.uuid,@"personal_sign":_sign.text,@"nickname":_nameTF.text,@"obtain":_lastTF.text,@"sex":finalSex}];
    }else{
     
        url = [PublicMethods dataTojsonString:@{@"uuid":user.uuid,@"personal_sign":_sign.text,@"nickname":_nameTF.text,@"city_id":_finalcityid,@"age":finalBirth,@"sex":finalSex}];
        
    }
    
    
    [YYNet POST:SavePersonalData paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            [[NSUserDefaults standardUserDefaults] setValue:dic[@"data"] forKey:@"user"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
        }
        
        
    } faild:^(id responseObject) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"网络连接超时" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
        
        
    }];
    
    
}

- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}



@end
