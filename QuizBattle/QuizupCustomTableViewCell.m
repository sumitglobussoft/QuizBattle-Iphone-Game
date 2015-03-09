//
//  QuizupCustomTableViewCell.m
//  QuizupCustomTableView
//
//  Created by GBS-ios on 10/21/14.
//  Copyright (c) 2014 Globussoft. All rights reserved.
//

#import "QuizupCustomTableViewCell.h"
#import "ViewController.h"


@implementation QuizupCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(20, 2, 280, 48.5)];
        self.containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_bg_dropdown.png"]];
        [self.contentView addSubview:self.containerView];
        self.containerView.layer.masksToBounds = NO;
        self.containerView.layer.shadowRadius = 10.0f;
        self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.containerView.layer.shadowOffset = CGSizeMake(0.0f,10.0f);
        self.containerView.layer.shadowOpacity = 0.02f;
        self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.containerView.bounds].CGPath;
        //-----
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        self.iconImageView.backgroundColor = [UIColor clearColor];
        [self.containerView addSubview:self.iconImageView];
        //--------------
        self.titleLabel = [self initializeLabel:self.titleLabel];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.titleLabel.frame = CGRectMake(40, 5, 230, 25);
        [self.containerView addSubview:self.titleLabel];
        //-----------------
        self.descriptionLabel = [self initializeLabel:self.descriptionLabel];
        self.descriptionLabel.font = [UIFont systemFontOfSize:10];
        self.descriptionLabel.textColor = [UIColor lightGrayColor];
        self.descriptionLabel.frame = CGRectMake(40, 28, 230, 20);
        [self.containerView addSubview:self.descriptionLabel];
        //-------------------------
        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(30, 48, self.containerView.frame.size.width-60, 85)];
        self.menuView.hidden = YES;
        self.menuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_icons.png"]];
        [self.contentView insertSubview:self.menuView atIndex:0];
        
        self.menuView.layer.opacity = 0.0;
        self.menuView.layer.cornerRadius=3;
        self.menuView.clipsToBounds=YES;
        self.playNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playNowButton.frame = CGRectMake(10, 20, 60, 50);
        [self.playNowButton setBackgroundImage:[UIImage imageNamed:@"playnow.png"] forState:UIControlStateNormal];
        //[self.playNowButton addTarget:self action:@selector(playNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:self.playNowButton];
        
        UILabel *lblPlay = [[UILabel alloc] initWithFrame:CGRectMake(1, 30, self.playNowButton.frame.size.width-2, 15)];
        lblPlay.text=[ViewController languageSelectedStringForKey:@"Play Now!"];
        lblPlay.font=[UIFont systemFontOfSize:10];
        lblPlay.textAlignment=NSTextAlignmentCenter;
        lblPlay.textColor=[UIColor whiteColor];
        [self.playNowButton addSubview:lblPlay];
        
        self.challengeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.challengeButton.frame = CGRectMake(70, 20, 60, 50);
        [self.challengeButton setBackgroundImage:[UIImage imageNamed:@"challenge.png"] forState:UIControlStateNormal];
        //[self.challengeButton addTarget:self action:@selector(challengeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:self.challengeButton];
        
        UILabel *lblChallenge = [[UILabel alloc] initWithFrame:CGRectMake(1, 30, self.challengeButton.frame.size.width-2, 15)];
        lblChallenge.text=[ViewController languageSelectedStringForKey:@"Challenge"];
        lblChallenge.font=[UIFont systemFontOfSize:10];
        lblChallenge.textColor=[UIColor whiteColor];
        lblChallenge.textAlignment=NSTextAlignmentCenter;
        [self.challengeButton addSubview:lblChallenge];
        
        self.rankingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rankingButton.frame = CGRectMake(130, 20, 60, 50);
        [self.rankingButton setBackgroundImage:[UIImage imageNamed:@"ranking.png"] forState:UIControlStateNormal];
        //[self.rankingButton addTarget:self action:@selector(rankingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:self.rankingButton];
        
        UILabel *lblRanking = [[UILabel alloc] initWithFrame:CGRectMake(1, 30, self.rankingButton.frame.size.width-2, 15)];
        lblRanking.text=[ViewController languageSelectedStringForKey:@"Rankings"];
        lblRanking.font=[UIFont systemFontOfSize:10];
        lblRanking.textColor=[UIColor whiteColor];
        lblRanking.textAlignment=NSTextAlignmentCenter;
        [self.rankingButton addSubview:lblRanking];
        
        self.discussionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.discussionButton.frame = CGRectMake(190, 20, 60, 50);
        [self.discussionButton setBackgroundImage:[UIImage imageNamed:@"disscussion.png"] forState:UIControlStateNormal];
        //[self.discussionButton addTarget:self action:@selector(discussionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.menuView addSubview:self.discussionButton];
        
        UILabel *lblDisscussion = [[UILabel alloc] initWithFrame:CGRectMake(1, 30, self.discussionButton.frame.size.width-2, 15)];
        lblDisscussion.text=[ViewController languageSelectedStringForKey:@"Discussions"];
        lblDisscussion.font=[UIFont systemFontOfSize:10];
        lblDisscussion.textColor=[UIColor whiteColor];
        lblDisscussion.textAlignment=NSTextAlignmentCenter;
        [self.discussionButton addSubview:lblDisscussion];
         
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

-(UILabel *)initializeLabel:(UILabel *)label{
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    return label;
}
@end
