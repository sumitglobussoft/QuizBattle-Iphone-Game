/**
* Copyright 2014 Kakao Corp.
*
* Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#import "PushSampleLoginViewController.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

#define OS_VER [[[UIDevice currentDevice] systemVersion] floatValue]


@interface PushSampleLoginViewController ()

@end

@implementation PushSampleLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // background image
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];


    UIImage *bgImage;

    if ((int) (screenBounds.size.height / 100) != 5) {
        bgImage = [UIImage imageNamed:@"Default.png"];
    } else {
        bgImage = [UIImage imageNamed:@"Default-568h@2x.png"];
    }

    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];

    CGRect bgImageViewFrame;
    if (OS_VER >= 7.0f) {
        bgImageViewFrame = CGRectMake(0,
                0,
                screenBounds.size.width,
                screenBounds.size.height);
    } else {
        bgImageViewFrame = CGRectMake(0,
                0 - statusBarFrame.size.height,
                screenBounds.size.width,
                screenBounds.size.height);
    }
    bgImageView.frame = bgImageViewFrame;
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    [self.view addSubview:bgImageView];

    // button display
    UIButton *kakaoAccountConnectButton = [self createKakaoAccountConnectButton];
    [self.view addSubview:kakaoAccountConnectButton];

    NSLog(@"[DEBUG] login view did load");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - custom methods

- (UIButton *)createKakaoAccountConnectButton {
    // button position
    int xMargin = 30;
    int marginBottom = 25;
    CGFloat btnWidth = self.view.frame.size.width - xMargin * 2;
    int btnHeight = 42;

    UIButton *btnKakaoLogin
            = [[KOLoginButton alloc] initWithFrame:CGRectMake(xMargin, self.view.frame.size.height - btnHeight - marginBottom, btnWidth, btnHeight)];
    btnKakaoLogin.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

    // action
    [btnKakaoLogin addTarget:self
                      action:@selector(invokeLoginWithTarget:)
            forControlEvents:UIControlEventTouchUpInside];

    return btnKakaoLogin;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - actions

- (IBAction)invokeLoginWithTarget:(id)sender {
    [[KOSession sharedSession] close];

    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {

        if ([[KOSession sharedSession] isOpen]) {
            // login success.
            NSLog(@"login success.");
            [self dismissViewControllerAnimated:YES
                                     completion:^(void) {
                                     }];

        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:nil];
            [alertView show];
        }

    }];
}

- (IBAction)invokeCancelLoginWithTarget:(id)sender {
    [[KOSession sharedSession] close];
}

- (IBAction)invokeToggleStatusBar:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].statusBarHidden withAnimation:UIStatusBarAnimationFade];
}


@end
