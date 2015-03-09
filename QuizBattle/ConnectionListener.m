 //
//  ConnectionListener.m
//  Cocos2DSimpleGame
//
//  Created by Rajeev on 23/01/13.
//
//
#define APPWARP_APP_KEY     @"02b9e4acba991fee662a295dc69c438c9b0f9b0d173b1b78fcbea0d800d9565b"
#define APPWARP_SECRET_KEY  @"3baf02cd51f48d50c32274dfaa4e48b16257870b693d447e461c73db03ed9c41"
#import "ConnectionListener.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import <Parse/Parse.h>
#import "SingletonClass.h"
@implementation ConnectionListener
@synthesize helper;

-(id)initWithHelper:(id)l_helper
{
    self.helper = l_helper;
    return self;
}

-(void)onConnectDone:(ConnectEvent*) event
{
   // NSLog(@"%s...name=%@",__FUNCTION__,[helper userName]);
    if (event.result==SUCCESS)
    {
        NSLog(@"Connection Done");
        //-------------
      //  UIAlertView * alertConnectoin=[[UIAlertView alloc]initWithTitle:@"Connection Alert" message:@"Connected with Appwrap" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //[alertConnectoin show];
        //----------------
//        time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
//        NSString *dateStr = [NSString stringWithFormat:@"%ld",unixTime];
       
        if([SingletonClass sharedSingleton].mainPlayer)
        {
          //  [[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];

        }
        
        if([SingletonClass sharedSingleton].errorRoomid)
        {
          [[WarpClient getInstance]joinRoom:[SingletonClass sharedSingleton].roomId];
        }
        
        //Room Create Main Player
        if([SingletonClass sharedSingleton].mainPlayerChallenge)
        {

        //[[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];
        }
        
        //----------
        if([SingletonClass sharedSingleton].connectedNot)
        {
            [SingletonClass sharedSingleton].connectedNot=FALSE;
            //---------------Create Room------------
            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
            NSString *dateStr = [NSString stringWithFormat:@"%ld",unixTime];
            [[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];
        }
        
            //[[WarpClient getInstance]joinRoom:[SingletonClass sharedSingleton].roomId];
        
        //[[WarpClient getInstance] joinRoom:[[AppWarpHelper sharedAppWarpHelper] roomId]];
       // [[WarpClient getInstance] joinRoomInRangeBetweenMinUsers:0 andMaxUsers:1 maxPrefered:YES];
    }
    else if (event.result==SUCCESS_RECOVERED)
    {
        NSLog(@"connection recovered");
    }
    else if (event.result==CONNECTION_ERROR_RECOVERABLE)
    {
        NSLog(@"recoverable connection error");
        [[WarpClient getInstance]recoverConnection];
        if([SingletonClass sharedSingleton].isPlaying)
        {
            
        }
        
    }
    else if (event.result==BAD_REQUEST)
    {
        
        NSLog(@"Bad request");
    }
    else
    {
        NSLog(@"Disconnected %d",event.result);
        if(event.result==1)
        {
//        [WarpClient initWarp:APPWARP_APP_KEY secretKey:APPWARP_SECRET_KEY];
//        WarpClient *warpClient = [WarpClient getInstance];
            [[WarpClient getInstance]disconnect];
            
            [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
        }
        
       
//        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Connection Error:",@"title",@"Please check ur internet connection!",@"message", nil];
        /*if(event.result==1)
        {
            //[[WarpClient getInstance]disconnect];
            
            static int i=1;
            NSString *name=[NSString stringWithFormat:@"error%d",i];
            [[WarpClient getInstance] connectWithUserName:name];
            i++;
        }*/

    }
}


-(void)onJoinZoneDone:(ConnectEvent*) event
{
    if (event.result==0)
    {
        NSLog(@"Join Zone done");
        
        //[[WarpClient getInstance] joinRoom:[[AppWarpHelper sharedAppWarpHelper] roomId]];
    }
    else
    {
        NSLog(@"Join Zone failed");
    }

}


-(void)onAuthenticationDone:(ConnectEvent*) event
{
    if(event.result == SUCCESS)
    {
        NSLog(@"I am authenticated");
    }
}

-(void)onDisconnectDone:(ConnectEvent*) event
{
    NSLog(@"On Disconnect invoked");
   
}

-(void)onGetMatchedRoomsDone:(MatchedRoomsEvent *)event
{
    
}

-(void)onInitUDPDone:(Byte)result
{
    
}
#pragma mark ------
#pragma mark ZoneListener Protocol methods


-(void)onCreateRoomDone:(RoomEvent*)roomEvent{
//    RoomData *roomData = roomEvent.roomData;
    NSLog(@"roomEvent result = %i",roomEvent.result);
    
    RoomData *roomData=roomEvent.roomData;
    NSLog(@"Room iD -=-=-=%@",roomData.roomId);
    [SingletonClass sharedSingleton].roomId=roomData.roomId;
    NSDictionary *data;
    //----------Push for Main Game----------
    if([SingletonClass sharedSingleton].mainPlayer)
    {
        [[WarpClient getInstance]joinRoom:roomData.roomId];
    
   data = @{
                           @"Type": @"500",@"roomid": roomData.roomId,@"action": @"com.quizbattle.welcome.UPDATE_STATUS",
                           };
    }
    NSLog(@"OPoonent Player Usre ID-==-%@ \n\n Installation ID=--=%@",[SingletonClass sharedSingleton].secondPlayerObjid,[SingletonClass sharedSingleton].secondPlayerInstallationId);
       
    //---------------------Push for challenge----------------
    if([SingletonClass sharedSingleton].mainPlayerChallenge&&(roomData.roomId!=nil))
    {
        //[SingletonClass sharedSingleton].secondPlayerObjid=@"nFvTMPhDiZ";
        //[SingletonClass sharedSingleton].secondPlayerInstallationId=@"b540f711-432a-4edf-b0a7-e45babd8ae4d";
        [[WarpClient getInstance]joinRoom:roomData.roomId];
        
   
                data= @{@"Type": @"700",@"roomid": roomData.roomId,@"action": @"com.quizbattle.welcome.UPDATE_STATUS",
                               };
    }
    //---------------------Push For Rematch---------------------
    if([SingletonClass sharedSingleton].rematchMain&&(roomData.roomId!=nil))
    {
        [[WarpClient getInstance]joinRoom:roomData.roomId];
        data= @{@"Type":@"160",@"roomid": roomData.roomId,@"action": @"com.quizbattle.welcome.UPDATE_STATUS",
                };
    }
    NSLog(@"OPoonent Player User ID-==-%@ \n\n Installation ID=--=%@",[SingletonClass sharedSingleton].secondPlayerObjid,[SingletonClass sharedSingleton].secondPlayerInstallationId);
     //[SingletonClass sharedSingleton].secondPlayerObjid = @"JpgQjfIHYS";
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].secondPlayerObjid];
       [pushQuery whereKey:@"installationId" equalTo:[SingletonClass sharedSingleton].secondPlayerInstallationId];
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery];
        [push setData:data];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if (succeeded) {
                    NSLog(@"Successful Push send");
                }
            } else {
                NSLog(@"Push sending error: %@", [error userInfo]);
            }
        }];
}

-(void)onDeleteRoomDone:(RoomEvent*)roomEvent{
  
    if (roomEvent.result == SUCCESS)
    {
    }
    else {
    }
}

-(void)onGetAllRoomsDone:(AllRoomsEvent*)event{
    if (event.result == SUCCESS) {
        //[[WarpClient getInstance]getOnlineUsers];
    }
    else {
    }
}
-(void)onGetOnlineUsersDone:(AllUsersEvent*)event{
    if (event.result == SUCCESS)
    {
        NSLog(@"usernames = %@",event.userNames);
//        int userCount = [event.userNames count];
//        [[AppWarpHelper sharedAppWarpHelper] setNumberOfPlayers:userCount];
//        if (userCount==2)
//        {
//            
//        }
    }
    else 
    {
        
    }
    
}
-(void)onGetLiveUserInfoDone:(LiveUserInfoEvent*)event{
    NSLog(@"onGetLiveUserInfo called");
    if (event.result == SUCCESS)
    {
        //[[WarpClient getInstance]setCustomUserData:event.name customData:usernameTextField.text];
    }
    else {
    }
    
}
-(void)onSetCustomUserDataDone:(LiveUserInfoEvent*)event{
    if (event.result == SUCCESS) {
    }
    else {
    }
}




@end
