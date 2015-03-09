 //
//  RoomListener.m
//  AppWarp_Project
//
//  Created by Shephertz Technology on 06/08/12.
//  Copyright (c) 2012 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "RoomListener.h"
#import "SingletonClass.h"

@implementation RoomListener

@synthesize helper;

-(id)initWithHelper:(id)l_helper
{
    self.helper = l_helper;
    return self;
}

-(void)onLockPropertiesDone:(Byte)result
{
    
}
-(void)onUnlockPropertiesDone:(Byte)result
{
    
}
-(void)onUpdatePropertyDone:(LiveRoomInfoEvent *)event
{
    
}

-(void)onerRoomDone:(RoomEvent*)roomEvent{
    
    if (roomEvent.result == SUCCESS)
    {
        //[[WarpClient getInstance]setCustomRoomData:roomEvent.roomData.roomId roomData:@"custom room data set"];
        NSLog(@"onSubscribeRoomDone  SUCCESS");
    }
    else
    {
        NSLog(@"onSubscribeRoomDone  Failed");
    }
}
-(void)onUnSubscribeRoomDone:(RoomEvent*)roomEvent
{
    if (roomEvent.result == SUCCESS)
    {
        
    }
    else
    {
        
    }
}
-(void)onJoinRoomDone:(RoomEvent*)roomEvent
{
    NSLog(@"Error for roomJoin%d",roomEvent.result);
    
    RoomData *roomData = roomEvent.roomData;
    if (roomEvent.result == SUCCESS)
    {
        [[WarpClient getInstance]subscribeRoom:roomData.roomId];
        
        NSLog(@".onJoinRoomDone..on Join room listener called Success");
    }
    else
    {
        [SingletonClass sharedSingleton].userLeftRoom=TRUE;
        [[WarpClient getInstance]unsubscribeRoom:roomData.roomId];
        if ([SingletonClass sharedSingleton].mainPlayer == true) {
            [[WarpClient getInstance] deleteRoom:roomData.roomId];
        }
        NSLog(@".onJoinRoomDone..on Join room listener called failed");
        // [[WarpClient getInstance] createRoomWithRoomName:@"namenew" roomOwner:@"sukhmeetnew" properties:nil maxUsers:2];
    }
    if(roomEvent.result==5)
    {
        int connectionStatus=[[WarpClient getInstance] getConnectionState];
        NSLog(@"Connection Status in error Room Join %d",connectionStatus);
        [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
        [SingletonClass sharedSingleton].errorRoomid=TRUE;
    }
        
}

-(void)onLeaveRoomDone:(RoomEvent*)roomEvent{
    if (roomEvent.result == SUCCESS) {
        //[[WarpClient getInstance]unsubscribeRoom:roomEvent.roomData.roomId];
    }
    else {
    }
}
-(void)onGetLiveRoomInfoDone:(LiveRoomInfoEvent*)event{
    NSString *joinedUsers = @"";
    NSLog(@"joined users array = %@",event.joinedUsers);
    
    for (int i=0; i<[event.joinedUsers count]; i++)
    {
        joinedUsers = [joinedUsers stringByAppendingString:[event.joinedUsers objectAtIndex:i]];
    }
}
-(void)onSetCustomRoomDataDone:(LiveRoomInfoEvent*)event{
    NSLog(@"event joined users = %@",event.joinedUsers);
    NSLog(@"event custom data = %@",event.customData);

}
-(void)onSubscribeRoomDone:(RoomEvent*)roomEvent
{
    NSLog(@"Onsubscribe result %hhu",roomEvent.result);
    
}

@end
