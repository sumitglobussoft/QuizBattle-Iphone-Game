//
//  NotificationListener.m
//  AppWarp_Project
//
//  Created by Shephertz Technology on 06/08/12.
//  Copyright (c) 2012 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "NotificationListener.h"
#import "SingletonClass.h"
#import "GameViewController.h"
#import "AppDelegate.h"
@implementation NotificationListener

@synthesize helper;

-(id)initWithHelper:(id)l_helper
{
    self.helper = l_helper;
    return self;
}

-(void)onRoomCreated:(RoomData*)roomEvent{
    NSLog(@"Room Created");
}
-(void)onRoomDestroyed:(RoomData*)roomEvent{
    NSLog(@"Room Destroy");
}
-(void)onUserLeftRoom:(RoomData*)roomData username:(NSString*)username
{
    //NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Error:",@"title",@"Your enemy left the room!",@"message", nil];
    //[[AppWarpHelper sharedAppWarpHelper] onConnectionFailure:dict];
    if([username isEqualToString:[SingletonClass sharedSingleton].secondPlayerObjid])
    {
        //[SingletonClass sharedSingleton].userLeftRoom=TRUE;
    }
    
    NSLog(@"User Left the room%@",username);
    [[WarpClient getInstance] deleteRoom:roomData.roomId];
    if([SingletonClass sharedSingleton].isPlaying&&[username isEqualToString:[SingletonClass sharedSingleton].secondPlayerObjid])
    {
        [self performSelector:@selector(userLeft) withObject:nil afterDelay:2];
    }
}
-(void)userLeft
{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLeft" object:nil];
}
-(void)onUserJoinedRoom:(RoomData*)roomData username:(NSString*)username
{
    NSLog(@"Chat sender name%@",username);
    if([SingletonClass sharedSingleton].mainPlayer)
    {
         [self performSelector:@selector(sendChatMessage) withObject:nil
         afterDelay:6];
        //[self sendChatMessage];
    }
    
    if([SingletonClass sharedSingleton].mainPlayerChallenge)
    {
        [self playGameChallenge];
       //  [[NSNotificationCenter defaultCenter]postNotificationName:@"gameUiChallenge" object:nil];
        
        [self performSelector:@selector(sendChatMessage) withObject:nil
                   afterDelay:6];
        
        
        // [self performSelector:@selector(sendChatMessage) withObject:nil
                  // afterDelay:4];
        //[self sendChatMessage];
    }

    if([SingletonClass sharedSingleton].rematchSecond||[SingletonClass sharedSingleton].rematchMain)
    {
     [self playGameChallenge];
         //[[NSNotificationCenter defaultCenter]postNotificationName:@"gameUiChallenge" object:nil];
       if([SingletonClass sharedSingleton].rematchMain)
       {
           [self performSelector:@selector(sendChatMessage) withObject:nil
                      afterDelay:5];
       }
     
    }
    if([SingletonClass sharedSingleton].mainPlayerChallenge)
    {
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"gameUiChallenge" object:nil];
        
    }

}

-(void)sendChatMessage
{
    [[WarpClient getInstance] sendChat:@"start"];
}
-(void)onUserLeftLobby:(LobbyData*)lobbyData username:(NSString*)username
{
    
    
    
}
-(void)onUserJoinedLobby:(LobbyData*)lobbyData username:(NSString*)username{
    
}
-(void)onChatReceived:(ChatEvent*)chatEvent{
    
    if([chatEvent.message isEqualToString:@"start"])
    {
        NSLog(@"Chat Event Message -=-%@",chatEvent.message);
        [SingletonClass sharedSingleton].checkBotUser=NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"startgame" object:nil];
    }
        else if([chatEvent.sender isEqualToString:[SingletonClass sharedSingleton].secondPlayerObjid])
    {
        NSLog(@"Message send by sender%@",chatEvent.message);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"answerresponse" object:chatEvent.message];
    }


    
//    if([chatEvent.message isEqualToString:@"accept"])
//    {
//       
//        [self performSelector:@selector(startGameChallenge) withObject:nil afterDelay:4];
//
//      // [[NSNotificationCenter defaultCenter]postNotificationName:@"startgame" object:nil];
//    }
    if([chatEvent.message isEqualToString:@"reject"])
    {
       // [[NSNotificationCenter defaultCenter]postNotificationName:@"UserReject"
                                                        //   object:nil];
    }
//    else if([chatEvent.message isEqualToString:@"start"]&&[SingletonClass sharedSingleton].mainPlayerChallenge)
//    {
//
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"startgame" object:nil];
//        
//    }
    
    
        NSLog(@"CVhat Event Sender -=-= %@/n Object Id -==- %@",chatEvent.sender,[SingletonClass sharedSingleton].secondPlayerObjid);
}
-(void)onPrivateChatReceived:(NSString*)message fromUser:(NSString*)senderName
{
    if([senderName isEqualToString:[SingletonClass sharedSingleton].secondPlayerObjid]&&[message isEqualToString:@"reject"])
    {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserReject"
                                                           object:nil];
    }
 
}
-(void)startGameChallenge
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"startgame" object:nil];
}
#pragma mark Go To GameView
-(void)playGameChallenge
{
    NSMutableDictionary *mutDict=[[NSMutableDictionary alloc]init];
    [mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
    [mutDict setObject:[SingletonClass sharedSingleton].secondPLayerDetail forKey:@"oponentPlayerDetail"];
    
    [self performSelector:@selector(goToGamePlayView:) withObject:mutDict];
}
-(void)goToGamePlayView:(NSDictionary*)details
{
    
    [SingletonClass sharedSingleton].gameFromView=true;
    GameViewController * objGame=[[GameViewController alloc]init];
    objGame.arrPlayerDetail=details;
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     //[appdelegate.window addSubview:objGame.view];
    [SingletonClass sharedSingleton].gameFromView=true;
    [appdelegate.window setRootViewController:objGame];
}


-(void)onUpdatePeersReceived:(UpdateEvent*)updateEvent
{
}

-(void)onUserPaused:(NSString *)userName withLocation:(NSString *)locId isLobby:(BOOL)isLobby
{
    NSLog(@"%s..username=%@",__FUNCTION__,userName);
    NSLog(@"locId=%@",locId);
    NSLog(@"isLobby=%d",isLobby);
}

-(void)onUserResumed:(NSString *)userName withLocation:(NSString *)locId isLobby:(BOOL)isLobby
{
    NSLog(@"%s..username=%@",__FUNCTION__,userName);
    NSLog(@"locId=%@",locId);
    NSLog(@"isLobby=%d",isLobby);
}

-(void)onUserChangeRoomProperty:(RoomData *)event username:(NSString *)username properties:(NSDictionary *)properties lockedProperties:(NSDictionary *)lockedProperties
{
    
}

-(void)onMoveCompleted:(MoveEvent *)moveEvent
{
    
}



-(void)onGameStarted:(NSString*)sender roomId:(NSString*)roomId  nextTurn:(NSString*)nextTurn
{
    
}
-(void)onGameStopped:(NSString*)sender roomId:(NSString*)roomId
{
    
}

@end
