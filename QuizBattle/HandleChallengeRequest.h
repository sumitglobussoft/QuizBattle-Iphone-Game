//
//  HandleChallengeRequest.h
//  QuizBattle
//
//  Created by GLB-254 on 10/28/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleChallengeRequest : NSObject
{
    UIImageView *imageVAnim;
    
}
@property (nonatomic, strong) UIView *topViewChallenge;
@property(nonatomic,strong) UIImage *PlayerIcon;
@property (nonatomic,strong) UIImageView * iconImg,* themImgView,* profileImgView;
@property (nonatomic,strong) NSMutableDictionary *mutDict;
@property (nonatomic) BOOL startButtonChallenge;
@end
