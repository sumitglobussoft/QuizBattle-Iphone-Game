//
//  SaveGameOverData.h
//  QuizBattle
//
//  Created by GLB-254 on 3/2/15.
//  Copyright (c) 2015 GLB-254. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveGameOverData : NSObject
{
    int sumFirstPlayer,sumSecondPlayer;
}
@property(nonatomic,strong)NSMutableArray *arrPlayer1Scores,*arrScreenshotImages;
;
@property (nonatomic,strong) NSString * challengeReqObjId,*gameResultObjectId;

@property (nonatomic,strong) NSArray * opponenetScore,*questionsData;
-(void)gameOverDataSaved;
@end
