//
//  Rect.m
//  DemoPie
//
//  Created by GLB-254 on 10/6/14.
//  Copyright (c) 2014 globussoft. All rights reserved.
//

#import "Rect1.h"
#import "ViewController.h"
@implementation Rect1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        sum=0;
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    displayXp=[[NSArray alloc]initWithObjects:@"Gained Xp",@"Completed Xp",@"Remaining XP", nil];
    [self conditionForScore:[[self.points objectAtIndex:0] intValue]];
    [self pieGraph];
    
//    CGMutablePathRef path = CGPathCreateMutable();
//        CGPathMoveToPoint(path, nil, 50, 50);
//        CGPathAddArc(path, nil, 0, 0, 10, 0, 360, NO);
//   CGPathAddLineToPoint(path, nil, 10, 10);
////        CGPathAddArc(path, nil, centrWithOffset.x, centrWithOffset.y, maxRadius, angleEnd, angleStart, YES);
//       CGPathCloseSubpath(path);
    
}
-(void)subcategoryUI:(int)i
{
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-130, 100+(i)*25, 20, 20)];
    img.backgroundColor=[self diffColorProfile:i];
    NSLog(@"images name profile %@",self.subcategoryId);
        NSString *catID =[NSString stringWithFormat:@"%@profile",[self.subcategoryId objectAtIndex:i-1]];
   img.image=[UIImage imageNamed:catID];
    [self addSubview:img];
    UILabel * subCategory=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-100, 95+(i)*25, 80,20)];
    subCategory.text=[self.subcategoryName objectAtIndex:i-1];
    subCategory.font=[UIFont boldSystemFontOfSize:10];
    subCategory.textColor=[UIColor whiteColor];
    [self addSubview:subCategory];
    
}
- (void)pieGraph
{
    CGFloat pre=0;
    //Pie for Game over
    if(self.flagProfile)
    {
        for(int i=1;i<=1;i++)
        {
            
            CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            //  CGContextSaveGState(ctx);
            CGContextBeginPath(ctx);
            CGContextAddArc(ctx, center.x, center.y, 60.0,(pre+270)*M_PI/180,(270+[self degree:i])*M_PI/180, 0);
            
            NSLog(@"pre%f",[self degree:i]);
            
            CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:(CGFloat)133/255 green:(CGFloat)87/255 blue:(CGFloat)224/255 alpha:1].CGColor);
            CGContextSetLineWidth(ctx, 30.0);
            CGContextStrokePath(ctx);
            
            CGContextAddArc(ctx, center.x, center.y, 60.0,(pre+270)*M_PI/180,(270+[self degree:i])*M_PI/180, 1);
            
            NSLog(@"pre%f",[self degree:i]);
            
            CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextSetLineWidth(ctx, 30.0);
            CGContextStrokePath(ctx);
            
            CGFloat posDegree=([self degree:i]/2.0);
            
            CGFloat positionLabel1=(360-[self degree:i]);
            if(positionLabel1 >180)
            {
                positionLabel1=180;
            }
            else{
                positionLabel1=positionLabel1/2+180;
            }
            UILabel *level=[[UILabel alloc]initWithFrame:CGRectMake(center.x-37, center.y-30, 80, 50)];
            level.textColor=[UIColor whiteColor];
            level.lineBreakMode = NSLineBreakByWordWrapping;
            level.numberOfLines = 0;
           // NSString * strLevel=[ViewController languageSelectedStringForKey:@"LEVEL"];
            level.text=[NSString stringWithFormat:@"%@\n",gradeNameIngraph];
            level.textAlignment=NSTextAlignmentCenter;
            level.font=[UIFont boldSystemFontOfSize:15];
            [self addSubview:level];
            NSLog(@"Pos degree%f",posDegree);
            CGContextMoveToPoint(ctx, center.x+ 70*cosf(positionLabel1*M_PI/180),center.y+70*sinf(positionLabel1*M_PI/180));
            
            CGContextAddLineToPoint(ctx, center.x+70*cosf(positionLabel1*M_PI/180)-30, center.y+70*sinf(positionLabel1*M_PI/180));
            CGContextSetStrokeColorWithColor(ctx,[UIColor whiteColor].CGColor);
            CGContextSetLineWidth(ctx, 1.0);
            CGContextStrokePath(ctx);
            UILabel *remainingXP=[[UILabel alloc]initWithFrame:CGRectMake( center.x+65*cosf(positionLabel1*M_PI/180)-110, center.y+65*sinf(positionLabel1*M_PI/180), 80, 30)];
            remainingXP.lineBreakMode = NSLineBreakByWordWrapping;
            remainingXP.numberOfLines = 0;
             NSString * remainingXp=[ViewController languageSelectedStringForKey:@"Remaining XP"];
            remainingXP.text=[NSString stringWithFormat:@"%@\n       %d",remainingXp,(int)(totalPoints_GameOver-[[self.points objectAtIndex:0] integerValue])];
            remainingXP.font=[UIFont systemFontOfSize:8];
            remainingXP.textAlignment=NSTextAlignmentCenter;
            remainingXP.textColor=[UIColor whiteColor];
            [self addSubview:remainingXP];
            
            if(posDegree>180)
            {
                posDegree=90;
            }
            CGContextMoveToPoint(ctx, center.x+ 70*cosf((270+posDegree)*M_PI/180),center.y+70*sinf((270+posDegree)*M_PI/180));
            CGContextAddLineToPoint(ctx, center.x+70*cosf((270+posDegree)*M_PI/180)+30, center.y+70*sinf((270+posDegree)*M_PI/180));
            UILabel *completedXP=[[UILabel alloc]initWithFrame:CGRectMake( center.x+60*cosf((270+posDegree)*M_PI/180)+40, center.y+60*sinf((270+posDegree)*M_PI/180)-10, 80, 30)];
            
            completedXP.textColor=[UIColor colorWithRed:(CGFloat)133/255 green:(CGFloat)87/255 blue:(CGFloat)224/255 alpha:1];
            completedXP.lineBreakMode = NSLineBreakByWordWrapping;
            completedXP.numberOfLines = 0;
            NSString * completedXp=[ViewController languageSelectedStringForKey:@"Completed XP"];
            completedXP.text=[NSString stringWithFormat:@"%@\n       %ld",completedXp,(long)[[self.points objectAtIndex:0] integerValue]];
            completedXP.font=[UIFont systemFontOfSize:8];
            completedXP.textAlignment=NSTextAlignmentLeft;
            [self addSubview:completedXP];
            CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:(CGFloat)133/255 green:(CGFloat)87/255 blue:(CGFloat)224/255 alpha:1].CGColor);
            CGContextSetLineWidth(ctx, 1.0);
            CGContextStrokePath(ctx);
                      CGContextClosePath(ctx);
        }
    }//if ended for pie
    //Pie for Profile
    else
    {
        NSLog(@"Self total score points %@",self.totalScoreOfAllPoints);
        if([self.totalScoreOfAllPoints intValue]>0)
        {
            [self profilePieGraph];
        }
        
    }//else end
    
}
-(void)profilePieGraph
{
    //total score label
    UILabel * totalScore=[[UILabel alloc]initWithFrame:CGRectMake(20, 10,self.bounds.size.width-20, 80)];
    totalScore.text=@"총 점수";
    totalScore.textAlignment=NSTextAlignmentCenter;
    totalScore.font=[UIFont boldSystemFontOfSize:20];
    totalScore.textColor=[UIColor whiteColor];
    [self addSubview:totalScore];
    //
    
    [self calculateOtherTotalScore];
    CGFloat pre=0;
    int j;
    if([self.totalScore count]<=5)
    {
        j=[self.totalScore count]-1;
    }
    else
    {
        j=[self.totalScore count];
    }
    for(int i=1;i<=j;i++)
    {
       if(i==[self.totalScore count])
       {
           //if value is 5 only
           if([self degree:i pointsGained:4]==0)
               break;
       }
        CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        //  CGContextSaveGState(ctx);
        CGContextBeginPath(ctx);
        if(i==1)
        {
            CGContextAddArc(ctx, center.x-60, center.y-80, 50.0,(pre)*M_PI/180,(pre+[self degree:i pointsGained:4])*M_PI/180, 0);
        }
        else
        {
            CGContextAddArc(ctx, center.x-60, center.y-80, 50.0,(1+pre)*M_PI/180,(pre+[self degree:i pointsGained:4])*M_PI/180, 0);
        }
        NSLog(@"pre%f",pre+[self degree:i pointsGained:4]);
        CGContextSetStrokeColorWithColor(ctx,[self diffColorProfile:i].CGColor);
        CGContextSetLineWidth(ctx, 30.0);
        CGContextStrokePath(ctx);
        CGContextMoveToPoint(ctx, (center.x-20)+(35)*cosf((pre+[self degree:i pointsGained:4])*M_PI/180)-40,center.y-80+(35)*sinf((pre+[self degree:i pointsGained:4])*M_PI/180));
        CGContextAddLineToPoint(ctx,(center.x-20)+(65)*cosf((pre+[self degree:i pointsGained:4])*M_PI/180)-40,center.y-80+(65)*sinf((pre+[self degree:i pointsGained:4])*M_PI/180));
        CGContextSetLineWidth(ctx, 4.0);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextStrokePath(ctx);
        CGFloat posDegree=(pre+[self degree:i pointsGained:4]/2.0);
        UILabel *scoreCategory=[[UILabel alloc]initWithFrame:CGRectMake((center.x-20)+50*cosf((posDegree)*M_PI/180)-40, center.y-80+50*sinf((posDegree)*M_PI/180)-7, 40, 20)];
        scoreCategory.text=[NSString stringWithFormat:@"%d",[[self.totalScore objectAtIndex:i-1] intValue] ];
        if(i==[self.totalScore count])
        {
           scoreCategory.text=[NSString stringWithFormat:@"%d",[[self.totalScore lastObject] intValue] -(int)sum];
        }
        scoreCategory.textColor=[UIColor whiteColor];
        scoreCategory.textAlignment=NSTextAlignmentLeft;
        scoreCategory.font=[UIFont boldSystemFontOfSize:10];
        [self addSubview:scoreCategory];
        pre=[self degree:i pointsGained:4]+pre;
        NSLog(@"previous degree %f",pre);
        //Showing total
        UILabel * total=[[UILabel alloc]initWithFrame:CGRectMake(center.x-80, center.y-100, 50, 50)];
        total.text=[NSString stringWithFormat:@"%ld",(long)[self.totalScoreOfAllPoints integerValue]];
        total.textAlignment=NSTextAlignmentCenter;
        total.textColor=[UIColor whiteColor];
        total.font=[UIFont boldSystemFontOfSize:40];
        [self addSubview:total];
        CGContextDrawPath( ctx, kCGPathFillStroke);
        CGContextClosePath(ctx);
        //  pre=pre+[self degree:i pointsGained:4];
        [self subcategoryUI:i];
        
    }//for
    
    //to create five More Pie
    //1
    pre=0;
    for(int i=1;i<=3;i++)
    {
        CGFloat gain;
        // start=(270)*M_PI/180;
        // end=pre+200;
        gain=3.6*[[self.winGainStatus objectAtIndex:i-1] floatValue];
//        if(gain==0)
//        {
//            gain=360;
//        }
        NSLog(@"gain in profile graph %@",[self.winGainStatus objectAtIndex:i-1]);
        CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextAddArc(ctx, center.x-90+((i-1)*90), center.y+120, 30.0,(270)*M_PI/180,(270+gain)*M_PI/180, 0);
        CGContextSetStrokeColorWithColor(ctx,[self diffColor:i].CGColor);
        CGContextSetLineWidth(ctx, 15.0);
        CGContextStrokePath(ctx);
        CGContextAddArc(ctx, center.x-90+((i-1)*90), center.y+120, 30.0,(270)*M_PI/180,(270+gain)*M_PI/180, 1);
        CGContextSetStrokeColorWithColor(ctx,[UIColor whiteColor].CGColor);
        CGContextSetLineWidth(ctx, 15.0);
        CGContextStrokePath(ctx);
        //----------------
        UILabel * lblPercent=[[UILabel alloc]init];
        lblPercent.frame=CGRectMake(center.x-130+((i-1)*90), center.y+80,80, 80);
        NSString * strPercent=[NSString stringWithFormat:@"%.2f%%",[[self.winGainStatus objectAtIndex:i-1] floatValue]];
        lblPercent.text=strPercent;
        lblPercent.font=[UIFont systemFontOfSize:10];
        lblPercent.textColor=[UIColor whiteColor];
        lblPercent.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lblPercent];
        //--------------------
       if(gain==0)
        {
            CGContextAddArc(ctx, center.x-90+((i-1)*90), center.y+120, 30.0,(0)*M_PI/180,(360)*M_PI/180, 0);
            CGContextSetStrokeColorWithColor(ctx,[UIColor whiteColor].CGColor);
            CGContextSetLineWidth(ctx, 15.0);
            CGContextStrokePath(ctx);

        }

        
        
        //lable
        
        UILabel * totalScore=[[UILabel alloc]initWithFrame:CGRectMake(center.x-130+((i-1)*90), center.y+20,80, 80)];
        if(i==1)
        {
            totalScore.text=@"승리";
        }
        else if (i==2)
        {
            totalScore.text=@"무승부";
        }
        else if (i==3)
        {
            totalScore.text=@"손실";//@"LOSSES";
        }
        totalScore.textAlignment=NSTextAlignmentCenter;
        totalScore.font=[UIFont boldSystemFontOfSize:15];
        totalScore.textColor=[UIColor whiteColor];
        [self addSubview:totalScore];
        //label
        
    }//for
    //1
    
    
    //Requirement not clear
//    for(int i=1;i<=2;i++)
//    {
//        CGFloat start,end,gain;
//        start=(270)*M_PI/180;
//        end=pre+200;
//        gain=3.6*25;
//        CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        
//        CGContextAddArc(ctx, center.x-60+((i-1)*90), center.y+200, 30.0,(270)*M_PI/180,(270+gain)*M_PI/180, 0);
//        CGContextSetStrokeColorWithColor(ctx,[self diffColor:i].CGColor);
//        CGContextSetLineWidth(ctx, 15.0);
//        CGContextStrokePath(ctx);
//        CGContextAddArc(ctx, center.x-60+((i-1)*90), center.y+200, 30.0,(270)*M_PI/180,(270+gain)*M_PI/180, 1);
//        CGContextSetStrokeColorWithColor(ctx,[UIColor whiteColor].CGColor);
//        CGContextSetLineWidth(ctx, 15.0);
//        CGContextStrokePath(ctx);
//        pre=pre+[self degree:i pointsGained:4];
//        //label--------
//        UILabel * totalScore=[[UILabel alloc]initWithFrame:CGRectMake(center.x-80+((i-1)*90),center.y+100,50, 80)];
//        
//        totalScore.textAlignment=NSTextAlignmentCenter;
//        totalScore.font=[UIFont boldSystemFontOfSize:20];
//        [self addSubview:totalScore];
//        
//        
//        //label------
//        
//        
//    }//for
//    
//    
    

}
-(UIColor*)diffColor:(int)no
{
    UIColor * clr;
    switch (no) {
        case 1:
            clr=[UIColor colorWithRed:(CGFloat)151/255 green:(CGFloat)201/255 blue:(CGFloat)145/255 alpha:1];
            break;
        case 2:
            clr=[UIColor colorWithRed:(CGFloat)191/255 green:(CGFloat)167/255 blue:(CGFloat)238/255 alpha:1];
            break;
            case 3:
            clr=[UIColor colorWithRed:(CGFloat)187/255 green:(CGFloat)39/255 blue:(CGFloat)238/255 alpha:1];
            break;
        default:
            clr=[UIColor blackColor];
    }
    return clr;
}
-(UIColor*)diffColorProfile:(int)no
{
    UIColor * clr;
    switch (no) {
        case 1:
        {
            clr=[UIColor colorWithRed:(CGFloat)225/255 green:(CGFloat)84/255 blue:(CGFloat)84/255 alpha:1];
            break;
        }
        case 2:
        {
            clr=[UIColor colorWithRed:(CGFloat)225/255 green:(CGFloat)129/255 blue:(CGFloat)51/255 alpha:1];
            break;
        }
        case 3:
        {
            clr=[UIColor colorWithRed:(CGFloat)231/255 green:(CGFloat)168/255 blue:(CGFloat)2/255 alpha:1];
            break;
        }
        case 4:
        {
            clr=[UIColor colorWithRed:(CGFloat)2/255 green:(CGFloat)209/255 blue:
               (CGFloat)116/255 alpha:1];
            break;
        }
        case 5:
        {
            clr=[UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)181/255 blue:(CGFloat)217/255 alpha:1];
            break;
        }
        default:
            clr=[UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)135/255 blue:(CGFloat)141/255 alpha:1];
    }
    return clr;
}

-(float)degree:(int)no
{
    float degree=360/totalPoints_GameOver;
    NSInteger gainedPoints,previousPoints;
    gainedPoints=[[self.points objectAtIndex:0] integerValue];
    previousPoints=[[self.points objectAtIndex:1] integerValue];
    NSLog(@"Totsl points gained over %f %ld",totalPoints_GameOver,(long)gainedPoints);
    switch (no) {
        case 1:
            degree=degree*gainedPoints;
            break;
        case 2:
            degree=degree*previousPoints;
            break;
        case 3:
            degree=degree*(totalPoints_GameOver-previousPoints+gainedPoints);
            break;
        case 4:
            degree=80;
    }
    NSLog(@"degree%f",degree);
    return degree;
}

-(float)degree:(int)i pointsGained:(int)points
{
    NSLog(@"Self total score %@",self.totalScore);
    float gap;
    gap=360/[[self.totalScore lastObject] floatValue];
    float degree;
       switch (i) {
        case 1:
           {

            degree=[[self.totalScore objectAtIndex:i-1] floatValue]*gap;
            break;
           }
        case 2:
           {
               
            degree=[[self.totalScore objectAtIndex:i-1] floatValue]*gap;
            break;
           }
        case 3:
           {
               
           degree=[[self.totalScore objectAtIndex:i-1] floatValue]*gap;
            break;
           }
        case 4:
           {
            degree=[[self.totalScore objectAtIndex:i-1] floatValue]*gap;
            break;
           }
        case 5:
           {
            degree=[[self.totalScore objectAtIndex:i-1] floatValue]*gap;
            break;
           }
        default:
           degree=([[self.totalScore lastObject] floatValue]-sum)*gap;
      }
        NSLog(@"Degree %f",degree);
    return degree;
}
-(void)calculateOtherTotalScore
{
    NSLog(@"self total score %@",self.totalScore);
    for(int i=0;i<[self.totalScore count]-1;i++)
    {
        sum=sum+[[self.totalScore objectAtIndex:i] floatValue];
    }
    NSLog(@"sum %f",sum);
}
#pragma mark points condition
-(void)conditionForScore:(int)points
{
    NSString *gradeName;
    if(points<811)
    {
        gradeName=@"베이비";
        totalPoints_GameOver=811;
    }
    else if(points>=811&&points<=1220)
    {
        gradeName=@"초1";
          totalPoints_GameOver=1220;
    }
    else if (points>=1221&&points<=1700)
    {
        gradeName=@"초2";
          totalPoints_GameOver=1700;
    }
    else if (points>=1701&&points<=2250)
    {
        gradeName=@"초3";
          totalPoints_GameOver=2250;
    }
    else if (points>=2251&&points<=2870)
    {
        gradeName=@"초4";
      totalPoints_GameOver=2870;
    }
    else if(points>=2871&&points<=3560)
    {
        gradeName=@"초5";
          totalPoints_GameOver=3560;
    }
    else if(points>=3561&&points<=5151)
    {
        gradeName=@"초6";
          totalPoints_GameOver=5151;
    }
    else if(points>=5151&&points<=7020)
    {
        gradeName=@"중1";
          totalPoints_GameOver=7020;
    }
    else if (points>=7021&&points<=9170)
    {
        gradeName=@"중2";
          totalPoints_GameOver=9170;
    }
    else if (points>=9171&&points<=15770)
    {
        gradeName=@"중3";
          totalPoints_GameOver=15570;
    }
    else if(points>=15771&&points<=24120)
    {
        gradeName=@"고1";
          totalPoints_GameOver=24120;
    }
    else if (points>=24121&&points<=34220)
    {
        gradeName=@"고2";
          totalPoints_GameOver=34220;
    }
    else if (points>=34221&&points<=59670)
    {
        gradeName=@"고3";
          totalPoints_GameOver=59670;
    }
    
    else if(points>=59671&&points<=92120)
    {
        gradeName=@"대1 ";
          totalPoints_GameOver=92120;
    }
    
    else if (points>=92121&&points<=131570)
    {
        gradeName=@"대2";
          totalPoints_GameOver=131570;
    }
    else if (points>=131571&&points<=178020)
    {
        gradeName=@"대3";
          totalPoints_GameOver=178020;
        
    }
    else if (points>=178021&&points<=359370)
    {
        gradeName=@"대4";
          totalPoints_GameOver=359370;
        
    }
    else if(points>=359371&&points<=801620)
    {
        gradeName=@"석사";
          totalPoints_GameOver=801620;
    }
    else if(points>=801621&&points<=1418870)
    {
        gradeName=@"박사";
          totalPoints_GameOver=1418870;
    }
    else if(points>=1418871)
    {
        gradeName=@"퀴즈왕";
          totalPoints_GameOver=points;
    }
    gradeNameIngraph=gradeName;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
