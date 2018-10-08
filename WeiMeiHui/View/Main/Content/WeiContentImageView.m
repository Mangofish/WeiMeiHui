//
//  WeiContentImageView.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiContentImageView.h"

#import "UIView+ShortCut.h"
#import "LHPhotoBrowser.h"
#import "AppDelegate.h"

#define SIZE_IMAGE (kWidth - CELL_PADDING_6*2 - CELL_SIDEMARGIN*2)/3
#define SIZE_IMAGE_ONE 0.3*kHeight

@interface WeiContentImageView()
{
    UIImageView *_imageOne;
    UIImageView *_imageTwo;
    UIImageView *_imageThree;
    UIImageView *_imageFour;
    UIImageView *_imageFive;
    UIImageView *_imageSix;
    UIImageView *_imageSeven;
    UIImageView *_imageEight;
    UIImageView *_imageNine;
    NSMutableArray *imgAry;
    UIButton *_playBtn;
}
@end

@implementation WeiContentImageView

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        
    }
    return self;
}


#pragma 配置view
-(void)configurationContentView
{
    
    
    _imageOne=[self setImage];
    _imageOne.tag=1;
    [self addSubview:_imageOne];
    
    
    _imageTwo=[self setImage];
    _imageTwo.tag=2;
    [self addSubview:_imageTwo];
    
    
    _imageThree=[self setImage];
    _imageThree.tag=3;
    [self addSubview:_imageThree];
    
    
    _imageFour=[self setImage];
    _imageFour.tag=4;
    [self addSubview:_imageFour];
    
    
    _imageFive=[self setImage];
    _imageFive.tag=5;
    [self addSubview:_imageFive];
    
    
    _imageSix=[self setImage];
    _imageSix.tag=6;
    [self addSubview:_imageSix];
    
    
    _imageSeven=[self setImage];
    _imageSeven.tag=7;
    [self addSubview:_imageSeven];
    
    _imageEight=[self setImage];
    _imageEight.tag=8;
    [self addSubview:_imageEight];
    
    
    _imageNine=[self setImage];
    _imageNine.tag=9;
    [self addSubview:_imageNine];
}


#pragma mark － 配置位置
-(void)configurationLocation
{
    
    _imageOne.frame=CGRectMake(CELL_SIDEMARGIN,CELL_PADDING_6,SIZE_IMAGE,SIZE_IMAGE);
    
    _imageTwo.frame=CGRectMake(CELL_PADDING_6+_imageOne.right,CELL_PADDING_6,SIZE_IMAGE,SIZE_IMAGE);
    _imageThree.frame=CGRectMake(CELL_PADDING_6+_imageTwo.right,CELL_PADDING_6,SIZE_IMAGE,SIZE_IMAGE);
    
    _imageFour.frame=CGRectMake(CELL_SIDEMARGIN,CELL_PADDING_6+_imageOne.bottom,SIZE_IMAGE,SIZE_IMAGE);
    _imageFive.frame=CGRectMake(CELL_PADDING_6+_imageFour.right,CELL_PADDING_6+_imageOne.bottom,SIZE_IMAGE,SIZE_IMAGE);
    _imageSix.frame=CGRectMake(CELL_PADDING_6+_imageFive.right,CELL_PADDING_6+_imageOne.bottom,SIZE_IMAGE,SIZE_IMAGE);
    
    
    _imageSeven.frame=CGRectMake(CELL_SIDEMARGIN,CELL_PADDING_6+_imageFour.bottom,SIZE_IMAGE,SIZE_IMAGE);
    _imageEight.frame=CGRectMake(CELL_PADDING_6+_imageSeven.right,CELL_PADDING_6+_imageFour.bottom,SIZE_IMAGE,SIZE_IMAGE);
    _imageNine.frame=CGRectMake(CELL_PADDING_6+_imageEight.right,CELL_PADDING_6+_imageFour.bottom,SIZE_IMAGE,SIZE_IMAGE);
}


#pragma 初始化
-(UIImageView *)setImage
{
    UIImageView *image=[[UIImageView alloc]init];
    image.contentMode=UIViewContentModeScaleAspectFill;
    image.backgroundColor = [UIColor lightGrayColor];
    image.clipsToBounds=YES;
    
    if ([_homeCellViewModel.type integerValue] == 2 || [_homeCellViewModel.is_advertise integerValue] == 1) {
       return image;
    }
    
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoto:)];
    [image addGestureRecognizer:tap];
    
    

    return image;
}



         
#pragma 赋值
-(void)setUrlArray:(NSMutableArray *)urlArray
{
    _urlArray=urlArray;
    
    double imgOneH = 0.0;
    
    //
    //    1.判断横竖图
    if (urlArray.count == 1) {
        double height = [[urlArray[0] objectForKey:@"height"] doubleValue];
        double width = [[urlArray[0] objectForKey:@"width"] doubleValue];
        double maxWidth = kWidth -20;
        double maxHeight = 0.3*kHeight;
        if (width) {
            
            if (width>height) {
                //                    1.横图
                imgOneH = maxWidth*height/width;
                _imageOne.frame=CGRectMake(CELL_SIDEMARGIN,CELL_PADDING_6,maxWidth,imgOneH);
            }else{
                //                    1.竖图
                imgOneH = maxHeight*(width/height);
                _imageOne.frame=CGRectMake(CELL_SIDEMARGIN,CELL_PADDING_6,imgOneH,maxHeight);
            }
            
        }
        
        
    }
   
    for (NSInteger i=0;i<9;++i)
    {
        UIImageView *image=(UIImageView *)[self viewWithTag:i+1];
        
        if (i < self.urlArray.count)
        {
            image.hidden = NO;
            NSDictionary *dic = [self.urlArray objectAtIndex:i];
            
            NSString *imageUrl = [dic objectForKey:@"url"];
            
            if (![imageUrl hasSuffix:@".gif"])
            {
                imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            }
            [image sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"test2"] options:SDWebImageRetryFailed];
            
        
        } else
        {
            image.hidden = YES;
        }
    }
}


#pragma 图片点击事件
-(void)tapPhoto:(UITapGestureRecognizer *)tapGes
{
    
   
    
    imgAry = [NSMutableArray array];
    
    UIImageView *tapedImgView = (UIImageView *)tapGes.view;
    
    
    NSMutableArray *bigUrlArray=[[NSMutableArray alloc]init];
    for (NSInteger i=0;i<self.urlArray.count;++i)
    {
        UIImageView *image=(UIImageView *)[self viewWithTag:i+1];
        
        NSDictionary *dic = [self.urlArray objectAtIndex:i];
        NSString *bigUrl = [dic objectForKey:@"original_url"];
        if (![bigUrl hasSuffix:@".gif"])
        {
            bigUrl = [bigUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        }
        [bigUrlArray addObject:bigUrl];
        
        [imgAry addObject:image];
    }
    
    
    
    LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
    
    bc.imgsArray = imgAry;
    bc.imgUrlsArray = bigUrlArray;
    bc.tapImgIndex = tapedImgView.tag-1;
    bc.hideStatusBar = NO;
    
   
    
//    [bc showWithPush: [[UIApplication sharedApplication] keyWindow].rootViewController]; //push方式
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [bc show];                    //present方式
    
}





////////////////////////////////////////////////////////
+(float)getContentImageViewHeight:(NSArray *)data
{
    
    CGFloat  size = (kWidth - CELL_PADDING_6*2 - CELL_SIDEMARGIN*2)/3;
    NSUInteger count = data.count;
    
    double imgOneH = 0.0;
    
//
//    1.判断横竖图
        if (data.count == 1) {
            double height = [[data[0] objectForKey:@"height"] doubleValue];
            double width = [[data[0] objectForKey:@"width"] doubleValue];
            double maxWidth = kWidth -20;
            double maxHeight = 0.3*kHeight;
            if (width) {
                
                if (width>height) {
//                    1.横图
                   imgOneH = maxWidth*height/width;

                }else{
//                    1.竖图
                    imgOneH = maxHeight;
                   
                }
                
            }
    
        }
    
    if (count == 1) {
        
        return imgOneH;
    }
    
    if (count>1&&count<=3)
    {
        return CELL_PADDING_6*2+size;
    }
    else if (count>=4&&count<=6)
    {
        return CELL_PADDING_6*3+size*2;
    }
    else if(count>=7&&count<=9)
    {
        return CELL_PADDING_6*4+size*3;
    }
    else
    {
        return 0;
    }
}

-  (void)setHomeCellViewModel:(WeiContent *)homeCellViewModel{
    
    _homeCellViewModel = homeCellViewModel;
    
    [self configurationContentView];
    [self configurationLocation];
    
    self.urlArray = homeCellViewModel.pic;
}

#pragma mark - context
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

@end
