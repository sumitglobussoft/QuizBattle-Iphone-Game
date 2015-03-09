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

#import "KakaoTalkSampleViewController.h"
#import "KakaoTalkSampleAppDelegate.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface KakaoTalkSampleViewController ()

@property(nonatomic, retain) IBOutlet UIImageView *image;
@property(nonatomic, retain) IBOutlet UILabel *countryISOLabel;
@property(nonatomic, retain) IBOutlet UILabel *nicknameLabel;

@end

@implementation KakaoTalkSampleViewController

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.title = @"KakaoTalkSample";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonClicked:(id)sender {
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(showLoginView)];
    }];
}

- (IBAction)talkProfileButtonClicked:(id)sender {

    [KOSessionTask talkProfileTaskWithCompletionHandler:^(KOTalkProfile *result, NSError *error) {

        if (result) {
            [self showProfile:result];
        } else {
            NSLog(@"%@", error);
        }
    }];

}

- (void)showProfile:(KOTalkProfile *)profile {
    NSString *imageURL = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? profile.thumbnailURL : profile.profileImageURL;

    [_image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
    [_nicknameLabel setText:profile.nickName];
    [_countryISOLabel setText:profile.countryISO];

}

@end
