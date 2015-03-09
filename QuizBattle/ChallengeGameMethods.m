//
//  NSObject+ChallengeGameMethods.m
//  QuizBattle
//
//  Created by GLB-254 on 1/22/15.
//  Copyright (c) 2015 GLB-254. All rights reserved.
//

#import "ChallengeGameMethods.h"
#import "GameViewControllerChallenge.h"
#import "GameViewController.h"
#import "SingletonClass.h"
#import<AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "AppDelegate.h"
@implementation ChallengeGameMethods:NSObject
#pragma mark===============================
#pragma mark Challenge UI and methods
#pragma mark===============================

-(void)challengeStartGameAction :(id)sender
{
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
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
        
        //[self performSelector:@selector(loadOponnentPlayerInChallenge) withObject:nil afterDelay:4];
    });
}

-(void)fetchApponentDetailChallenge
{
    //    [SingletonClass sharedSingleton].secondPlayerObjid=@"nFvTMPhDiZ";
    //    [SingletonClass sharedSingleton].secondPlayerInstallationId=@"708a9020-a995-4e63-9108-d27f09835821";
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            PFQuery *query = [PFUser query];
            
            [query whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].secondPlayerObjid];
            
            NSArray *arrObjectsChallenge = [query findObjects];
            [SingletonClass sharedSingleton].secondPLayerDetail=arrObjectsChallenge;
            NSLog(@"Array object Challenge Details -==- %@",arrObjectsChallenge);
            //[self.mutDict setObject:arrObjectsChallenge forKey:@"oponentPlayerDetail"];
            
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

-(void)startButtonPressed:(id) sender
{
  
    GameViewControllerChallenge *objGameChallenge = [[GameViewControllerChallenge alloc] init];
    objGameChallenge.arrPlayerDetail=dictForChallenege;
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=YES;
    if([SingletonClass sharedSingleton].roomId)
    {
        [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId
         ];
        [[WarpClient getInstance]deleteRoom:[SingletonClass sharedSingleton].roomId];
        
    }
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [SingletonClass sharedSingleton].gameFromView=true;
    [appdelegate.window setRootViewController:objGameChallenge];
}
-(void)endGame:(id)sender
{
 
    if([SingletonClass sharedSingleton].roomId)
    {
        [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId];
        [[WarpClient getInstance]deleteRoom:[SingletonClass sharedSingleton].roomId];
        
    }
    
}
-(void)fetchQuesForChallengeFromCloud
{
    //    [SingletonClass sharedSingleton].selectedSubCat=[NSNumber numberWithInt:101];
    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
    
    NSLog(@"%@second %@ selected Sub category id%@",[SingletonClass sharedSingleton].secondPlayerObjid,[SingletonClass sharedSingleton].secondPlayerInstallationId,[SingletonClass sharedSingleton].strSelectedCategoryId);
    // [self saveChallengeStatus];
    [PFCloud callFunctionInBackground:@"Challange"
                       withParameters:@{@"subcategoryid":subCatID,@"subcategoryname":[SingletonClass sharedSingleton].strSelectedSubCat,@"userid":[SingletonClass sharedSingleton].objectId,@"uniqueid":[SingletonClass sharedSingleton].installationId ,@"opppnent":[SingletonClass sharedSingleton].secondPlayerObjid, @"uniqueid1":[SingletonClass sharedSingleton].secondPlayerInstallationId,@"mainid":[SingletonClass sharedSingleton].strSelectedCategoryId
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        
                                        [SingletonClass sharedSingleton].strQuestionsId= result;
                                        [dictForChallenege setObject:result forKey:@"questionsChall"];
                                        int connectionStatus = [WarpClient getInstance].getConnectionState;
                                        
                                        if (connectionStatus != 0)
                                        {
                                            [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
                                        }
                                        else
                                        {
                                            //Room Create Main Player
                                            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
                                            NSString *dateStr = [NSString stringWithFormat:@"%ld",unixTime];
                                            [[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];
                                        }
                                        
                                        
                                        
                                        //[self.mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
                                        [self saveRequestInChallenge];
                                        
                                        [SingletonClass sharedSingleton].mainPlayerChallenge=true;
                                        //-------------
                                        NSLog(@"Response Result -==- %@", result);
                                        
                                        
                                        //Notification for challenge sukhmeet
                                        
                                        
                                        
                                        NSLog(@"Connect to cloud");
                                    }
                                }];
}
-(void)saveRequestInChallenge
{
    PFObject * challengeRequest=[PFObject objectWithClassName:@"ChallengeRequest"];
    challengeRequest[@"OpponentId"]=[SingletonClass sharedSingleton].secondPlayerObjid;
    challengeRequest[@"ChallengeStatus"]=@0;
    //challengeRequest[@"UserGameResult"]=
    challengeRequest[@"SubCategoryId"]=[SingletonClass sharedSingleton].selectedSubCat;
    challengeRequest[@"Question"]=[SingletonClass sharedSingleton].strQuestionsId;
    challengeRequest[@"SubCategoryName"]=[SingletonClass sharedSingleton].strSelectedSubCat;
    challengeRequest[@"CategoryId"]=[NSNumber numberWithInt:[[SingletonClass sharedSingleton].strSelectedCategoryId intValue]];
    challengeRequest[@"userIdPointer"]=[PFUser objectWithoutDataWithObjectId:[SingletonClass sharedSingleton].objectId];
    [challengeRequest saveInBackgroundWithBlock:^(BOOL succeded,NSError * error)
     {
         if(succeded)
         {
             
             
        }
     }
     ];
}

//-(void)playGameChallenge:(NSNotification*)notify
//{
//    [self performSelector:@selector(goToGamePlayView:) withObject:self.mutDict];
//}
-(void)goToGamePlayView:(NSDictionary*)details
{
    GameViewController * objGame=[[GameViewController alloc]init];
    objGame.arrPlayerDetail=details;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    [appdelegate.window addSubview:obj.view];
    [SingletonClass sharedSingleton].gameFromView=true;
    [appdelegate.window setRootViewController:objGame];
    
    
    //    [self.window.rootViewController presentViewController:obj
    //                                                 animated:NO
    //                                               completion:nil];
    
}
-(void)saveChallengeStatus
{
    PFObject *chStatus=[PFObject objectWithClassName:@"ChallengeRequest"];
    chStatus[@"UserId"]=[SingletonClass sharedSingleton].objectId;
    chStatus[@"OpponentId"]=[SingletonClass sharedSingleton].secondPlayerObjid;
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
