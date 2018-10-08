//
//  PickAwardsTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PickAwardsTableViewCell.h"


@interface PickAwardsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *pickBtnOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgOne;
@property (weak, nonatomic) IBOutlet UIButton *pointOne;
@property (weak, nonatomic) IBOutlet UIButton *lineOne;
@property (weak, nonatomic) IBOutlet UIButton *pickBtnTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgTwo;
@property (weak, nonatomic) IBOutlet UIButton *pointTwo;
@property (weak, nonatomic) IBOutlet UIButton *linrTwo;
@property (weak, nonatomic) IBOutlet UIButton *pickBtnThree;
@property (weak, nonatomic) IBOutlet UIImageView *imgThree;

@property (weak, nonatomic) IBOutlet UIButton *pointThree;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *isPay;

@property (weak, nonatomic) IBOutlet UILabel *timeRecord;
@property (weak, nonatomic) IBOutlet UILabel *recordDetail;



@end

@implementation PickAwardsTableViewCell

+(instancetype)activityThreeTableViewCellPick{
    
    PickAwardsTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PickAwardsTableViewCell" owner:self options:nil][0];
    return cell;
    
}

+(instancetype)activityThreeTableViewCellFriend{
    
    PickAwardsTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PickAwardsTableViewCell" owner:self options:nil][1];
    return cell;
    
}

+(instancetype)activityThreeTableViewCellRecord{
    
    PickAwardsTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PickAwardsTableViewCell" owner:self options:nil][2];
    return cell;
    
}

+(instancetype)activityThreeTableViewCellChance{
    
    PickAwardsTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PickAwardsTableViewCell" owner:self options:nil][3];
    return cell;
    
}

- (void)setRecordDic:(NSDictionary *)recordDic{
    
    self.timeRecord.text = recordDic[@"create_time"];
    self.recordDetail.text = recordDic[@"name"];
    
}

- (void)setDataAry:(NSArray *)dataAry{
    _dataAry = dataAry;
    
    [_imgOne sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[dataAry[0] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
    [_imgTwo sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[dataAry[1] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
    [_imgThree sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[dataAry[2] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
    
    if ([[dataAry[0] objectForKey:@"is_status"] integerValue] == 1) {
        _pickBtnOne.enabled = NO;
        _pointOne.selected = YES;
    }else if ([[dataAry[0] objectForKey:@"is_status"] integerValue] == 2){
        _pickBtnOne.selected = YES;
        _pointOne.selected = YES;
    }else{
        _pickBtnOne.selected = NO;
    }
    
    if ([[dataAry[1] objectForKey:@"is_status"] integerValue] == 1) {
        _pickBtnTwo.enabled = NO;
        _pointTwo.selected = YES;
        _lineOne.selected = YES;
    }else if ([[dataAry[1] objectForKey:@"is_status"] integerValue] == 2){
        _pickBtnTwo.selected = YES;
        _pointTwo.selected = YES;
        _lineOne.selected = YES;
    }else{
        _pickBtnTwo.selected = NO;
    }
    
    if ([[dataAry[2] objectForKey:@"is_status"] integerValue] == 1) {
        _pickBtnThree.enabled = NO;
        _linrTwo.selected = YES;
        _pointThree.selected = YES;
    }else if ([[dataAry[2] objectForKey:@"is_status"] integerValue] == 2){
        _pickBtnThree.selected = YES;
        _linrTwo.selected = YES;
        _pointThree.selected = YES;
    }else{
        _pickBtnThree.selected = NO;
    }
    

}

- (void)setFriendsDic:(NSDictionary *)friendsDic{
    
    [_img sd_setImageWithURL:[NSURL urlWithNoBlankDataString:friendsDic[@"image"]] placeholderImage:[UIImage imageNamed:@"test2"]];
    _name.text = friendsDic[@"nickname"];
    _time.text = friendsDic[@"create_time"];
    
    if ([friendsDic[@"status"] integerValue] == 1) {
        _isPay.text = @"已消费";
        _isPay.textColor = [UIColor lightGrayColor];
    }else{
        _isPay.text = @"未消费";
        _isPay.textColor = MainColor;
    }
    
}

- (IBAction)takeAction:(UIButton *)sender {
    
    if ([[_dataAry[sender.tag] objectForKey:@"is_status"] integerValue] == 2) {
        
        NSString *coupon = [_dataAry[sender.tag] objectForKey:@"coupon_id"];
        
        [self.delegate takeAwards:coupon];
    }
    
    
}


@end
