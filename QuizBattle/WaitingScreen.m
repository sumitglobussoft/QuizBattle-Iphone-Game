//
//  WaitingScreen.m
//  QuizBattle
//
//  Created by GLB-254 on 1/31/15.
//  Copyright (c) 2015 GLB-254. All rights reserved.
//

#import "WaitingScreen.h"
#import "SingletonClass.h"
@implementation WaitingScreen

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView*)screenForChallengeWaiting
{

UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-30, 80, 60, 60)];
imageVUser.image=[SingletonClass sharedSingleton].imageUser;
imageVUser.layer.cornerRadius=30;
imageVUser.clipsToBounds=YES;
[self addSubview:imageVUser];

UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 150,self.window.bounds.size.width, 50)];
lblName.font=[UIFont boldSystemFontOfSize:15];
lblName.textColor=[UIColor blackColor];
lblName.text=[SingletonClass sharedSingleton].strUserName;
lblName.textAlignment=NSTextAlignmentCenter;
[self addSubview:lblName];

UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(0, lblName.frame.origin.y+20, self.window.frame.size.width, 50)];
gradeName.font=[UIFont boldSystemFontOfSize:15];
gradeName.textColor=[UIColor blackColor];
gradeName.text=[SingletonClass sharedSingleton].userRank;
gradeName.textAlignment=NSTextAlignmentCenter;
[self addSubview:gradeName];
UIImageView * clockImage=[[UIImageView alloc]initWithFrame:CGRectMake(140,280, 50, 100)];
clockImage.image=[UIImage imageNamed:@"mobileImg.png"];
[self addSubview:clockImage];
    return self;
}
@end
