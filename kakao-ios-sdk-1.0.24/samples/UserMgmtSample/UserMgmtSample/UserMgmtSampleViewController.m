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

#import "UserMgmtSampleViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

NSString *const LogoutSuccessNotification = @"LogoutSuccessNotification";

@interface UserMgmtSampleViewController () <UITextFieldDelegate>


@property(nonatomic, retain) IBOutlet UIImageView *image;
@property(nonatomic, retain) IBOutlet UILabel *IDValueLabel;
@property(nonatomic, retain) IBOutlet UITextField *nicknameText;
@property(nonatomic, retain) IBOutlet UITextField *ageText;
@property(nonatomic, retain) IBOutlet UITextField *genderText;
@property(nonatomic, retain) IBOutlet UITextField *nameText;

@property(nonatomic, retain) IBOutlet UIButton *updateButton;
@property(nonatomic, retain) IBOutlet UIButton *signUpOrUnlinkButton;
@end

@implementation UserMgmtSampleViewController

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.title = @"UserMgmtSample";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setButtonDisabled:_signUpOrUnlinkButton];
//    [self setButtonDisabled:_updateButton];
    [_signUpOrUnlinkButton setEnabled:NO];
    [_updateButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonClicked:(id)sender {
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:self];
    }];
}

- (IBAction)meButtonClicked:(id)sender {

    __weak UserMgmtSampleViewController *weakSelf = self;
    [KOSessionTask meTaskWithCompletionHandler:^(KOUser *result, NSError *error) {

        if (result) {
            [weakSelf showProfile:result];
            [_signUpOrUnlinkButton setEnabled:YES];
            [_updateButton setEnabled:YES];

        } else {
            if (error.code == KOServerErrorNotSignedUpUser) {
                [_signUpOrUnlinkButton setTitle:@"Signup" forState:UIControlStateNormal];
                [_signUpOrUnlinkButton setEnabled:YES];
                [weakSelf alertWithTitle:@"me" message:@"please signup."];
            } else {
                [weakSelf alertWithTitle:@"me" message:@"failed."];
            }
            NSLog(@"%@", error);
        }
    }];

}

- (IBAction)updateButtonClicked:(id)sender {
    NSMutableDictionary *properties = [self getDictionary];

    __weak UserMgmtSampleViewController *weakSelf = self;
    [KOSessionTask profileUpdateTaskWithProperties:properties completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [weakSelf alertWithTitle:@"update" message:@"success"];
        } else {
            [weakSelf alertWithTitle:@"update" message:@"failed"];
            NSLog(@"%@", error);
        }
    }];
}

- (NSMutableDictionary *)getDictionary {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    if ([_nameText text].length > 0) {properties[@"name"] = [_nameText text];};
    if ([_nicknameText text].length > 0) {properties[@"nickname"] = [_nicknameText text];};
    if ([_ageText text].length > 0) {properties[@"age"] = [_ageText text];};
    if ([_genderText text].length > 0) {properties[@"gender"] = [_genderText text];};
    return properties;
}

- (IBAction)signupOrUnlinkButtonClicked:(id)sender {
    NSString *type = [[_signUpOrUnlinkButton titleLabel] text];

    __weak UserMgmtSampleViewController *weakSelf = self;

    if ([@"Signup" isEqualToString:type]) {

        NSMutableDictionary *properties = [self getDictionary];

        [KOSessionTask signupTaskWithProperties:properties completionHandler:^(BOOL success, NSError *error) {

            if (success) {
                [weakSelf alertWithTitle:@"signup" message:@"success"];
                [_signUpOrUnlinkButton setTitle:@"Unlink" forState:UIControlStateNormal];
            } else {
                [weakSelf alertWithTitle:@"signup" message:@"failed"];
                NSLog(@"%@", error);
            }
        }];
    } else if ([@"Unlink" isEqualToString:type]) {
        [KOSessionTask unlinkTaskWithCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                [_signUpOrUnlinkButton setTitle:@"Signup" forState:UIControlStateNormal];
            } else {
                [weakSelf alertWithTitle:@"unlink" message:@"failed"];
                NSLog(@"%@", error);
            }
        }];
    }

}

- (void)showProfile:(KOUser *)profile {
    NSString *imageURL;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        imageURL = [profile propertyForKey:@"thumbnail_image"];
    } else {
        imageURL = [profile propertyForKey:@"profile_image"];
    }

    [_IDValueLabel setText:profile.ID.stringValue];
    if ([imageURL isKindOfClass:[NSString class]]) {
        [_image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
    }

    [_nicknameText setText:[profile propertyForKey:@"nickname"]];
    [_ageText setText:[profile propertyForKey:@"age"]];
    [_genderText setText:[profile propertyForKey:@"gender"]];
    [_nameText setText:[profile propertyForKey:@"name"]];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)dismissKeyboard:(id)sender {
    if ([sender isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    } else {
        [_nameText resignFirstResponder];
        [_nicknameText resignFirstResponder];
        [_ageText resignFirstResponder];
        [_genderText resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return;
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 135, self.view.frame.size.width, self.view.frame.size.height);

    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return;
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];

    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 135, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

@end
