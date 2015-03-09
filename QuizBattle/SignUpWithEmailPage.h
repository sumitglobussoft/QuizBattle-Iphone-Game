//
//  SignUpWithEmailPage.h
//  QuizBattle
//
//  Created by GBS-mac on 8/7/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SignUpWithEmailPage : UIViewController<UITextFieldDelegate,UIWebViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
 
    UITextField *txtFEmail;
    UITextField *txtFPass;
    UITextField *txtFCountry;
    BOOL checkEmail;
    UIImageView *envelopeImage,*passwrdImage,*countryIconImage,*imageVAnim;
    BOOL checkMarkFirstInd,checkMarkSecondInd,checkMarkThirdInd,checkMarkFourthInd;
    UIWebView *webView;
    UIPickerView * myPickerView;
    UIButton * checkMarkFirst,*checkMarkSecond,*checkMarkThird,*checkMarkFourth;
    NSArray * pickerArray;
}
@property (nonatomic, strong) NSString *strUserName;
@property (nonatomic, strong) NSString *strBirthday;
@property (nonatomic, strong) NSData *dataImage;

@end
