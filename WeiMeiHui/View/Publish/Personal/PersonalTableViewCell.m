//
//  PersonalTableViewCell.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PersonalTableViewCell.h"
#import "TZCollectionViewFlowLayout.h"
#import "TZTestCell.h"
#import "UITextView+Placeholder.h"


@interface PersonalTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>{
    NSUInteger selectedIndex;
}
//图片展示
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) TZCollectionViewFlowLayout *layout;

@end

@implementation PersonalTableViewCell
+(instancetype)personalTableViewCellOne{
    PersonalTableViewCell *instance = [[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil][0];
    instance.contentView.backgroundColor = [UIColor whiteColor];
//    instance.frame = CGRectMake(0, 0, kWidth, 84);
    return instance;
}

+(instancetype)personalTableViewCellTwo{
    PersonalTableViewCell *instance = [[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil][1];
    return instance;
}

+(instancetype)personalTableViewCellThreeWithString:(NSString *)str{
    PersonalTableViewCell *instance = [[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil][2];
    instance.frame = instance.contentView.frame;
    instance.stateStr = str;
    instance.countLab.text = str;
    
    instance.layout = [[TZCollectionViewFlowLayout alloc] init];
    instance.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, kWidth,115) collectionViewLayout:instance.layout];
    instance.selectedAry = [NSMutableArray array];
    instance.collectionView.scrollEnabled = NO;
    instance.collectionView.backgroundColor = [UIColor whiteColor];
    instance.collectionView.contentInset = UIEdgeInsetsMake(5, 10,5, 10);
    instance.collectionView.dataSource = instance;
    instance.collectionView.delegate = instance;
    instance.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [instance.contentView addSubview:instance.collectionView];
    [instance.collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    return instance;
}

+(instancetype)personalTableViewCellFour{
    PersonalTableViewCell *instance = [[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil][3];
    instance.frame = CGRectMake(0, 0, kWidth, 100);
    instance.noteTF = [[UITextView alloc]initWithFrame:CGRectMake(Space, Space, kWidth- Space*2, 100-Space*2)];
    [instance.contentView addSubview:instance.noteTF];
    instance.noteTF.placeholder = @"请详细描述您的需求";
    instance.noteTF.placeholderColor = LightFontColor;

    instance.noteTF.keyboardType = UIKeyboardTypeDefault;
    [ZZLimitInputManager limitInputView:instance.noteTF maxLength:120];
    instance.noteTF.font = [UIFont systemFontOfSize:14];
    instance.noteTF.textColor = FontColor;
    instance.noteTF.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return instance;
}

- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 43, kWidth, 0)];
        _bubbleView.isDefaultSelect = NO;
        /**允许点击 */
        _bubbleView.canTouch=YES;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=YES;
        _bubbleView.signalTagColor=MJRefreshColor(242, 242, 242);

    }
    
    return _bubbleView;
    
}

- (GBTagListView *)sexBubbleView{
    
    if (!_sexBubbleView) {
        
        _sexBubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 43, kWidth, 0)];
        /**允许点击 */
        _sexBubbleView.canTouch=YES;
        _sexBubbleView.isDefaultSelect = YES;
        /**控制是否是单选模式 */
        _sexBubbleView.isSingleSelect=YES;
        _sexBubbleView.signalTagColor=MJRefreshColor(242, 242, 242);
        _sexBubbleView.selectedIndex = selectedIndex;
    }
    
    return _sexBubbleView;
    
}

- (void)setTagAry:(NSArray *)tagAry{
    [_bubbleView removeFromSuperview];
    [self.contentView addSubview:self.bubbleView];
    
    __weak typeof(self) weakSelf = self;
    [_bubbleView setDidselectItemBlock:^(NSArray *arr) {
        //        //            更改数据
            [weakSelf.delegate chooseServiceAry:arr];

    }];
    
    [self.bubbleView setTagWithTagArray:tagAry];
    _cellHeight = _bubbleView.frame.size.height;
    
}

-(void)setSextagAry:(NSArray *)sextagAry{
    
    [_sexBubbleView removeFromSuperview];
    [self.contentView addSubview:self.sexBubbleView];
    __weak typeof(self) weakSelf = self;
    [_sexBubbleView setDidselectItemBlock:^(NSArray *arr) {
        
        if (!arr.count) {
            return ;
        }
        
        //            更改数据
        if ([arr[0] isEqualToString:@"女"]) {
            self->selectedIndex = 0;
            [weakSelf.delegate chooseSex:0];
            
        }else if([arr[0] isEqualToString:@"男"]){
            self->selectedIndex = 1;
            [weakSelf.delegate chooseSex:1];
            
        }

    }];
    [self.sexBubbleView setTagWithTagArray:sextagAry];
    _cellHeight = _sexBubbleView.frame.size.height;
}

- (void)setSelectedAry:(NSMutableArray *)selectedAry{
    _selectedAry = selectedAry;
    
    [self.collectionView reloadData];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_selectedAry.count == 4) {
        return _selectedAry.count;
    }
    
    return _selectedAry.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    
    if (_selectedAry.count == 0) {
        cell.imageView.image = [UIImage imageNamed:@"添加"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
        return cell;
    }
    
    if (indexPath.row == _selectedAry.count) {
        cell.imageView.image = [UIImage imageNamed:@"添加"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedAry[indexPath.row];
        cell.asset = _selectedAsset[indexPath.row];
        cell.deleteBtn.hidden = NO;
        cell.gifLable.hidden = YES;
    }
    
//    if (_type == 0) {
//        self.countLab.text = [NSString stringWithFormat:@"上传您的照片或者想要造型的照片(%lu/4)",(unsigned long)_selectedAry.count];
//    }else{
//        self.countLab.text = [NSString stringWithFormat:@"上传您给客户的参考照片(%lu/4)",(unsigned long)_selectedAry.count];
//    }
    
    if (self.stateStr.length) {
        self.countLab.text = [NSString stringWithFormat:@"%@(%lu/4)",self.stateStr,(unsigned long)_selectedAry.count];
    }
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark- 删除照片
- (void)deleteBtnClik:(UIButton *)sender {
    
    [self.delegate chooseDelPic:sender.tag];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedAry.count) {
//               调相册
        [self.delegate chooseAddPic];
    }else{
        
        [self.delegate chooseLookPic:indexPath.row];
        
    }
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}


@end
