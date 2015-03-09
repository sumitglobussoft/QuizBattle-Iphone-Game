//
//  HandleChallengeRequest.m
//  QuizBattle
//
//  Created by GLB-254 on 10/28/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//
#import "AppDelegate.h"
#import "HandleChallengeRequest.h"
#import "SingletonClass.h"
#import "GameViewController.h"
#import <Parse/Parse.h>

@implementation HandleChallengeRequest
#pragma mark===============================
#pragma mark Challenge UI and methods
#pragma mark===============================

-(void)challengeStartGameAction :(id)sender
{
    self.startButtonChallenge=TRUE;
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    
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

-(void)fetchApponentDetailChallenge
{
    [SingletonClass sharedSingleton].secondPlayerObjid = @"sEV7PB9FpG";
    
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            PFQuery *query = [PFUser query];
            
            [query whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].secondPlayerObjid];
            
            NSArray *arrObjectsChallenge = [query findObjects];
            NSLog(@"Array object Challenge Details -==- %@",arrObjectsChallenge);
            [self.mutDict setObject:arrObjectsChallenge forKey:@"oponentPlayerDetail"];
            
            NSDictionary *dict = [arrObjectsChallenge objectAtIndex:0];
            
            NSString *strName = [dict objectForKey:@"username"];
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





-(void)loadOponnentPlayerInChallenge {
    
    [imageVAnim stopAnimating];
    UIImageView *imageVsecPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, self.view.bounds.size.height-250)];
    imageVsecPlayer.backgroundColor=[UIColor lightGrayColor];
    [self.topViewChallenge addSubview:imageVsecPlayer];
    
    UIImageView *profileImgSecPlayer=[[UIImageView alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height-180, 80, 80)];
    profileImgSecPlayer.layer.cornerRadius=40;
    profileImgSecPlayer.layer.borderWidth=2.0f;
    profileImgSecPlayer.layer.borderColor=[UIColor redColor].CGColor;
    profileImgSecPlayer.layer.masksToBounds=YES;
    profileImgSecPlayer.backgroundColor=[UIColor yellowColor];
    profileImgSecPlayer.image=[SingletonClass sharedSingleton].imageSecondPlayer;
    [self.topViewChallenge addSubview:profileImgSecPlayer];
    
    UILabel * playerName=[[UILabel alloc]initWithFrame:CGRectMake(105,self.view.bounds.size.height-170,210,20)];
    playerName.textAlignment=NSTextAlignmentLeft;
    playerName.text=[SingletonClass sharedSingleton].strSecPlayerName;
    playerName.textColor=[UIColor whiteColor];
    [self.topViewChallenge addSubview:playerName];
    
    UILabel * gradeName=[[UILabel alloc]initWithFrame:CGRectMake(105,self.view.bounds.size.height-140,100, 20)];
    gradeName.text=[SingletonClass sharedSingleton].strSecPlayerRank;
    gradeName.textColor=[UIColor whiteColor];
    [self.topViewChallenge addSubview:gradeName];
    
    UILabel * countryName=[[UILabel alloc]initWithFrame:CGRectMake(160, self.view.bounds.size.height-100, 120, 60)];
    countryName.numberOfLines=0;
    countryName.text=@"Playing from\nINDIA";
    countryName.textColor=[UIColor whiteColor];
    [self.topViewChallenge addSubview:countryName];
    
    [self performSelector:@selector(goToGamePlayViewChallenge:) withObject:[SingletonClass sharedSingleton].strQuestionsId afterDelay:2];
    
}

-(void)fetchQuesForChallengeFromCloud
{
    //    [SingletonClass sharedSingleton].selectedSubCat=[NSNumber numberWithInt:101];
    //    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
    NSLog(@"%@second %@",[SingletonClass sharedSingleton].secondPlayerObjid,[SingletonClass sharedSingleton].secondPlayerInstallationId);
    [self saveChallengeStatus];
    [PFCloud callFunctionInBackground:@"Challange"
                       withParameters:@{@"subcategoryid":@101,@"userid": [SingletonClass sharedSingleton].objectId,@"uniqueid":[SingletonClass sharedSingleton].installationId ,@"opppnent":[SingletonClass sharedSingleton].secondPlayerObjid, @"uniqueid1":[SingletonClass sharedSingleton].secondPlayerInstallationId
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        
                                        
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
                                            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playGameChallenge:) name:@"gameUiChallenge" object:self.mutDict];
                                            
                                            
                                        }
                                        
                                        NSLog(@"Connect to cloud");
                                    }
                                }];
}
-(void)playGameChallenge:(NSDictionary*)details
{
    [self performSelector:@selector(goToGamePlayView:) withObject:details
               afterDelay:3];
}
-(void)goToGamePlayView:(NSDictionary*)details
{
    GameViewController * obj=[[GameViewController alloc]init];
    obj.arrPlayerDetail=details;
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    //    [appdelegate.window addSubview:obj.view];
    [appdelegate.window setRootViewController:obj];
    
    
    //    [self.window.rootViewController presentViewController:obj
    //                                                 animated:NO
    //                                               completion:nil];
    
}
-(void)saveChallengeStatus
{
    PFObject *chStatus=[PFObject objectWithClassName:@"ChallengeRequest"];
    chStatus[@"UserId"]=[SingletonClass sharedSingleton].objectId;
    chStatus[@"OpponenetId"]=[SingletonClass sharedSingleton].secondPlayerObjid;
    chStatus[@"ChallengeStatus"]=@0;
    [chStatus saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
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
    }
     ];
    
}




@end
