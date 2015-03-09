//
//  MessageCustomCell.m
//  WooSuiteApp
//
//  Created by Sumit Ghosh on 21/10/13.
//  Copyright (c) 2013 Globussoft 1. All rights reserved.
//

#import "MessageCustomCell.h"
#import "ViewController.h"
#import "GameViewController.h"
#import "SingletonClass.h"
#import "AppDelegate.h"
#import "CreateDiscussionViewController.h"
#import "FriendsViewController.h"
#import "GamePLayMethods.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
@implementation MessageCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.mutDict = [[NSMutableDictionary alloc]init];
      //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(categoryPickedForChallenge:) name:@"challengeFromTopic" object:nil];
        countTime=0;
        if([reuseIdentifier isEqualToString:@"Setting"])
        {
            self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width-30, 48.5)];
            self.topView.backgroundColor=[UIColor whiteColor];
            self.topView.userInteractionEnabled=YES;
            [self.contentView addSubview:self.topView];
            self.iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
            
            [self.topView addSubview:self.iconImg];
            
            self.messageLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200 ,30)];
            self.messageLable.font = [UIFont fontWithName:@"Arial" size:14];
            self.messageLable.textColor = [UIColor blackColor];
            self.messageLable.backgroundColor = [UIColor clearColor];
            self.messageLable.numberOfLines=0;
            [self.topView addSubview:self.messageLable];
           
            self.aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(240, 5, 150, 40)];
            
//            if (self.aSwitch.tag==0 || self.aSwitch.tag==2) {
//                [self.aSwitch setOn:YES];
//            }
            
            [self.topView addSubview:self.aSwitch];
        }
        //pick topics
        if ([reuseIdentifier isEqualToString:@"ChooseTopic"]) {
            self.topView = [[UIImageView alloc] init];
           // self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_topc_bg.png"]];
            self.topView.image=[UIImage imageNamed:@"blank_topc_bg.png"];
            self.topView.userInteractionEnabled=YES;

            [self.contentView addSubview:self.topView];
            
                     //   [self.topView addSubview:self.pickCategoryButton];
            self.messageLable = [[UILabel alloc]init];
            self.messageLable.font = [UIFont fontWithName:@"Arial-Bold" size:20];
            self.messageLable.textColor=[UIColor blackColor];
            [self.topView addSubview:self.messageLable];
            
            self.lblDescription=[[UILabel alloc]init];
            self.lblDescription.font = [UIFont fontWithName:@"Arial" size:12];
            self.lblDescription.textColor = [UIColor lightGrayColor];
            [self.topView addSubview:self.lblDescription];
            self.iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 29, 29)];
            
            [self.topView addSubview:self.iconImg];
        }
        //pick topics end
        
        //end setting
        if ([reuseIdentifier isEqualToString:@"QuizBattle Cell"])
        {
            self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width-30,46)];
           
            self.topView.image=[UIImage imageNamed:@"blank_topc_bg.png"];
            self.topView.userInteractionEnabled=YES;

            [self.contentView addSubview:self.topView];
                   [self.topView addSubview:self.challengeFriendButton];
            //-------add button
            self.addFriendButton=[UIButton buttonWithType:UIButtonTypeCustom];
            self.addFriendButton.frame=CGRectMake(self.topView.frame.size.width-80, 10, 60, 25);
            self.addFriendButton.titleLabel.font=[UIFont systemFontOfSize:16];
            [self.addFriendButton setTitle:[ViewController languageSelectedStringForKey:@"Add"] forState:UIControlStateNormal];
            [self.addFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.addFriendButton setBackgroundImage:[UIImage imageNamed: @"challenge_btn.png"] forState:UIControlStateNormal];
            [self.addFriendButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
            [self.topView addSubview:self.addFriendButton];
            //--
            self.challengeFriendButton =[UIButton buttonWithType:UIButtonTypeCustom];
            self.challengeFriendButton.frame=CGRectMake(self.topView.frame.size.width-80, 10, 60, 25);
            [self.challengeFriendButton setTitle:@"도전" forState:UIControlStateNormal];
            self.challengeFriendButton.titleLabel.font=[UIFont boldSystemFontOfSize:10];
            
            [self.challengeFriendButton setTitleColor:[UIColor colorWithRed:(CGFloat)27/255 green:(CGFloat)210/255 blue:(CGFloat)130/255 alpha:1] forState:UIControlStateNormal];
            [self.challengeFriendButton setBackgroundImage:[UIImage imageNamed: @"challenge_btn.png"] forState:UIControlStateNormal];
            

            self.messageLable = [[UILabel alloc]init];
            self.messageLable.font = [UIFont fontWithName:@"Arial-Bold" size:20];
            self.messageLable.textColor=[UIColor blackColor];
            [self.topView addSubview:self.messageLable];
            
            self.lblDescription=[[UILabel alloc]init];
            self.lblDescription.font = [UIFont fontWithName:@"Arial" size:12];
            self.lblDescription.textColor = [UIColor lightGrayColor];
            [self.topView addSubview:self.lblDescription];
            self.iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
            self.iconImg.layer.cornerRadius=15;
            [self.topView addSubview:self.iconImg];
        }
        if([reuseIdentifier isEqualToString:@"History"])
        {
            self.topView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 48.5)];
            self.topView.image=[UIImage imageNamed:@"blank_topic_bg.png"];
            self.topView.userInteractionEnabled=YES;
            
            self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, 260, 85)];
             self.buttonView.hidden = YES;
            [self.contentView addSubview:self.topView];
            
            self.menuView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 40, 260, 75)];
            self.menuView.hidden = YES;
            self.menuView.image=[UIImage imageNamed:@"btn_bg.png"];
            self.menuView.layer.cornerRadius=3;
            self.menuView.clipsToBounds=YES;
            self.menuView.userInteractionEnabled=YES;
            [self.contentView insertSubview:self.menuView belowSubview:self.topView];

           
            
            self.messageLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200 ,30)];
            self.messageLable.font = [UIFont fontWithName:@"Arial" size:14];
            self.messageLable.textColor = [UIColor blackColor];
            self.messageLable.backgroundColor = [UIColor clearColor];
            self.messageLable.numberOfLines=0;
            [self.topView addSubview:self.messageLable];
            
            self.buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 48.5, self.contentView.frame.size.width, 100)];
            self.buttonView.backgroundColor=[UIColor whiteColor];
            self.buttonView.hidden = YES;
            self.buttonView.layer.cornerRadius=3;
            self.buttonView.clipsToBounds=YES;
            //rematch button
            self.btnRematch=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 120, 25)];
            self.btnRematch.backgroundColor=[UIColor whiteColor];
            self.btnRematch.layer.borderWidth=1;
            [self.btnRematch setBackgroundImage:[UIImage imageNamed:@"rematch_btnHistory.png"] forState:UIControlStateNormal];
            [self.btnRematch setTitle:[ViewController languageSelectedStringForKey:@"Rematch"] forState:UIControlStateNormal];
            [self.btnRematch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.btnRematch.titleLabel.font=[UIFont systemFontOfSize:10];
            [self.btnRematch setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,80)];
            [self.buttonView addSubview:self.btnRematch];
            //play
            ///
            self.btnPlay=[[UIButton alloc]initWithFrame:CGRectMake(10, 40,120, 25)];
            self.btnPlay.backgroundColor=[UIColor whiteColor];
            self.btnPlay.layer.borderWidth=1;
            [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"play_now_btnHistory.png"] forState:UIControlStateNormal];
            [self.btnPlay setTitle:@"지금 플레이하기" forState:UIControlStateNormal];
            [self.btnPlay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.btnPlay.titleLabel.font=[UIFont systemFontOfSize:10];
            [self.btnPlay setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,40)];
            [self.buttonView addSubview:self.btnPlay];
            
            ////
            self.btnRanking=[[UIButton alloc]initWithFrame:CGRectMake(10, 70, 120, 25)];
            self.btnRanking.backgroundColor=[UIColor whiteColor];
            self.btnRanking.layer.borderWidth=1;
            [self.btnRanking setBackgroundImage:[UIImage imageNamed:@"ranking_btnHistory.png"] forState:UIControlStateNormal];
            [self.btnRanking setTitle:@"순위" forState:UIControlStateNormal];
            [self.btnRanking setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.btnRanking.titleLabel.font=[UIFont systemFontOfSize:10];
            [self.btnRanking setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,80)];
            [self.buttonView addSubview:self.btnRanking];

            //ranking
                //
            self.btnResult=[[UIButton alloc]initWithFrame:CGRectMake(150, 10, 120, 25)];
            self.btnResult.backgroundColor=[UIColor whiteColor];
            self.btnResult.layer.borderWidth=1;
            [self.btnResult setBackgroundImage:[UIImage imageNamed:@"result_btnHistory.png"] forState:UIControlStateNormal];
            [self.btnResult setTitle:[ViewController languageSelectedStringForKey:@"Result"] forState:UIControlStateNormal];
            [self.btnResult setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.btnResult.titleLabel.font=[UIFont systemFontOfSize:10];
            [self.btnResult setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,80)];
            [self.buttonView addSubview:self.btnResult];
            //
            self.btnChallenge=[[UIButton alloc]initWithFrame:CGRectMake(150, 40, 120, 25)];
            self.btnChallenge.backgroundColor=[UIColor whiteColor];
            self.btnChallenge.layer.borderWidth=1;
            [self.btnChallenge setBackgroundImage:[UIImage imageNamed:@"challenge_btnHistory.png"] forState:UIControlStateNormal];
            [self.btnChallenge setTitle:[ViewController languageSelectedStringForKey:@"Challenge"] forState:UIControlStateNormal];
            [self.btnChallenge setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.btnChallenge.titleLabel.font=[UIFont systemFontOfSize:10];
            [self.btnChallenge setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,60)];
            [self.buttonView addSubview:self.btnChallenge];

            //
                       //challenge
                       //discussion
            //
            self.btnDiscussion=[[UIButton alloc]initWithFrame:CGRectMake(150, 70, 120, 25)];
            self.btnDiscussion.backgroundColor=[UIColor whiteColor];
            self.btnDiscussion.layer.borderWidth=1;
            [self.btnDiscussion setBackgroundImage:[UIImage imageNamed:@"discussion_btnHistory.png"] forState:UIControlStateNormal];
            [self.btnDiscussion setTitle:[ViewController languageSelectedStringForKey:@"Discussion"]forState:UIControlStateNormal];
            [self.btnDiscussion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.btnDiscussion.titleLabel.font=[UIFont systemFontOfSize:10];
            [self.btnDiscussion setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,80)];
            [self.buttonView addSubview:self.btnDiscussion];

            //
            
            self.iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 29, 29)];
            [self.topView addSubview:self.iconImg];
            self.playerImageIcon=[[UIImageView alloc]initWithFrame:CGRectMake(240, 10, 29, 29)];
            [self.topView addSubview:self.playerImageIcon];
            self.lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(60, 32, 260, 10)];
            self.lblDescription.font=[UIFont fontWithName:@"Arial" size:14];
            self.lblDescription.textColor=[UIColor lightGrayColor];
            self.lblDescription.backgroundColor=[UIColor clearColor];
            [self.topView addSubview:self.lblDescription];
            self.buttonView.backgroundColor=[UIColor colorWithRed:(CGFloat)74/255 green:(CGFloat)192/255 blue:(CGFloat)180/255 alpha:1];
            [self.contentView insertSubview:self.buttonView belowSubview:self.topView];
        }
        //Chat conversation end
        
        //history end
        //Sir code
        if([reuseIdentifier isEqualToString:@"Cell Identifier"])
        {
            xAxis=0;
            self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width-20, 48.5)];
            self.topView.image = [UIImage imageNamed:@"blank_topic_bg.png"];
            self.topView.userInteractionEnabled=YES;
            [self.contentView addSubview:self.topView];
            
            self.picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 30, self.topView.frame.size.height-18)];
            [self.topView addSubview:self.picImageView];
            self.messageLable = [[UILabel alloc]init];
            self.messageLable.font = [UIFont fontWithName:@"Arial" size:14];
            self.messageLable.textColor = [UIColor blackColor];
            self.messageLable.backgroundColor = [UIColor clearColor];
            self.messageLable.numberOfLines=0;
            [self.topView addSubview:self.messageLable];
            self.lblDescription=[[UILabel alloc]init];
            self.lblDescription.font = [UIFont fontWithName:@"Arial" size:10];
            self.lblDescription.numberOfLines=3;
            [self.topView addSubview:self.lblDescription];
            //----------------------
            self.batteryImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.topView.frame.size.width-50, 5, 21, 40)];
            [self.topView addSubview:self.batteryImage];
            //----------------
            
            self.gradeName=[[UILabel alloc]initWithFrame:CGRectMake(self.topView.frame.size.width-90, 5, 30, 40)];
            self.gradeName.font=[UIFont boldSystemFontOfSize:10];
            self.messageLable.textColor = [UIColor blackColor];
            [self.topView addSubview:self.gradeName];

            //------------------
            self.menuView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 40, 260, 75)];
            self.menuView.hidden = YES;
            self.menuView.image=[UIImage imageNamed:@"bg_iconsNew.png"];
            //[self.menuView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_icons.png"]]];
            self.menuView.layer.cornerRadius=3;
            self.menuView.clipsToBounds=YES;
            self.menuView.userInteractionEnabled=YES;
            [self.contentView insertSubview:self.menuView belowSubview:self.topView];
            
            self.playNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.playNowButton.frame = CGRectMake(5, 20, 62, 40);
            self.playNowButton.layer.cornerRadius=4;
            self.playNowButton.clipsToBounds=YES;
            [self.playNowButton setBackgroundImage:[UIImage imageNamed:@"play_now.png"] forState:UIControlStateNormal];
          //  [self.playNowButton addTarget:self action:@selector(playNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.menuView addSubview:self.playNowButton];
            
            UILabel *lblPlay = [[UILabel alloc] initWithFrame:CGRectMake(1, 23, self.playNowButton.frame.size.width-2, 15)];
            lblPlay.text=[ViewController languageSelectedStringForKey:@"Play Now!"];
            lblPlay.font=[UIFont systemFontOfSize:9];
            lblPlay.textAlignment=NSTextAlignmentCenter;
            lblPlay.textColor=[UIColor whiteColor];
            [self.playNowButton addSubview:lblPlay];
            
            self.challengeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.challengeButton.frame = CGRectMake(68, 20, 62, 40);
            [self.challengeButton setBackgroundImage:[UIImage imageNamed:@"challenge.png"] forState:UIControlStateNormal];
            self.challengeButton.layer.cornerRadius=4;
             self.challengeButton.clipsToBounds=YES;
//            [self.challengeButton addTarget:self action:@selector(categoryPicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.menuView addSubview:self.challengeButton];
            
            UILabel *lblChallenge = [[UILabel alloc] initWithFrame:CGRectMake(1, 23, self.challengeButton.frame.size.width-2, 15)];
            lblChallenge.text=[ViewController languageSelectedStringForKey:@"Challenge"];
            lblChallenge.font=[UIFont systemFontOfSize:9];
            lblChallenge.textColor=[UIColor whiteColor];
            lblChallenge.textAlignment=NSTextAlignmentCenter;
            [self.challengeButton addSubview:lblChallenge];
            
            self.rankingButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rankingButton.frame = CGRectMake(131, 20, 62,40);
            [self.rankingButton setBackgroundImage:[UIImage imageNamed:@"ranking.png"] forState:UIControlStateNormal];
             self.rankingButton.layer.cornerRadius=4;
             self.rankingButton.clipsToBounds=YES;
            //[self.rankingButton addTarget:self action:@selector(rankingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.menuView addSubview:self.rankingButton];
            
            UILabel *lblRanking = [[UILabel alloc] initWithFrame:CGRectMake(1, 23, self.rankingButton.frame.size.width-2, 15)];
            lblRanking.text=[ViewController languageSelectedStringForKey:@"Rankings"];
            lblRanking.font=[UIFont systemFontOfSize:9];
            lblRanking.textColor=[UIColor whiteColor];
            lblRanking.textAlignment=NSTextAlignmentCenter;
            [self.rankingButton addSubview:lblRanking];
            
            self.discussionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.discussionButton.frame = CGRectMake(194, 20, 62,40);
            self.discussionButton.layer.cornerRadius=4;
            self.discussionButton.clipsToBounds=YES;
            [self.discussionButton setBackgroundImage:[UIImage imageNamed:@"discussion_newBtn.png"] forState:UIControlStateNormal];
            [self.menuView addSubview:self.discussionButton];
            
            UILabel *lblDisscussion = [[UILabel alloc] initWithFrame:CGRectMake(1, 23, self.discussionButton.frame.size.width-2, 15)];
            lblDisscussion.text=[ViewController languageSelectedStringForKey:@"Discussions"];
            lblDisscussion.font=[UIFont systemFontOfSize:9];
            lblDisscussion.textColor=[UIColor whiteColor];
            lblDisscussion.textAlignment=NSTextAlignmentCenter;
            [self.discussionButton addSubview:lblDisscussion];
        }
        else if ([reuseIdentifier isEqualToString:@"MessageViewCell"])
        {
            self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width-30, 48.5)];
           // self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_bg_sidearrow.png"]];
             self.topView.image=[UIImage imageNamed:@"topic_bg_sidearrow.png"];
            self.topView.userInteractionEnabled=YES;

            [self.contentView addSubview:self.topView];
            self.messageLable = [[UILabel alloc]init];
            self.messageLable.font = [UIFont fontWithName:@"Arial" size:14];
            self.messageLable.textColor = [UIColor blackColor];
            self.messageLable.backgroundColor = [UIColor clearColor];
            self.messageLable.numberOfLines=1;
            [self.topView addSubview:self.messageLable];
            self.lblDescription=[[UILabel alloc]init];
            self.lblDescription.font=[UIFont fontWithName:@"Arial" size:14];
            self.lblDescription.textColor=[UIColor lightGrayColor];
            self.lblDescription.backgroundColor=[UIColor clearColor];
            [self.topView addSubview:self.lblDescription];
            self.playerImageIcon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 29, 29)];
            [self.topView addSubview:self.playerImageIcon];
            self.message = [[UILabel alloc]init];
            self.message.font = [UIFont fontWithName:@"Arial" size:10];
            self.message.textColor = [UIColor blackColor];
            self.message.backgroundColor = [UIColor clearColor];
            self.message.numberOfLines=1;
            [self.topView addSubview:self.message];
        }
        else if ([reuseIdentifier isEqualToString:@"Discussion"])
        {
            self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width-30, 48.5)];
            //self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_bg_sidearrow.png"]];
            self.topView.image=[UIImage imageNamed:@"blank_topic_bg.png"];
            self.topView.userInteractionEnabled=YES;
            [self.contentView addSubview:self.topView];
            self.messageLable = [[UILabel alloc]init];
            self.messageLable.frame=CGRectMake(60, 33, 260, 10);
            self.messageLable.font = [UIFont fontWithName:@"Arial" size:10];
            self.messageLable.textColor = [UIColor lightGrayColor];
            self.messageLable.backgroundColor = [UIColor clearColor];
            self.messageLable.numberOfLines=1;
            [self.topView addSubview:self.messageLable];
            self.iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 29, 29)];
            [self.topView addSubview:self.iconImg];
            
            self.lblDescription=[[UILabel alloc]init];
            self.lblDescription.frame=CGRectMake(60, 18, 260, 15);
            self.lblDescription.font=[UIFont fontWithName:@"Arial" size:10];
            self.lblDescription.textColor=[UIColor lightGrayColor];
            self.lblDescription.backgroundColor=[UIColor clearColor];
            [self.topView addSubview:self.lblDescription];
            
            self.message = [[UILabel alloc]init];
            self.message.font = [UIFont fontWithName:@"Arial" size:14];
            self.message.textColor = [UIColor blackColor];
            self.message.frame=CGRectMake(60, 2, 260, 20);
            self.message.numberOfLines=1;
            [self.topView addSubview:self.message];
        }
        else if ([reuseIdentifier isEqualToString:@"quizplus"])
        {
            self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 48.5)];
            NSLog(@"%f",self.topView.frame.size.width);
            self.topView.image=[UIImage imageNamed:@"blank_topc_bg.png"];
            self.topView.userInteractionEnabled=YES;
          //  self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_topc_bg.png"]];
            [self.contentView addSubview:self.topView];
            
            self.messageLable = [[UILabel alloc]init];
            self.messageLable.font = [UIFont fontWithName:@"Arial" size:16];
            self.messageLable.textColor = [UIColor blackColor];
            self.messageLable.backgroundColor = [UIColor clearColor];
            self.messageLable.numberOfLines=1;
            [self.topView addSubview:self.messageLable];
            self.iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 29, 29)];
            [self.topView addSubview:self.iconImg];
            self.lblDescription=[[UILabel alloc]init];
            self.lblDescription.frame=CGRectMake(190, 10, 80, 20);
            self.lblDescription.font=[UIFont fontWithName:@"Arial" size:16];
            self.lblDescription.textColor=[UIColor blackColor];
            self.lblDescription.backgroundColor=[UIColor clearColor];
            [self.topView addSubview:self.lblDescription];
            self.btnAddQues=[UIButton buttonWithType:UIButtonTypeCustom];
            self.btnAddQues.frame=CGRectMake(240, 5, 30, 30);
            
            [self.btnAddQues setBackgroundImage:[UIImage imageNamed:@"add_q.png"] forState:UIControlStateNormal];
            [self.topView addSubview:self.btnAddQues];
        }
        
        ////////////////////Custom Cell Friend Request/////////////////////////////
        if ([reuseIdentifier isEqualToString:@"RequestCell"]) {
            self.topView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 48.5)];
            self.topView.image=[UIImage imageNamed:@"blank_topic_bg.png"];
            self.topView.backgroundColor=[UIColor whiteColor];
            self.topView.userInteractionEnabled=YES;
            [self.contentView addSubview:self.topView];
            self.lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(55, 29, 260, 10)];
            self.lblDescription.font=[UIFont fontWithName:@"Arial" size:12];
            self.lblDescription.textColor=[UIColor lightGrayColor];
            self.lblDescription.backgroundColor=[UIColor clearColor];
            [self.topView addSubview:self.lblDescription];
            
            self.messageLable = [[UILabel alloc]initWithFrame:CGRectMake(55, 3, 200 ,30)];
            self.messageLable.font = [UIFont boldSystemFontOfSize:14];
            self.messageLable.textColor = [UIColor blackColor];
            self.messageLable.backgroundColor = [UIColor clearColor];
            self.messageLable.numberOfLines=0;
            [self.topView addSubview:self.messageLable];
            
            self.iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 29, 29)];
            
            [self.topView addSubview:self.iconImg];
            self.buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 48.5, self.contentView.frame.size.width, 60)];
            self.buttonView.backgroundColor=[UIColor whiteColor];
            self.buttonView.hidden = YES;
            self.buttonView.layer.cornerRadius=3;
            self.buttonView.clipsToBounds=YES;
            self.btnAccept=[[UIButton alloc]initWithFrame:CGRectMake(10, 15, 120, 25)];
            self.btnAccept.backgroundColor=[UIColor whiteColor];
            [self.buttonView addSubview:self.btnAccept];
            
            UIImageView * btnAcceptimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
            btnAcceptimg.image=[UIImage imageNamed:@"accept.png"];
            [self.btnAccept addSubview:btnAcceptimg];
            UILabel * acceptLabel=[[UILabel alloc]initWithFrame:CGRectMake(5.0, 0, 60,25)];
            acceptLabel.font=[UIFont systemFontOfSize:12];
            acceptLabel.text=[ViewController languageSelectedStringForKey:@"Accept"];
            acceptLabel.textAlignment=NSTextAlignmentLeft;
            
            [self.btnAccept addSubview:acceptLabel];
            
            
            self.btnReject=[[UIButton alloc]initWithFrame:CGRectMake(150, 15, 120, 25)];
            [self.btnReject setTitle:[ViewController languageSelectedStringForKey:@"Reject"] forState:UIControlStateNormal];
            [self.btnReject.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [self.btnReject setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.btnReject.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            //            UILabel *rejectLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.btnReject.frame.origin.x+5, 5, 60,25)];
            //           rejectLabel.font=[UIFont systemFontOfSize:12];
            //            rejectLabel.text=@"Accept";
            //            rejectLabel.textColor=[UIColor blackColor];
            //            rejectLabel.textAlignment=NSTextAlignmentLeft;
            //
            //            [self.btnReject addSubview:rejectLabel];
            [self.btnReject setBackgroundImage:[UIImage imageNamed:@"reject_btn.png"] forState:UIControlStateNormal];
            [self.btnReject setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            
            [self.buttonView addSubview:self.btnReject];
            
            [self.contentView insertSubview:self.buttonView belowSubview:self.topView];
            
            
        }
        
        
    }
    return self;
}

#pragma mark ===============================
#pragma mark UI Button Action Methods
#pragma mark ===============================

-(void)playNowButtonAction:(id)sender {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playNowButtonAction:) name:@"PlayAnother" object:nil];
//    [self displaySelectFriendsUI];
//    
//    [self performSelector:@selector(selectionFriendMethod) withObject:nil afterDelay:2];

    GamePLayMethods * obj=[[GamePLayMethods alloc]init];
    obj.gameDelegate=self;
    [obj playNowButtonAction];
}

-(void)rankingBtnAction:(id)sender {
    
    PFObject *object = [PFObject objectWithClassName:@"DiscussionComment"];
    object[@"Comment"]=@"I like it.";
    object[@"DiscussionId"]=[SingletonClass sharedSingleton].discussionObjectId;
    object[@"UserId"]=[SingletonClass sharedSingleton].objectId;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [object saveEventually:^(BOOL succeed, NSError *error){
            
            if (succeed) {
                NSLog(@"Save to Parse");
                BOOL checkInternet =  [ViewController networkCheck];
                
                if (checkInternet) {
                   
                    NSLog(@"Message send...");
                }
                else{
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                }
            }
            if (error) {
                NSLog(@"Error to Save == %@",error.localizedDescription);
            }
        }];
    });
}
-(void)cancelBtnAction:(id)sender
{
    
    if ([timerForbotPlayer isValid]) {
        [timerForbotPlayer invalidate];
      //  timer=nil;
    }
    self.backgroundView.hidden=YES;
    self.upperView.hidden=YES;
}


#pragma mark ==========================
#pragma mark Friend Selection Methods
#pragma mark ==========================

-(void) displaySelectFriendsUI
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playNowButtonAction:) name:@"PlayAnotherGameOver" object:nil];
//Playing Status Set True
    
    
    arrImages = [NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png",@"9.png",@"10.png",@"11.png",@"12.png",@"13.png",@"14.png",@"15.png",@"16.png",@"17.png",@"18.png",@"19.png",@"20.png", nil];
    countImage =0;
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:appdelegate.window.bounds];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [appdelegate.window addSubview:self.backgroundView];
    }
    
    if (!self.upperView) {
        self.upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appdelegate.window.bounds.size.width, 0)];
        self.upperView.backgroundColor = [UIColor whiteColor];
        [appdelegate.window addSubview:self.upperView];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self.upperView.frame = CGRectMake(0, 0, appdelegate.window.bounds.size.width, 200);
    }];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(appdelegate.window.bounds.size.width/2-100, 150, 200, 50)];
    lblName.font=[UIFont boldSystemFontOfSize:15];
    lblName.textColor=[UIColor redColor];
    lblName.text=[SingletonClass sharedSingleton].strUserName;
    lblName.textAlignment=NSTextAlignmentCenter;
    [self.upperView addSubview:lblName];
    
    UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.bounds.size.width/2-30, 90, 70, 70)];
    
    imageVUser.image=[SingletonClass sharedSingleton].imageUser;
    imageVUser.layer.cornerRadius=35;
    imageVUser.clipsToBounds=YES;
    [self.upperView addSubview:imageVUser];
    
    //vasant
    UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+20, 200, 50)];
    //    gradeName.font=[UIFont boldSystemFontOfSize:15];
    gradeName.textColor=[UIColor blackColor];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    gradeName.textAlignment=NSTextAlignmentCenter;
    [self.upperView addSubview:gradeName];
    
    UILabel *vsLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageVUser.frame.origin.x,gradeName.frame.origin.y+30, 70, 70)];
    vsLabel.textAlignment=NSTextAlignmentCenter;
    vsLabel.text=[ViewController languageSelectedStringForKey:@"Vs"];
    vsLabel.textColor=[UIColor brownColor];
    vsLabel.font=[UIFont boldSystemFontOfSize:28];
    [self.backgroundView addSubview:vsLabel];
    UILabel *searchLabel=[[UILabel alloc]initWithFrame:CGRectMake(appdelegate.window.frame.size.width/2-100, scrollView.frame.origin.y+70, 260, 60)];
    searchLabel.textColor=[UIColor blackColor];
    searchLabel.text=[ViewController languageSelectedStringForKey:@"Searching for a Perfect Opponent"];
    searchLabel.textAlignment=NSTextAlignmentLeft;
    [self.backgroundView addSubview:searchLabel];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 280,appdelegate.window.bounds.size.width,100)];
    scrollView.delegate = self;
    //    [scrollView setBackgroundColor:[UIColor redColor]];
    scrollView.pagingEnabled = YES;
    [scrollView setScrollEnabled:YES];
    [scrollView setAlwaysBounceVertical:NO];
    
    NSInteger numberOfViews = 25;
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * appdelegate.window.bounds.size.width;
        image = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,appdelegate.window.bounds.size.width,60)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"persons-random-preamble.png"]];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.backgroundColor=[UIColor lightGrayColor];
        [scrollView addSubview:image];
    }
    //set the scroll view content size
    scrollView.contentSize = CGSizeMake(appdelegate.window.bounds.size.width *numberOfViews,100);
    //add the scrollview to this view
    [self.backgroundView addSubview:scrollView];
    
    lblPlayerSelection = [[UILabel alloc] initWithFrame:CGRectMake(50, scrollView.frame.origin.y+70, self.backgroundView.frame.size.width-100, 60)];
    lblPlayerSelection.textAlignment=NSTextAlignmentCenter;
    lblPlayerSelection.numberOfLines=3;
    lblPlayerSelection.lineBreakMode=NSLineBreakByCharWrapping;
    lblPlayerSelection.textColor=[UIColor redColor];
    lblPlayerSelection.font=[UIFont boldSystemFontOfSize:20];
    lblPlayerSelection.text =[ViewController languageSelectedStringForKey:@"Selecting right oponent for you."];
    [self.backgroundView addSubview:lblPlayerSelection];
    
    cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(130, 420, 70, 30);
    
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [cancelBtn setTitle:[ViewController languageSelectedStringForKey:@"Cancel"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:(CGFloat)27/255 green:(CGFloat)210/255 blue:(CGFloat)130/255 alpha:1] forState:UIControlStateNormal];
    cancelBtn.layer.borderWidth=1;
    cancelBtn.layer.borderColor=[UIColor blackColor].CGColor;
    cancelBtn.clipsToBounds=YES;
    //    [cancelBtn setImage:[UIImage imageNamed: @"challenge_btn.png"] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:cancelBtn];
    
    timerForbotPlayer = [NSTimer scheduledTimerWithTimeInterval:1 target: self selector:@selector(animateUSerSelection) userInfo: nil repeats:YES];
    
    [timerForbotPlayer fire];
}

-(void)selectionFriendMethod
{
    NSLog(@"Popularity Score =-=%@",[SingletonClass sharedSingleton].popularityScore);
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet)
    {
        
        [NSThread detachNewThreadSelector:@selector(requestForGame) toTarget:self withObject:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
    }
}

-(void)animateUSerSelection {
    
    countTime++;
    NSLog(@"Bot Player Timer %d",countTime);
    AppDelegate *delagate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    
    UIImageView *centerImage = [[UIImageView alloc]init];
    centerImage.frame=CGRectMake(delagate.window.frame.size.width/2-40, 270, 70, 70);
    //    NSLog(@"Image =-=- %@",[arrImages objectAtIndex:countImage]);
    NSString *strImage = [arrImages objectAtIndex:countImage];
    
    centerImage.image=[UIImage imageNamed:strImage];
    
    [self.backgroundView addSubview:centerImage];
    
    countImage++;
    
    if (countImage>=8) {
        countImage=0;
    }
    [scrollView setContentOffset:CGPointMake(xAxis, 0) animated:YES];
    xAxis=xAxis+30;
    
    if (countTime>15) {
        
        if ([timerForbotPlayer isValid]) {
            [timerForbotPlayer invalidate];
            //timerForbotPlayerimer = nil;
            
            [self botPlayerDetails];
        }
    }
}
-(void)displaySelectedPlyerName {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        lblPlayerSelection.text=[NSString stringWithFormat:@"Your opponent is %@", [SingletonClass sharedSingleton].strSecPlayerName];
    });
}
-(void)connectedFriend:(NSNotification *) notification {
   
    [self playGame];
     [self deleteRequest];
}
-(void)deleteRequest
{
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
    PFQuery * queryForDelete=[PFQuery queryWithClassName:@"GameRequest"];
    [queryForDelete whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
    NSArray * temp=[queryForDelete findObjects];
            if([temp count]>0)
            {
    PFObject * objDelete=[temp objectAtIndex:0];
    [objDelete deleteInBackground];
            }
        }
    });
}

#pragma mark ========================================
#pragma mark Bot Players Methods
#pragma mark ========================================

-(void)botPlayerDetails {
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
    
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            
            BOOL checkInternet =  [ViewController networkCheck];
            
            if (checkInternet) {
                
                [SingletonClass sharedSingleton].checkBotUser=YES;
                
                PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                [query whereKey:@"Type" equalTo:@"bot"];
                NSArray *arrDetails = [query findObjects];
                
                NSLog(@"Arry Details --= %@",arrDetails);
                
                int randomPlayer = arc4random()%arrDetails.count;
                
                PFObject *object = [arrDetails objectAtIndex:randomPlayer];
                [SingletonClass sharedSingleton].secondPlayerObjid = object.objectId;
                
                [query whereKey:@"objectId" equalTo: [SingletonClass sharedSingleton].secondPlayerObjid];
                NSArray *arrDetails1 = [query findObjects];
                [mutDict setObject:arrDetails1 forKey:@"oponentPlayerDetail"];
                NSLog(@"Questions Id Bot-==- %@",[SingletonClass sharedSingleton].strQuestionsId);
                [mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
                
                if (arrDetails.count>0) {
                    
                    NSDictionary *dict = [arrDetails1 objectAtIndex:0];
                    
                    NSLog(@"Second player dict details --==- %@",dict);
                   
                    [SingletonClass sharedSingleton].strSecPlayerName = [dict objectForKey:@"name"];
                    [SingletonClass sharedSingleton].strSecPlayerRank=[dict objectForKey:@"Rank"];
                    [self displaySelectedPlyerName];
                    PFFile  *strImage = [dict objectForKey:@"userimage"];
                    
                    NSData *imageData = [strImage getData];
                    UIImage *image1 = [UIImage imageWithData:imageData];
                    
                    [SingletonClass sharedSingleton].imageSecondPlayer = image1;
                    cancelBtn.userInteractionEnabled=NO;
                    [NSThread detachNewThreadSelector:@selector(setFlagForGameRequest) toTarget:self withObject:nil];
                }
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                });
            }
        }
    });
   
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [timerForbotPlayer invalidate];
       // timer=nil;
        
        [self performSelector:@selector(goToGamePlayForBot:) withObject:mutDict
                   afterDelay:5];
    });
}

-(void)goToGamePlayForBot :(NSMutableDictionary *)dict {
    
    [self gameDetailsAnotherGame:dict];
     [self performSelector:@selector(startGameForBot) withObject:dict afterDelay:4];
    if([SingletonClass sharedSingleton].roomId)
    {
        [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId];
        
    }
}
-(void)startGameForBot
{
    [self deleteRequest];
 //[[NSNotificationCenter defaultCenter]postNotificationName:@"startgame" object:nil];
}

#pragma mark ========================================
#pragma mark Extra Methods
#pragma mark ========================================

-(void)increasePopularityOfSubCat {
    
    NSNumber *popularity = [SingletonClass sharedSingleton].popularityScore;
    int value = [popularity intValue];
    popularity=[NSNumber numberWithInt:value+1];
    NSLog(@"Popularity=--= %@",popularity);
    
    PFQuery *query = [PFQuery queryWithClassName:@"SubCategory"];
    
    [query whereKey:@"SubCategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
    
    NSString *strObjId = [SingletonClass sharedSingleton].objectId;
    
    //    PFObject *object =  [query getObjectWithId:strObjId];
    //     NSLog(@"Object id %@",[object objectId]);
    [query getObjectInBackgroundWithId:strObjId block:^(PFObject *object, NSError *error){
        
        object[@"PopularityScore"]=popularity;
        [object saveInBackground];
    }];
    /*
     PFObject *object = [PFObject objectWithClassName:@"SubCategory"];
     object[@"PopularityScore"]=popularity;
     
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [object saveEventually:^(BOOL succeed, NSError *error){
     
     if (succeed) {
     NSLog(@"Save to Parse");
     
     //                [self retriveFriendsScore:level andScore:score];
     }
     if (error) {
     NSLog(@"Error to Save == %@",error.localizedDescription);
     }
     }];
     });
     */
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)sendMessage:(id)sender {
    
    PFObject *object = [PFObject objectWithClassName:@"DiscussionComment"];
    object[@"Comment"]=@"I like it.";
    object[@"DiscussionId"]=[SingletonClass sharedSingleton].discussionObjectId;
    object[@"UserId"]=[SingletonClass sharedSingleton].objectId;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [object saveEventually:^(BOOL succeed, NSError *error){
            
            if (succeed) {
                NSLog(@"Save to Parse");
                BOOL checkInternet =  [ViewController networkCheck];
                
                if (checkInternet) {
                    //                    NSString * objectId = [object objectId];
                    //
                    //                    [SingletonClass sharedSingleton].discussionObjectId=objectId;
                }
                else{
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                }
            }
            if (error) {
                NSLog(@"Error to Save == %@",error.localizedDescription);
            }
        }];
    });
}

#pragma mark ========================================
#pragma mark Play Game and Request for Game Methods
#pragma mark ========================================

-(void)requestForGame {
    
    PFObject *object = [PFObject objectWithClassName:@"GameRequest"];
    object[@"UserId"]=[SingletonClass sharedSingleton].objectId;
    NSLog(@"Object ID -=---- %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"objectid"]);
    
    object[@"SubCategoryId"]=[SingletonClass sharedSingleton].selectedSubCat;
    object[@"GameComplete"]=@NO;
    object[@"DeviceToken"]=[SingletonClass sharedSingleton].installationId;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [object saveEventually:^(BOOL succeed, NSError *error){
            
            if (succeed) {
                NSLog(@"Save to Parse");
                BOOL checkInternet =  [ViewController networkCheck];
                
                if (checkInternet) {
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectedFriend:) name:@"selFriend" object:nil];
                    [NSThread detachNewThreadSelector:@selector(requestForObjectId) toTarget:self withObject:nil];
                }
                else{
                    [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
                }
            }
            if (error) {
                NSLog(@"Error to Save == %@",error.localizedDescription);
            }
        }];
    });
}

-(void)requestForObjectId {
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameRequest"];
    
    [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
    [query whereKey:@"DeviceToken" equalTo:[SingletonClass sharedSingleton].installationId];
    [query whereKey:@"GameComplete" equalTo:@NO];
    [query whereKey:@"SubCategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
    
    NSArray *arrObjects = [query findObjects];
    if(arrObjects.count<1){
        NSLog(@"Data not found");
        return;
    }
    PFObject * myObject = [arrObjects objectAtIndex:0];
    
    strObjectId = [myObject objectId];
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
        
        [self requestToCloudForPlayer];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
    }
}

-(void)requestToCloudForPlayer
{
    NSNumber *level=[NSNumber numberWithInt:2];
    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
    [PFCloud callFunctionInBackground:@"gamestart"
                       withParameters:@{@"subcategoryid": subCatID,@"userid": [SingletonClass sharedSingleton].objectId
                                        ,@"uniqueid":[SingletonClass sharedSingleton].installationId ,@"objectid":strObjectId,@"level":level}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                NSLog(@"Response Result -==- %@", result);
                                        if (![SingletonClass sharedSingleton].strQuestionsId.length>0)
                                        {
                                            [SingletonClass sharedSingleton].strQuestionsId= result;
                                        }
                                        NSLog(@"Connect to cloud");
                                    }
                                    else
                                    {
                                        NSLog(@"Error in calling CloudCode %@",error);
                                    }
                                }];
}
        
-(void)playGame {
    
        dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            
            BOOL checkInternet =  [ViewController networkCheck];
            
            if (checkInternet) {
                
                PFQuery *query = [PFUser query];
                [query whereKey:@"objectId" equalTo: [SingletonClass sharedSingleton].secondPlayerObjid];
                
                NSArray *arrDetails = [query findObjects];
                
                NSLog(@"Arry Details --= %@",arrDetails);
                [SingletonClass sharedSingleton].secondPLayerDetail=arrDetails;
                [self.mutDict setObject:arrDetails forKey:@"oponentPlayerDetail"];
                NSLog(@"Questions Id -==- %@",[SingletonClass sharedSingleton].strQuestionsId);
                [self.mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
                
                if (arrDetails.count>0) {
                    
                    NSDictionary *dict = [arrDetails objectAtIndex:0];
                    
                    NSLog(@"Second player dict details --==- %@",dict);
                    [SingletonClass sharedSingleton].strSecPlayerName = [dict objectForKey:@"name"];
                    [self displaySelectedPlyerName];
                    
                    PFFile  *strImage = [dict objectForKey:@"userimage"];
                    
                    NSData *imageData = [strImage getData];
                    UIImage *image1 = [UIImage imageWithData:imageData];
                    
                    [SingletonClass sharedSingleton].imageSecondPlayer = image1;
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
                });
            }
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [timerForbotPlayer invalidate];
      //  timer=nil;
        
      //  [self performSelector:@selector(goToGamePlayView:) withObject:self.mutDict afterDelay:6];
    });
   
}

-(void)gameDetailsAnotherGame:(NSDictionary*)details {
    
    if ([self.gameDelegate respondsToSelector:@selector(gameDetails:)]) {
        
        self.backgroundView.hidden=YES;
        self.upperView.hidden=YES;
        [self.gameDelegate gameDetails:details];
    }
}
/*-(void)goToGamePlayView:(NSDictionary*)details {
    
    if ([self.gameDelegate respondsToSelector:@selector(gameDetails:)]) {
        
        self.backgroundView.hidden=YES;
        self.upperView.hidden=YES;
        [self.gameDelegate gameDetails:details];
    }
}*/

#pragma mark===============================
#pragma mark Challenge UI and methods
#pragma mark===============================

-(void)challengeStartGameAction :(id)sender
{
    self.startButtonChallenge=TRUE;
     AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.frame.size.width/2-10, appdelegate.window.frame.size.height/2-30, 30, 50)];
    [appdelegate.window addSubview:imageVAnim];
    
    NSArray *arrAnimImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"burning_rocket_01.png"],
                              [UIImage imageNamed:@"burning_rocket_02.png"],
                              [UIImage imageNamed:@"burning_rocket_03.png"],
                              [UIImage imageNamed:@"burning_rocket_04.png"],
                              [UIImage imageNamed:@"burning_rocket_05.png"],
                              [UIImage imageNamed:@"burning_rocket_06.png"],
                              [UIImage imageNamed:@"burning_rocket_07.png"],
                              [UIImage imageNamed:@"burning_rocket_08.png"], nil];
    
    imageVAnim.animationImages=arrAnimImages;
    imageVAnim.animationDuration=0.5;
    imageVAnim.animationRepeatCount=0;
    
    [imageVAnim startAnimating];
   
    
    dispatch_async(dispatch_get_main_queue(),^(void) {
        
        [self performSelector:@selector(loadOponnentPlayerInChallenge) withObject:nil afterDelay:4];
    });
}
-(void)loadOponnentPlayerInChallenge {
    
    [imageVAnim stopAnimating];
    UIImageView *imageVsecPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, self.window.bounds.size.width, self.window.bounds.size.height-250)];
    imageVsecPlayer.backgroundColor=[UIColor lightGrayColor];
    [self.topViewChallenge addSubview:imageVsecPlayer];
    
    UIImageView *profileImgSecPlayer=[[UIImageView alloc]initWithFrame:CGRectMake(20, self.window.bounds.size.height-180, 80, 80)];
    profileImgSecPlayer.layer.cornerRadius=40;
    profileImgSecPlayer.layer.borderWidth=2.0f;
    profileImgSecPlayer.layer.borderColor=[UIColor redColor].CGColor;
    profileImgSecPlayer.layer.masksToBounds=YES;
    profileImgSecPlayer.backgroundColor=[UIColor yellowColor];
    profileImgSecPlayer.image=[SingletonClass sharedSingleton].imageSecondPlayer;
    [self.topViewChallenge addSubview:profileImgSecPlayer];
    
    UILabel * playerName=[[UILabel alloc]initWithFrame:CGRectMake(105,self.window.bounds.size.height-170,210,20)];
    playerName.textAlignment=NSTextAlignmentLeft;
    playerName.text=[SingletonClass sharedSingleton].strSecPlayerName;
    playerName.textColor=[UIColor whiteColor];
    [self.topViewChallenge addSubview:playerName];
    
    UILabel * gradeName=[[UILabel alloc]initWithFrame:CGRectMake(105,self.window.bounds.size.height-140,100, 20)];
    gradeName.text=[SingletonClass sharedSingleton].strSecPlayerRank;
    gradeName.textColor=[UIColor whiteColor];
    [self.topViewChallenge addSubview:gradeName];
    
    UILabel * countryName=[[UILabel alloc]initWithFrame:CGRectMake(160, self.window.bounds.size.height-100, 120, 60)];
    countryName.numberOfLines=0;
    countryName.text=[NSString stringWithFormat:@"에서 재생\n%@",[SingletonClass sharedSingleton].strCountry];;
    countryName.textColor=[UIColor whiteColor];
    [self.topViewChallenge addSubview:countryName];
    
    [self performSelector:@selector(goToGamePlayViewChallenge:) withObject:[SingletonClass sharedSingleton].strQuestionsId afterDelay:2];
    
}

-(void)fetchApponentDetailChallenge
{
   // [SingletonClass sharedSingleton].secondPlayerObjid = @"nFvTMPhDiZ";
    
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            PFQuery *query = [PFUser query];
            
            [query whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].secondPlayerObjid];
            
            NSArray *arrObjectsChallenge = [query findObjects];
            [SingletonClass sharedSingleton].secondPLayerDetail=arrObjectsChallenge;
            NSLog(@"Array object Challenge Details -==- %@",arrObjectsChallenge);
             [self.mutDict setObject:arrObjectsChallenge forKey:@"oponentPlayerDetail"];
            
            NSDictionary *dict = [arrObjectsChallenge objectAtIndex:0];
            
            NSString *strName = [dict objectForKey:@"name"];
            [SingletonClass sharedSingleton].strSecPlayerName = strName;
            NSString *rank = [dict objectForKey:@"Rank"];
            [SingletonClass sharedSingleton].strSecPlayerRank=rank;
            NSString *strInstallationId = [dict objectForKey:@"deviceID"];
            [SingletonClass sharedSingleton].secondPlayerInstallationId = strInstallationId;
            PFFile  *strImage = [dict objectForKey:@"userimage"];
            
            NSData *imageData = [strImage getData];
            UIImage *imageSecPlayer = [UIImage imageWithData:imageData];
            [SingletonClass sharedSingleton].imageSecondPlayer=imageSecPlayer;
            dispatch_async(dispatch_get_main_queue(),^(void) {
                
                [self performSelector:@selector(fetchQuesForChallengeFromCloud) withObject:nil afterDelay:2];
            });
            
        }
    });
    //sukhmeet for challenge
   
}
-(void)fetchQuesForChallengeFromCloud
{
//    [SingletonClass sharedSingleton].selectedSubCat=[NSNumber numberWithInt:101];
//    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
//    [SingletonClass sharedSingleton].secondPlayerObjid=@"nFvTMPhDiZ";
//    [SingletonClass sharedSingleton].secondPlayerInstallationId=@"b540f711-432a-4edf-b0a7-e45babd8ae4d";
    NSLog(@"%@second %@",[SingletonClass sharedSingleton].secondPlayerObjid,[SingletonClass sharedSingleton].secondPlayerInstallationId);
    
        [PFCloud callFunctionInBackground:@"Challange"
                       withParameters:@{@"subcategoryid":@101,@"subcategoryname":[SingletonClass sharedSingleton].strSelectedSubCat,@"userid": [SingletonClass sharedSingleton].objectId,@"uniqueid":[SingletonClass sharedSingleton].installationId ,@"opppnent":[SingletonClass sharedSingleton].secondPlayerObjid, @"uniqueid1":[SingletonClass sharedSingleton].secondPlayerInstallationId
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        
                                        //Room Create Main Player
                                        time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
                                        NSString *dateStr = [NSString stringWithFormat:@"%ld",unixTime];
                                        [[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];
                                        
                                        [SingletonClass sharedSingleton].strQuestionsId= result;
                                        [self.mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
                                        
                                        
                                        if(self.startButtonChallenge)
                                        {
                                            
                                            [self performSelector:@selector(goToGamePlayViewChallenge:) withObject:[SingletonClass sharedSingleton].strQuestionsId afterDelay:2];
                                        }

                                        
                                        else
                                        {
                [SingletonClass sharedSingleton].mainPlayerChallenge=true;
                                                            //-------------
                                        NSLog(@"Response Result -==- %@", result);
                                            
                                            
                                            //Notification for challenge sukhmeet
        //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playGameChallenge:) name:@"gameUiChallenge" object:nil];
                                            

                                    }
                                        
                                        NSLog(@"Connect to cloud");
                                    }
                                }];
    
}
-(void)playGameChallenge:(NSNotification*)notify
{
    //[self performSelector:@selector(goToGamePlayView:) withObject:self.mutDict
            //   afterDelay:0];

    id details = [notify object];
    if ([details isKindOfClass:[NSDictionary class]])
    {
        
    }
    
}
-(void)goToGamePlayViewChallenge:(NSDictionary*)details {
    
    if ([self.gameDelegate respondsToSelector:@selector(gameDetailsForChallenge:)]) {
        
        self.topViewChallenge.hidden=YES;
        [self.gameDelegate gameDetailsForChallenge:details];
    }
}

-(void)setFlagForGameRequest
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameRequest"];
    [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
    [query orderByAscending:@"createdAt"];
    NSArray *arrObjects = [query findObjects];
    
    PFObject * myObject = [arrObjects lastObject];
    myObject[@"GameComplete"]=@YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [myObject saveEventually:^(BOOL succeed, NSError *error){
            
            if (succeed) {
                NSLog(@"Save to Parse");
                BOOL checkInternet =  [ViewController networkCheck];
                
                if (checkInternet) {
                    NSLog(@"Flag Value change in parse.");
                }
                else{
                    [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
                }
            }
        }];
    });
}
-(void)endGame:(id)sender
{
    [self.topViewChallenge removeFromSuperview];
}
@end
