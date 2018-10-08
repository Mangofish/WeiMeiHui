//
//  LHPhotoBrowser.m
//  LHPhotoBrowserDemo
//
//  Created by slihe on 16/5/17.
//  Copyright © 2016年 slihe. All rights reserved.
//

#import "LHPhotoBrowser.h"
#import "LHPhotoView.h"
#import "LHPhotoTopBar.h"

#define photoPadding 10

@interface LHPhotoBrowser ()<LHPhotoViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate>
{
    LHPhotoTopBar *_topBar;
    UIScrollView *_scrollView;
    NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
}

@property(nonatomic, strong)NSArray *imgRectArray;
@property(nonatomic, strong)NSMutableArray *imageProgressArray;
@property(nonatomic, assign)NSInteger curImgIndex;
@property(nonatomic, assign)UIInterfaceOrientationMask supportOrientation;
@property(nonatomic, assign)BOOL isRotating;
@property(nonatomic, assign)BOOL isPush;

@end

@implementation LHPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.supportOrientation = UIInterfaceOrientationMaskPortrait;
    
}

- (void)setImgsArray:(NSArray *)imgsArray
{
    _imgsArray = imgsArray;
    
    if (imgsArray.count > 1) {
        
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
        
    }
    
    NSMutableArray *tmpImgRectArray = [NSMutableArray array];
    
    for(UIView *view in imgsArray){
        [tmpImgRectArray addObject:[NSValue valueWithCGRect:[view convertRect:view.bounds toView:nil]]];
    }
    
    _imgRectArray = [tmpImgRectArray copy];
    
}

- (void)setImgUrlsArray:(NSArray *)imgUrlsArray
{
    _imgUrlsArray = imgUrlsArray;
    
    if (imgUrlsArray.count > 1) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for(int i = 0;i<imgUrlsArray.count;i++){
            
            [array addObject:[NSNumber numberWithFloat:0.0]];
            
        }
        
        _imageProgressArray = array;
        
    }
    
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, self.view.bounds.size.width + photoPadding, self.view.bounds.size.height}];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.hidden = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        
    }
    
    return _scrollView;
}

- (void)show
{
    [self browserWillShow];
    
    CGFloat bvW = self.scrollView.bounds.size.width - photoPadding;
    CGFloat bvH = self.scrollView.bounds.size.height;
    
    for(int i=0;i<_imgsArray.count;i++){
        
        if (i == _tapImgIndex) {
            [self showPhotoViewAtIndex:_tapImgIndex];
        }
    }
    
    _scrollView.contentSize = CGSizeMake(_imgsArray.count * (bvW + photoPadding), bvH);
    _scrollView.contentOffset = CGPointMake(_tapImgIndex * _scrollView.bounds.size.width, 0);
    
    _topBar = [[LHPhotoTopBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    
    if(_imgsArray.count > 1){
        
        [_topBar setPageNum:_tapImgIndex + 1 andAllPageNum:_imgsArray.count];
        
    }
    
    [self.view addSubview:_topBar];
    
}

- (void)showWithPush:(UIViewController *)superVc
{
    if (!superVc) {
        return;
    }
    
    _isPush = YES;
    
    superVc.navigationController.delegate = self;
    [superVc.navigationController pushViewController:self animated:YES];
    
    CGFloat bvW = self.scrollView.bounds.size.width - photoPadding;
    CGFloat bvH = self.scrollView.bounds.size.height;
    
    for(int i=0;i<_imgsArray.count;i++){
        
        if (i == _tapImgIndex) {
            [self showPhotoViewAtIndex:_tapImgIndex];
        }
    }
    
    _scrollView.contentSize = CGSizeMake(_imgsArray.count * (bvW + photoPadding), bvH);
    _scrollView.contentOffset = CGPointMake(_tapImgIndex * _scrollView.bounds.size.width, 0);
    
    if(_imgsArray.count > 1){
        
        self.title = [NSString stringWithFormat:@"%ld/%lu", _tapImgIndex + 1, (unsigned long)_imgsArray.count];
        
    }
    
//    _supportOrientation = UIInterfaceOrientationMaskAllButUpsideDown;
//    _scrollView.hidden = NO;
//    [UIViewController attemptRotationToDeviceOrientation];
    
//    _topBar = [[LHPhotoTopBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
//    
//    if(_imgsArray.count > 1){
//        
//        [_topBar setPageNum:_tapImgIndex + 1 andAllPageNum:_imgsArray.count];
//        
//    }
//    
//    [self.view addSubview:_topBar];
    
}

- (void)browserWillShow
{
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self animated:NO completion:^{
        
        _curImgIndex = _tapImgIndex;
        
        UIImageView *originImageView = _imgsArray[_tapImgIndex];
        
        UIImage *animationImg = originImageView.image;
        
        CGRect tapImgRect = [_imgRectArray[_tapImgIndex] CGRectValue];
        
        UIView *animationBgView = [[UIView alloc] initWithFrame:tapImgRect];
        animationBgView.clipsToBounds = YES;
        [self.view addSubview:animationBgView];
        
        UIImageView *animationImgView = [[UIImageView alloc] initWithFrame:animationBgView.bounds];
        animationImgView.contentMode = UIViewContentModeScaleAspectFill;
        animationImgView.image = animationImg;
        [animationBgView addSubview:animationImgView];
        
        CGFloat imageX = 0;
        CGFloat imageY = 0;
        CGFloat imageW = animationBgView.bounds.size.width;
        CGFloat imageH = animationBgView.bounds.size.height;
        
        animationImgView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        CGFloat animationW = [UIScreen mainScreen].bounds.size.width;
        CGFloat animationH = [UIScreen mainScreen].bounds.size.height;
        
        CGRect animationRect = CGRectMake(0, 0, animationW, animationH);
        
        CGFloat animationImgY = ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width * animationImg.size.height / animationImg.size.width) / 2;
        CGFloat animationImgH = [UIScreen mainScreen].bounds.size.width * animationImg.size.height / animationImg.size.width;
        
        if (animationImgY < 0) {
            animationImgY = 0;
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            
            animationBgView.frame = animationRect;
            animationImgView.frame = CGRectMake(0, animationImgY, animationW, animationImgH);
            
        } completion:^(BOOL finished) {
            
            [animationBgView removeFromSuperview];
            _supportOrientation = UIInterfaceOrientationMaskAllButUpsideDown;
            _scrollView.hidden = NO;
            [UIViewController attemptRotationToDeviceOrientation];
            
        }];
        
    }];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self layoutPhotoBrowser];
}

- (void)layoutPhotoBrowser
{
    CGPoint point = _scrollView.contentOffset;
    CGFloat offsetX = point.x;
    NSInteger curIndex = offsetX / _scrollView.bounds.size.width;
    
    _scrollView.frame = (CGRect){0, 0, self.view.bounds.size.width + 10, self.view.bounds.size.height};
    
    CGFloat bvW = _scrollView.bounds.size.width - 10;
    CGFloat bvH = _scrollView.bounds.size.height;
    
    for (LHPhotoView *bv in _visiblePhotoViews) {
        
        bv.frame = (CGRect){(bv.tag - 1) * (bvW + 10), 0, bvW, bvH};
        [bv resetSize];
        
    }
    
    _scrollView.contentSize = CGSizeMake(_imgsArray.count * (bvW + 10), bvH);
    _scrollView.contentOffset = CGPointMake(curIndex * (bvW + 10), 0);
    _topBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    
}

- (void)showPhotoViewAtIndex:(NSInteger)index
{
    CGFloat bvW = self.scrollView.bounds.size.width - photoPadding;
    CGFloat bvH = self.scrollView.bounds.size.height;
    
    LHPhotoView *bv = [self dequeueReusablePhotoView];
    
    if (!bv) {
        bv = [[LHPhotoView alloc] initWithFrame:(CGRect){index * (_scrollView.bounds.size.width), 0, bvW, bvH}];
    } else {
        bv.frame = (CGRect){index * (_scrollView.bounds.size.width), 0, bvW, bvH};
    }
    
    [_visiblePhotoViews addObject:bv];
    
    bv.tag = index + 1;
    bv.photoViewDelegate = self;
    [_scrollView addSubview:bv];
    
    UIImageView *originImageView = _imgsArray[index];
    
    bv.itemImage = originImageView.image;
    bv.itemImageProgress = [_imageProgressArray[index] floatValue];
    bv.itemImageUrl = _imgUrlsArray[index];
    
}

- (void)showPhotos
{
    
    if (_imgsArray.count == 1) {
        return;
    }
    
    if (_isRotating) {
        return;
    }
    
    CGRect visibleBounds = _scrollView.bounds;
    NSInteger firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+photoPadding) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-photoPadding-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _imgsArray.count) firstIndex = _imgsArray.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _imgsArray.count) lastIndex = _imgsArray.count - 1;
    
    NSInteger photoViewIndex;
    for (LHPhotoView *bv in _visiblePhotoViews) {
        photoViewIndex = bv.tag - 1;
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:bv];
            [bv removeFromSuperview];
        }
    }
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
    
}

- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (LHPhotoView *bv in _visiblePhotoViews) {
        
        if (bv.tag - 1 == index) {
            return YES;
        }
    }
    return  NO;
}

- (LHPhotoView *)dequeueReusablePhotoView
{
    LHPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    
    return photoView;
}

#pragma -mark navigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    _supportOrientation = UIInterfaceOrientationMaskAllButUpsideDown;
    _scrollView.hidden = NO;
    [UIViewController attemptRotationToDeviceOrientation];
    
}

#pragma -mark photoViewDelegate

- (void)photoViewSingleTap:(NSInteger)index
{
    if (_isPush) {
        return;
    }
    
    NSInteger curIndex = index - 1;
    
    _scrollView.hidden = YES;
    
    UIImageView *originImageView = _imgsArray[curIndex];
    
    UIImage *animationImg = originImageView.image;
    
    UIView *animationBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    animationBgView.clipsToBounds = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:animationBgView];
    
    CGFloat animationImgY = (self.view.bounds.size.height - self.view.bounds.size.width * animationImg.size.height / animationImg.size.width) / 2;
    CGFloat animationImgH = self.view.bounds.size.width * animationImg.size.height / animationImg.size.width;
    
    if (animationImgY < 0) {
        animationImgY = 0;
    }
    
    UIImageView *animationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, animationImgY, self.view.bounds.size.width, animationImgH)];
    animationImgView.contentMode = UIViewContentModeScaleAspectFill;
    animationImgView.image = animationImg;
    [animationBgView addSubview:animationImgView];
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = [_imgRectArray[curIndex] CGRectValue].size.width;
    CGFloat imageH = [_imgRectArray[curIndex] CGRectValue].size.height;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        animationBgView.frame = [_imgRectArray[curIndex] CGRectValue];
        animationImgView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
    } completion:^(BOOL finished) {
        
        [animationBgView removeFromSuperview];
        
    }];
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)photoIsShowingPhotoViewAtIndex:(NSUInteger)index
{
    return [self isShowingPhotoViewAtIndex:index];
}

- (void)updatePhotoProgress:(CGFloat)progress andIndex:(NSInteger)index
{
    _imageProgressArray[index] = [NSNumber numberWithFloat:progress];
}

- (void)updatePage
{
    CGRect visibleBounds = _scrollView.bounds;
    CGFloat MidBoundary = CGRectGetMinX(visibleBounds) + (_scrollView.bounds.size.width - photoPadding) * .5;
    int leftPage = MidBoundary / CGRectGetWidth(visibleBounds);
    CGFloat rightPage = MidBoundary - leftPage * CGRectGetWidth(visibleBounds);
    
    if (rightPage > CGRectGetWidth(visibleBounds) - photoPadding / 2) {
        
        [_topBar setPageNum:(leftPage + 2) andAllPageNum:_imgsArray.count];
        if (_isPush) {
            self.title = [NSString stringWithFormat:@"%d/%lu", (leftPage + 2), (unsigned long)_imgsArray.count];
        }
        
    } else {
        
        [_topBar setPageNum:(leftPage + 1) andAllPageNum:_imgsArray.count];
        if (_isPush) {
            self.title = [NSString stringWithFormat:@"%d/%lu", (leftPage + 1), (unsigned long)_imgsArray.count];
        }
        
    }
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self showPhotos];
    [self updatePage];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    _isRotating = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    _isRotating = NO;
}

- (BOOL)prefersStatusBarHidden
{
    return _hideStatusBar;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)showAlertView:(UIImageView *)view{
    
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"是否保存图片？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
                NSLog(@"取消保存图片");
            }];
    
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
                NSLog(@"确认保存图片");
    
                // 保存图片到相册
                UIImageWriteToSavedPhotosAlbum(view.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
            }];
    
            [alertControl addAction:cancel];
            [alertControl addAction:confirm];
    
            [self presentViewController:alertControl animated:YES completion:nil];
    
    
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    
    if(!error) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已保存到相册" iconImage:[UIImage imageNamed:@"success"]];
        toast.toastType = FFToastTypeSuccess;
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        
    }else {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:error.description iconImage:[UIImage imageNamed:@"error"]];
        toast.toastType = FFToastTypeError;
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        
    }
    
    
}


@end
