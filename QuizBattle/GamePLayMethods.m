//
//  GamePLayMethods.m
//  QuizBattle
//
//  Created by GLB-254 on 11/28/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "SingletonClass.h"
#import "AppDelegate.h"
#import "GamePLayMethods.h"

@implementation GamePLayMethods

-(void)playNowButtonAction
{
    [self resetAllVariables];
    self.mutDict=[[NSMutableDictionary alloc]init];
    [self displaySelectFriendsUI];
    [self performSelector:@selector(selectionFriendMethod) withObject:nil afterDelay:1];
}
-(void)resetAllVariables
{
    [SingletonClass sharedSingleton].mainPlayer=false;
    [SingletonClass sharedSingleton].secondPlayer=false;
    [SingletonClass sharedSingleton].mainPlayerChallenge=FALSE;
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=FALSE;
    [SingletonClass sharedSingleton].rematchMain=FALSE;
    [SingletonClass sharedSingleton].rematchSecond=FALSE;
    [SingletonClass sharedSingleton].isPlaying=FALSE;
    [SingletonClass sharedSingleton].userLeftRoom=FALSE;
}
-(void) displaySelectFriendsUI
{
    
    //Playing Status Set True
   // [SingletonClass sharedSingleton].isPlaying=TRUE;
    
    arrImages = [NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png",@"9.png",@"10.png",@"11.png",@"12.png",@"13.png",@"14.png",@"15.png",@"16.png",@"17.png",@"18.png",@"19.png",@"20.png", nil];
    countImage =0;
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (!backgroundView) {
        backgroundView = [[UIView alloc] initWithFrame:appdelegate.window.bounds];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [appdelegate.window addSubview:backgroundView];
    }
    
    if (!upperView) {
        upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appdelegate.window.bounds.size.width/2, 0)];
        upperView.backgroundColor = [UIColor whiteColor];
        [backgroundView addSubview:upperView];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        upperView.frame = CGRectMake(0, 0, appdelegate.window.bounds.size.width, 200);
    }];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(appdelegate.window.bounds.size.width/2-100, 150, 200, 50)];
    lblName.font=[UIFont boldSystemFontOfSize:15];
    lblName.textColor=[UIColor blackColor];
    lblName.text=[SingletonClass sharedSingleton].strUserName;
    lblName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:lblName];
    
    UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.bounds.size.width/2-30, 90, 70, 70)];
    
    imageVUser.image=[SingletonClass sharedSingleton].imageUser;
    imageVUser.layer.cornerRadius=35;
    imageVUser.clipsToBounds=YES;
    [upperView addSubview:imageVUser];
    
    
    UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+20, 200, 50)];
    //    gradeName.font=[UIFont boldSystemFontOfSize:15];
    gradeName.textColor=[UIColor blackColor];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    gradeName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:gradeName];
    
    vsLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageVUser.frame.origin.x,gradeName.frame.origin.y+30, 70, 70)];
    vsLabel.textAlignment=NSTextAlignmentCenter;
    vsLabel.text=[ViewController languageSelectedStringForKey:@"Vs"];
    vsLabel.textColor=[UIColor brownColor];
    vsLabel.font=[UIFont boldSystemFontOfSize:28];
    [backgroundView addSubview:vsLabel];
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
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"selection_1.png"]];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.backgroundColor=[UIColor whiteColor];
        [scrollView addSubview:image];
    }
    //set the scroll view content size
    scrollView.contentSize = CGSizeMake(appdelegate.window.bounds.size.width *numberOfViews,100);
    scrollView.userInteractionEnabled=TRUE;
    //add the scrollview to this view
    [backgroundView addSubview:scrollView];
    
    lblPlayerSelection = [[UILabel alloc] initWithFrame:CGRectMake(50, scrollView.frame.origin.y+70, backgroundView.frame.size.width-100, 60)];
    lblPlayerSelection.textAlignment=NSTextAlignmentCenter;
    lblPlayerSelection.numberOfLines=3;
    lblPlayerSelection.lineBreakMode=NSLineBreakByCharWrapping;
    lblPlayerSelection.textColor=[UIColor blackColor];
    lblPlayerSelection.font=[UIFont boldSystemFontOfSize:15];
    lblPlayerSelection.text =@"상대가 매치업을 준비중입니다!";
    [backgroundView addSubview:lblPlayerSelection];
    
    cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(130, 420, 70, 30);
    
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [cancelBtn setTitle:[ViewController languageSelectedStringForKey:@"Cancel"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor colorWithRed:(CGFloat)198/255 green:(CGFloat)230/255 blue:(CGFloat)245/255 alpha:1.0]];
    cancelBtn.layer.borderWidth=1;
    cancelBtn.layer.borderColor=[UIColor blackColor].CGColor;
    cancelBtn.clipsToBounds=YES;
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:cancelBtn];
    //----------------------------
    if(!timerForbotPlayer)
    {
    timerForbotPlayer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(animateUSerSelection) userInfo: nil repeats:YES];
    [timerForbotPlayer fire];
    }
}
-(void)cancelBtnAction:(id)sender
{
    if([timerForbotPlayer isValid])
    {
     [timerForbotPlayer invalidate];
        timerForbotPlayer = nil;
    }
     [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    //[[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];

//    backgroundView.hidden=YES;
//    upperView.hidden=YES;
   
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
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

-(void)animateUSerSelection
{
    
    countTime++;
    
    AppDelegate *delagate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIImageView *centerImage = [[UIImageView alloc]init];
    centerImage.frame=CGRectMake(delagate.window.frame.size.width/2-40, 270, 70, 70);
    //    NSLog(@"Image =-=- %@",[arrImages objectAtIndex:countImage]);
    NSString *strImage = [arrImages objectAtIndex:countImage];
    
    centerImage.image=[UIImage imageNamed:strImage];
    
    [backgroundView addSubview:centerImage];
    
    countImage++;
    
    if (countImage>=8) {
        countImage=0;
    }
    [scrollView setContentOffset:CGPointMake(xAxis, 0) animated:YES];
    xAxis=xAxis+30;
    
    if (countTime>15)
    {
        
        if ([timerForbotPlayer isValid])
        {
            [timerForbotPlayer invalidate];
             timerForbotPlayer = nil;
            [self botPlayerDetails];
        }
    }
}
-(void)displaySelectedPlyerName
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        vsLabel.hidden=YES;
        lblPlayerSelection.text=[NSString stringWithFormat:@"Your opponent is %@", [SingletonClass sharedSingleton].strSecPlayerName];
    });
}
-(void)addLowerView
{
    AppDelegate *delagate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    //seperation line
    
        lowerView =[[UIView alloc]initWithFrame:CGRectMake(0, delagate.window.bounds.size.height/2,delagate.window.bounds.size.width, delagate.window.bounds.size.height/2)];
    lowerView.backgroundColor=[UIColor whiteColor];
    [backgroundView addSubview:lowerView];
    UIView * sepratorLine=[[UIView alloc]init];
    sepratorLine.frame=CGRectMake(0, delagate.window.bounds.size.height/2,delagate.window.bounds.size.width, 2);
    sepratorLine.backgroundColor=[UIColor blackColor];
    [backgroundView addSubview:sepratorLine];
    UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(delagate.window.bounds.size.width/2-30, 80, 60, 60)];
    imageVUser.image=[SingletonClass sharedSingleton].imageSecondPlayer;
    imageVUser.layer.cornerRadius=30;
    imageVUser.clipsToBounds=YES;
    [lowerView addSubview:imageVUser];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 150,delagate.window.bounds.size.width, 50)];
    lblName.font=[UIFont boldSystemFontOfSize:15];
    lblName.textColor=[UIColor blackColor];
    lblName.text=[SingletonClass sharedSingleton].strSecPlayerName;
    lblName.textAlignment=NSTextAlignmentCenter;
    [lowerView addSubview:lblName];
    
    UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(0, lblName.frame.origin.y+20, delagate.window.frame.size.width, 50)];
    gradeName.font=[UIFont boldSystemFontOfSize:15];
    gradeName.textColor=[UIColor blackColor];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    gradeName.textAlignment=NSTextAlignmentCenter;
    [lowerView addSubview:gradeName];
    
    
}

-(void)connectedFriend:(NSNotification *) notification
{
    [self playGame];

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

-(void)botPlayerDetails
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if([timerForbotPlayer isValid])
        {
            [timerForbotPlayer invalidate];
            timerForbotPlayer = nil;
        }
        // timer=nil;
       
    });
    
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
                    
                    [SingletonClass sharedSingleton].strSecPlayerName= [dict objectForKey:@"name"];
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
                    [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if([timerForbotPlayer isValid])
            {
                [timerForbotPlayer invalidate];
                timerForbotPlayer = nil;
            }
            // timer=nil;
            [self addLowerView];
            [self performSelector:@selector(goToGamePlayForBot:) withObject:mutDict
                       afterDelay:5];
        });

        
        
    });
    
    }
-(void)setFlagForGameRequest {
    
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

-(void)goToGamePlayForBot :(NSMutableDictionary *)dict
{
    
    [self goToGamePlayView:dict];
    [self performSelector:@selector(startGameForBot) withObject:dict afterDelay:4];
}
-(void)startGameForBot
{
    [self deleteRequest];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"startgame" object:nil];
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
                
                if (checkInternet)
                {
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
    NSNumber *level=[NSNumber numberWithInt:1];

    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
    NSLog(@"Selected SubCat Id %@",subCatID);
    [PFCloud callFunctionInBackground:@"gamestart"
                       withParameters:@{@"subcategoryid": subCatID,@"userid": [SingletonClass sharedSingleton].objectId
                                        ,@"uniqueid":[SingletonClass sharedSingleton].installationId ,@"objectid":strObjectId,@"level":level}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Response Result -==- %@", result);
//                                        if (![SingletonClass sharedSingleton].strQuestionsId.length>0)
//                                        {
                                            [SingletonClass sharedSingleton].strQuestionsId= result;
                                        //}
                                        NSLog(@"Connect to cloud");
                                    }
                                    else
                                    {
                                        NSLog(@"Error in calling CloudCode %@",error);
                                    }
                                }];
}

-(void)playGame
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //  timer=nil;

    if([timerForbotPlayer isValid])
    {
        [timerForbotPlayer invalidate];
        timerForbotPlayer = nil;
    }
    });

    
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
                    [SingletonClass sharedSingleton].strSecPlayerName=[dict objectForKey:@"name"];
                    [SingletonClass sharedSingleton].strSecPlayerRank=[dict objectForKey:@"Rank"];
                    [self displaySelectedPlyerName];
                    
                    PFFile  *strImage = [dict objectForKey:@"userimage"];
                    
                    NSData *imageData = [strImage getData];
                    UIImage *image1 = [UIImage imageWithData:imageData];
                    
                    [SingletonClass sharedSingleton].imageSecondPlayer = image1;
                }
                
               

            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
                        //  timer=nil;
            [self addLowerView];
            [self performSelector:@selector(goToGamePlayView:) withObject:self.mutDict afterDelay:6];
        });

        
    });
    
    
}

-(void)goToGamePlayView:(NSDictionary*)details
{
    
    if ([self.gameDelegate respondsToSelector:@selector(gameDetailsAnotherGame:)])
    {
        
                NSLog(@"Game Play Details %@",details);
        if(!backgroundView.hidden)
        {
        [self.gameDelegate gameDetailsAnotherGame:details];
        }
        backgroundView.hidden=YES;
        upperView.hidden=YES;
        [self deleteRequest];
    }
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
-(void)dealloc
{
  [[NSNotificationCenter defaultCenter]removeObserver:self name:@"selFriend" object:nil];
    timerForbotPlayer=nil;
    cancelBtn=nil;
}
@end
