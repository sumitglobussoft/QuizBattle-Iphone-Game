//
//  GamePLayMethods.h
//  QuizBattle
//
//  Created by GLB-254 on 11/28/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol passingGameDetailsAnotherGame <NSObject>

@optional
-(void)gameDetailsAnotherGame:(NSDictionary*)details;
-(void)gameDetailsForChallenge:(NSDictionary*)details;
@end


@interface GamePLayMethods : NSObject<UIScrollViewDelegate>
{
    NSArray * arrImages;
    int countImage;
    UIScrollView *scrollView;
    UIImageView * image;
    UILabel * lblPlayerSelection;
    UIButton *cancelBtn;
    NSTimer * timerForbotPlayer;
    int countTime;
    NSString *strObjectId;
    int xAxis;
    UIView *backgroundView,*upperView;
    UIView * lowerView;
    UILabel *vsLabel;
}
@property (nonatomic,strong) NSMutableDictionary *mutDict;
@property (nonatomic, weak) id <passingGameDetailsAnotherGame>gameDelegate;

-(void)requestForGame;
-(void)playNowButtonAction;
@end
