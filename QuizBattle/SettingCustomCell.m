//
//  SettingCustomCell.m
//  QuizBattle
//
//  Created by GLB-254 on 9/1/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "SettingCustomCell.h"

@implementation SettingCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 48.5)];
        self.topView.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.topView];
        self.iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 29, 29)];
        [self.topView addSubview:self.iconImg];

        self.messageLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200 ,30)];
        self.messageLable.font = [UIFont fontWithName:@"Arial" size:14];
        self.messageLable.textColor = [UIColor blackColor];
        self.messageLable.backgroundColor = [UIColor clearColor];
        self.messageLable.numberOfLines=0;
        [self.topView addSubview:self.messageLable];
        self.aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(240, 5, 150, 40)] ;
        self.aSwitch.onImage=[UIImage imageNamed:@"on.png"];
        
        
        [self.topView addSubview:self.aSwitch];
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
