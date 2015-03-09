//
//  ViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <Parse/Parse.h>
#import "SettingsViewController.h"
@class SettingsViewController;

@interface ViewController : UIViewController <passingSettingDetails>{
    
    UIButton *btnFbConnect;
    UIButton *btnLoginNow;
    UIView * rejectView;
    UILabel *lblFbConnect;
    UIImageView * imageViewBackground,*imageVAnim;
    UILabel *headerLabel;
    UILabel *kkLabel;
    UIButton *emailLogIn;
    UIButton *emailRegistration;
    UIButton *kkTalkbtn;
    NSUserDefaults * userDefault;
    NSString * strUserObjectId;
    NSString * username;
    NSString* password;
    NSString *kakaoId;
    NSString *kakaousrnme,*friendName;
    PFFile *imgFile;
    BOOL flag_Kakao;
}
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
+(NSString*) languageSelectedStringForKey:(NSString*) key;
+ (BOOL)networkCheck;
@end
