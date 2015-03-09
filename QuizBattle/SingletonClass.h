//
//  SingletonClass.h
//  QuizBattle
//
//  Created by GBS-mac on 8/22/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonClass : NSObject

@property (nonatomic,strong) NSNumber *selectedSubCat;
@property (nonatomic,assign) NSNumber *popularityScore;
@property (nonatomic,strong) NSData *deviceToken;
//--------
@property (nonatomic,strong) UIImage *imageUser;
@property (nonatomic,strong) UIImage *imageSecondPlayer;
//--------
@property (nonatomic,strong) NSString *installationId,*secondPlayerInstallationId;
@property (nonatomic,strong) NSString *discussionObjectId,*strCountry;
@property (nonatomic,strong) NSString *strQuestionsId,*totalXp;
@property (nonatomic,strong) NSString *objectId,*secondPlayerObjid,*quickBloxId;
@property (nonatomic,strong) NSString *strSelectedSubCat,*imageFileUrl,*strSelectedCategoryId;
@property (nonatomic,strong) NSString *strUserName,*roomNo,*roomId;
@property (nonatomic,strong) NSString *strSecPlayerName,*userRank,*strSecPlayerRank,*challengeRequestObjId;
@property (nonatomic) int updatePreviousView;
//-------
@property (nonatomic) BOOL mainPlayer,secondPlayer,errorRoomid,connectedNot;
@property (nonatomic) BOOL checkBotUser,isPlaying,boosterEnable;
@property (nonatomic) BOOL singleGameChallengedPlayer,secondPlayerChallenge,mainPlayerChallenge,rematchMain,rematchSecond;
@property (nonatomic) BOOL profileForSecondUser,userLeftRoom,challStartCase;
@property (nonatomic) BOOL pickFriendsChallenge,gameFromView;
//-------
@property (nonatomic,strong) NSArray * dialogsId,*userDetailinParse,*secondPLayerDetail,*subCatData,*userBlockList;
@property (nonatomic,strong) NSMutableArray *fbfriendsId;
@property (nonatomic,strong) NSMutableArray *fbfriendsName;
@property (nonatomic,strong) NSMutableArray *fbfriendsImage;
@property (nonatomic,strong) id view;
 
+(SingletonClass*)sharedSingleton;
@end
