//
//  SaveGameOverData.m
//  QuizBattle
//
//  Created by GLB-254 on 3/2/15.
//  Copyright (c) 2015 GLB-254. All rights reserved.
//

#import "SaveGameOverData.h"
#import "SingletonClass.h"
#import "ViewController.h"
#import <Parse/Parse.h>
@implementation SaveGameOverData

-(void)gameOverDataSaved
{
    //Saving challenge Data
    PFObject *object = [PFObject objectWithClassName:@"GameResult"];
    object[@"UserId"]=[SingletonClass sharedSingleton].objectId;
    object[@"userscore"]=self.arrPlayer1Scores;
    object[@"SubCategoryId"]=[SingletonClass sharedSingleton].selectedSubCat;
    object[@"CategoryName"]=[SingletonClass sharedSingleton].strSelectedSubCat;
    object[@"Opponent"]=[PFUser objectWithoutDataWithObjectId:[SingletonClass sharedSingleton].secondPlayerObjid];
    object[@"CategoryId"]=[NSNumber numberWithInt:[[SingletonClass sharedSingleton].strSelectedCategoryId intValue]];
    object[@"winnerstatus"]=@0;
    if([SingletonClass sharedSingleton].checkChallengedPlayer)
    {
        object[@"challengestatus"]=@NO;
        object[@"winnerstatus"]=@0;
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        object[@"opponentscore"]=arr;
    }
    else
    {
        NSLog(@"Opponenet Score %@",self.opponenetScore);
        if(self.opponenetScore)//if user data is not saved
        {
            object[@"opponentscore"]=self.opponenetScore;
            object[@"challengestatus"]=@YES;
            sumFirstPlayer=0;
            sumSecondPlayer=0;
            for(int i=0;i<[self.arrPlayer1Scores count];i++)
            {
                sumFirstPlayer=sumFirstPlayer+[[self.arrPlayer1Scores objectAtIndex:i] intValue];
                sumSecondPlayer=sumSecondPlayer+[[self.opponenetScore objectAtIndex:i] intValue];
                
            }
            if(sumSecondPlayer>sumFirstPlayer)
            {
                object[@"winnerstatus"]=@0;
            }
            else
            {
                object[@"winnerstatus"]=@1;
            }
            
        }
    }
    
    //update gameresult in challengerequest
    if([SingletonClass sharedSingleton].checkChallengedPlayer)
    {
        dispatch_async(GCDBackgroundThread, ^{
            @autoreleasepool {
                [object save];
                PFQuery * challReqUpdate=[PFQuery queryWithClassName:@"ChallengeRequest"];
                [challReqUpdate whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].challengeRequestObjId];
                NSArray * temp=[challReqUpdate findObjects];
                if([temp count]>0)
                {
                    PFObject * objChallReq=[temp objectAtIndex:0];
                    NSLog(@"Object Id %@",object.objectId);
                    objChallReq[@"UserGameResult"]=[object objectId];
                    
                    if(sumSecondPlayer>sumFirstPlayer)
                    {
                        object[@"winnerstatus"]=@1;
                    }
                    else
                    {
                        object[@"winnerstatus"]=@0;
                    }
                    
                    [objChallReq saveInBackground];
                }
            }
            
        });
        
    }
    
    UIImage *image1 = [self.arrScreenshotImages objectAtIndex:0];
    NSData *imageData1 = UIImageJPEGRepresentation(image1, 0.05f);
    
    UIImage *image2 = [self.arrScreenshotImages objectAtIndex:1];
    NSData *imageData2 = UIImageJPEGRepresentation(image2, 0.05f);
    
    UIImage *image3 = [self.arrScreenshotImages objectAtIndex:2];
    NSData *imageData3 = UIImageJPEGRepresentation(image3, 0.05f);
    
    UIImage *image4 = [self.arrScreenshotImages objectAtIndex:3];
    NSData *imageData4 = UIImageJPEGRepresentation(image4, 0.05f);
    
    UIImage *image5 = [self.arrScreenshotImages objectAtIndex:4];
    NSData *imageData5 = UIImageJPEGRepresentation(image5, 0.05f);
    
    UIImage *image6 = [self.arrScreenshotImages objectAtIndex:5];
    NSData *imageData6 = UIImageJPEGRepresentation(image6, 0.05f);
    
    UIImage *image7 = [self.arrScreenshotImages objectAtIndex:6];
    NSData *imageData7 = UIImageJPEGRepresentation(image7, 0.05f);
    
    PFFile *imageFile1 = [PFFile fileWithName:@"Screenshot1.jpg" data:imageData1];
    PFFile *imageFile2 = [PFFile fileWithName:@"Screenshot2.jpg" data:imageData2];
    PFFile *imageFile3 = [PFFile fileWithName:@"Screenshot3.jpg" data:imageData3];
    PFFile *imageFile4 = [PFFile fileWithName:@"Screenshot4.jpg" data:imageData4];
    PFFile *imageFile5 = [PFFile fileWithName:@"Screenshot5.jpg" data:imageData5];
    PFFile *imageFile6 = [PFFile fileWithName:@"Screenshot6.jpg" data:imageData6];
    PFFile *imageFile7 = [PFFile fileWithName:@"Screenshot7.jpg" data:imageData7];
    object[@"screenshot1"]=imageFile1;
    object[@"screenshot2"]=imageFile2;
    object[@"screenshot3"]=imageFile3;
    object[@"screenshot4"]=imageFile4;
    object[@"screenshot5"]=imageFile5;
    object[@"screenshot6"]=imageFile6;
    object[@"screenshot7"]=imageFile7;
    [object saveInBackgroundWithBlock:^(BOOL succeed, NSError *error)
     {
         if (succeed)
         {
             NSLog(@"Save to Parse");
             NSLog(@"Object Id og Game Result Challenge%@",[object objectId]);
             
             if(![SingletonClass sharedSingleton].checkChallengedPlayer)
             {
                 if(![SingletonClass sharedSingleton].challStartCase)
                 {
                     //update opponenet game result
                     [self updateGameResult];
                 }
             }
             //}
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
#pragma mark Update the Game Result
-(void)updateGameResult
{
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            PFQuery * updateOpponentGameResult=[PFQuery queryWithClassName:@"GameResult"];
            if(self.challengeReqObjId)
            {
                [updateOpponentGameResult whereKey:@"objectId" equalTo:self.challengeReqObjId];
            }
            else
            {
                if([SingletonClass sharedSingleton].challengeRequestObjId)
                {
                    [updateOpponentGameResult whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].challengeRequestObjId];
                }
            }
            NSArray * temp=[updateOpponentGameResult findObjects];
            if([temp count]>0)
            {
                PFObject *updateObj=[temp objectAtIndex:0];
                updateObj[@"opponentscore"]=self.arrPlayer1Scores;
                [updateObj saveInBackground];
            }
            
        }
        [self callCloudChallenge];
    });
    
}
-(void)updateGameResultMainPlayer
{
    
}
-(void)callCloudChallenge
{
    [PFCloud callFunctionInBackground:@"update"
                       withParameters:@{@"objectid1": [SingletonClass sharedSingleton].objectId,@"objectid2":[SingletonClass sharedSingleton].secondPlayerObjid}
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

-(void)dealloc
{
    self.arrPlayer1Scores=nil;
    self.arrScreenshotImages=nil;
    self.challengeReqObjId=nil;
    
}


@end
