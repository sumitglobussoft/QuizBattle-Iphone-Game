//
//  LogInViewController.h
//  QuizBattle
//
//  Created by Sumit Ghosh on 24/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMenuViewController.h"
#import "HomeViewController.h"
@interface LogInViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *txtFUsername;
     UITextField *txtfEmail;
    UITextField *txtFPass;
    BOOL checkEmail;
    NSString *strUserObjectId;
    UIButton * forgotpswd;
    UIButton *backbtn;
    UIButton * sendButton;
    BOOL frgtPswClick;
    UIImageView *envelopeImage;
    UIImageView *passwrdImage;
    UILabel *lblHeader;
    UILabel *sendlnktoEmail;
    UIButton *btnNext;
    //UIView *frgtpsrdView;
    UIView *customHedrViewfrgtpswd;
}
@property(nonatomic,strong)UIView *frgtpsrdView;
+(CustomMenuViewController*)goTOHomeView;
@end
