//
//  PurchaseTableViewCell.m
//  QuizBattle
//
//  Created by GBS-mac on 9/19/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "PurchaseTableViewCell.h"

@implementation PurchaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndSelectedButton:(NSString*)selectedButton
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.contentView.backgroundColor=[UIColor clearColor];
        self.picImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.contentView.frame.size.width-120,37)];
        //self.picImageView.image=[UIImage imageNamed:@"life_buy1_en.png"];
        [self.contentView addSubview:self.picImageView];
        self.buyButton=[[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-120, 0,45,29)];
        [self.buyButton setBackgroundImage:[UIImage imageNamed:@"buy_btn.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.buyButton];
        
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
